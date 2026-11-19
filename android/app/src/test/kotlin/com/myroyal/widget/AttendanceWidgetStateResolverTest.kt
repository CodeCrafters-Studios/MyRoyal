package com.myroyal.widget

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDateTime
import java.time.ZoneId

class AttendanceWidgetStateResolverTest {

    private val zone: ZoneId = ZoneId.of("Asia/Jakarta")

    private fun at(y: Int, mo: Int, d: Int, h: Int, mi: Int = 0): Long =
        LocalDateTime.of(y, mo, d, h, mi).atZone(zone).toInstant().toEpochMilli()

    private val syncedAt = at(2026, 11, 19, 8, 48)

    private fun data(
        status: String,
        date: String = "2026-11-19",
        worked: Int = 0,
        breakEndsAt: Long = 0,
        signedIn: Boolean = true,
        synced: Long = syncedAt,
    ) = AttendanceWidgetData(
        signedIn = signedIn,
        status = status,
        date = date,
        checkIn = "08:00",
        checkOut = "17:00",
        breakStart = "12:00",
        breakEnd = "13:00",
        workedMinutesAtSync = worked,
        breakEndsAtEpochMs = breakEndsAt,
        serverNowAtSyncEpochMs = synced,
        syncedAtEpochMs = synced,
        officeName = "HQ",
    )

    // --- parsing -----------------------------------------------------------

    @Test
    fun `parses the v1 payload written by Flutter`() {
        val json = """{"schema":1,"signedIn":true,"status":"checked_in","date":"2026-11-19",
            "checkIn":"08:00","checkOut":"","breakStart":"","breakEnd":"",
            "workedMinutesAtSync":48,"breakEndsAtEpochMs":0,
            "serverNowAtSyncEpochMs":1795056000000,"syncedAtEpochMs":1795056000000,
            "officeName":"HQ"}"""
        val d = AttendanceWidgetData.parse(json)!!
        assertEquals("checked_in", d.status)
        assertEquals(48, d.workedMinutesAtSync)
        assertEquals(1795056000000L, d.syncedAtEpochMs)
    }

    @Test
    fun `missing, malformed or unknown schema data is rejected`() {
        assertNull(AttendanceWidgetData.parse(null))
        assertNull(AttendanceWidgetData.parse(""))
        assertNull(AttendanceWidgetData.parse("{not json"))
        assertNull(AttendanceWidgetData.parse("""{"schema":2,"signedIn":true}"""))
    }

    @Test
    fun `negative worked minutes are clamped`() {
        val d = AttendanceWidgetData.parse("""{"schema":1,"signedIn":true,"workedMinutesAtSync":-12}""")!!
        assertEquals(0, d.workedMinutesAtSync)
    }

    // --- states ------------------------------------------------------------

    @Test
    fun `no data and signed out offer no actions`() {
        val none = AttendanceWidgetStateResolver.resolve(null, syncedAt, zone)
        assertEquals(WidgetKind.UNKNOWN, none.kind)
        assertTrue(none.actions.isEmpty())

        val out = AttendanceWidgetStateResolver.resolve(data("checked_in", signedIn = false), syncedAt, zone)
        assertEquals(WidgetKind.SIGNED_OUT, out.kind)
        assertTrue(out.actions.isEmpty())
    }

    @Test
    fun `each backend status maps to the app's buttons`() {
        fun actions(status: String, breakEndsAt: Long = 0) =
            AttendanceWidgetStateResolver.resolve(data(status, breakEndsAt = breakEndsAt), syncedAt, zone).actions

        assertEquals(listOf(WidgetAction.CHECK_IN), actions("not_started"))
        assertEquals(listOf(WidgetAction.CHECK_OUT, WidgetAction.BREAK_START), actions("checked_in"))
        assertEquals(emptyList<WidgetAction>(), actions("break_start", syncedAt + 30 * 60_000))
        assertEquals(listOf(WidgetAction.BREAK_END), actions("break_start", syncedAt - 1))
        assertEquals(listOf(WidgetAction.CHECK_OUT), actions("break_end"))
        assertEquals(emptyList<WidgetAction>(), actions("checked_out"))
    }

    @Test
    fun `worked timer continues from the synced value`() {
        val now = syncedAt + 10 * 60_000
        val s = AttendanceWidgetStateResolver.resolve(data("checked_in", worked = 48), now, zone)
        assertEquals(WidgetTimer.CountUp(58 * 60_000L), s.timer)
    }

    @Test
    fun `break counts up from its start, shows end time, refreshes at the end`() {
        val breakStarted = syncedAt - 10 * 60_000
        val breakEnds = syncedAt + 30 * 60_000
        val d = data("break_start", breakEndsAt = breakEnds).copy(breakStartedAtEpochMs = breakStarted)
        val s = AttendanceWidgetStateResolver.resolve(d, syncedAt, zone)
        assertEquals(WidgetKind.ON_BREAK, s.kind)
        assertEquals(WidgetTimer.CountUp(10 * 60_000L), s.timer)
        assertEquals("Mulai 12:00 · s/d 09:18", s.subtitle)
        assertEquals("half of the remaining 30 min", syncedAt + 15 * 60_000L, s.nextRefreshAtMs)
    }

    @Test
    fun `break refresh chain converges on the end and never passes it`() {
        val end = 3_600_000L
        var now = 0L
        var wakes = 0
        while (true) {
            val next = AttendanceWidgetStateResolver.breakRefreshAt(now, end - now)
            assertTrue(next <= end)
            wakes++
            if (next == end) break
            now = next
        }
        assertTrue("wakes=$wakes", wakes in 5..10)
        assertEquals(end, AttendanceWidgetStateResolver.breakRefreshAt(end - 30_000, 30_000))
    }

    @Test
    fun `zero break allowance shows End Break immediately`() {
        // duration_break = 0: allowance ends at the break start.
        val started = syncedAt - 60_000
        val d = data("break_start", breakEndsAt = started).copy(breakStartedAtEpochMs = started)
        val s = AttendanceWidgetStateResolver.resolve(d, syncedAt, zone)
        assertEquals(WidgetKind.BREAK_OVER, s.kind)
        assertEquals(listOf(WidgetAction.BREAK_END), s.actions)
    }

    @Test
    fun `regression - break timer is never negative, even when the refresh is late`() {
        // Break allowance already over, widget not refreshed yet (inexact alarm).
        val breakStarted = syncedAt - 12 * 60_000
        val d = data("break_start", breakEndsAt = syncedAt - 2 * 60_000).copy(breakStartedAtEpochMs = breakStarted)
        for (lateMs in listOf(0L, 60_000L, 6 * 60_000L)) {
            val s = AttendanceWidgetStateResolver.resolve(d, syncedAt + lateMs, zone)
            assertEquals(WidgetKind.BREAK_OVER, s.kind)
            assertEquals(listOf(WidgetAction.BREAK_END), s.actions)
            assertNull(s.timer)
        }
        // And while on break, the only timer is a non-negative count-up.
        val onBreak = data("break_start", breakEndsAt = syncedAt + 60_000).copy(breakStartedAtEpochMs = breakStarted)
        val t = AttendanceWidgetStateResolver.resolve(onBreak, syncedAt, zone).timer as WidgetTimer.CountUp
        assertTrue(t.elapsedMs >= 0)
    }

    @Test
    fun `older payload without break start shows no timer`() {
        val s = AttendanceWidgetStateResolver.resolve(
            data("break_start", breakEndsAt = syncedAt + 60_000), syncedAt, zone,
        )
        assertEquals(WidgetKind.ON_BREAK, s.kind)
        assertNull(s.timer)
    }

    @Test
    fun `checked out shows total in the app's format`() {
        val s = AttendanceWidgetStateResolver.resolve(data("checked_out", worked = 480), syncedAt, zone)
        assertEquals(WidgetKind.DONE, s.kind)
        assertEquals("08h 00m", s.value)
    }

    // --- staleness ---------------------------------------------------------

    @Test
    fun `previous-day record after midnight is stale with no actions`() {
        val afterMidnight = at(2026, 11, 20, 0, 5)
        val s = AttendanceWidgetStateResolver.resolve(data("checked_in", worked = 48), afterMidnight, zone)
        assertEquals(WidgetKind.STALE, s.kind)
        assertTrue(s.dimmed)
        assertTrue(s.actions.isEmpty())
    }

    @Test
    fun `record older than 12 hours is stale`() {
        val s = AttendanceWidgetStateResolver.resolve(
            data("not_started", date = ""), syncedAt + AttendanceWidgetStateResolver.MAX_AGE_MS + 1, zone,
        )
        assertEquals(WidgetKind.STALE, s.kind)
    }

    @Test
    fun `refresh at max age when that comes before midnight`() {
        val s = AttendanceWidgetStateResolver.resolve(data("checked_in"), syncedAt, zone)
        assertEquals(syncedAt + AttendanceWidgetStateResolver.MAX_AGE_MS, s.nextRefreshAtMs)
    }

    @Test
    fun `refresh is scheduled for the next midnight`() {
        val afternoon = at(2026, 11, 19, 15, 0)
        val s = AttendanceWidgetStateResolver.resolve(data("checked_in", synced = afternoon), afternoon, zone)
        assertEquals(at(2026, 11, 20, 0, 0), s.nextRefreshAtMs)
    }

    @Test
    fun `server clock ahead of device shifts the midnight refresh`() {
        // Server is 5 minutes ahead of the device.
        val afternoon = at(2026, 11, 19, 15, 0)
        val d = data("checked_in", synced = afternoon).copy(serverNowAtSyncEpochMs = afternoon + 5 * 60_000)
        val s = AttendanceWidgetStateResolver.resolve(d, afternoon, zone)
        assertEquals(at(2026, 11, 19, 23, 55), s.nextRefreshAtMs)
    }

    @Test
    fun `hours minutes format`() {
        assertEquals("00h 00m", AttendanceWidgetStateResolver.formatHoursMinutes(-5))
        assertEquals("01h 05m", AttendanceWidgetStateResolver.formatHoursMinutes(65))
    }

    // --- location (A + B) -----------------------------------------------

    private fun located(inside: Int = 1, at: Long = syncedAt, x: Double = 0.4, y: Double = 0.6) =
        data("checked_in").copy(mapDotX = x, mapDotY = y, locationAtEpochMs = at, insideArea = inside)

    @Test
    fun `fresh fix shows dot, badge and time label`() {
        val s = AttendanceWidgetStateResolver.resolve(located(), syncedAt + 60_000, zone)
        val loc = s.location!!
        assertEquals(0.4f, loc.dotX!!, 1e-6f)
        assertEquals(0.6f, loc.dotY!!, 1e-6f)
        assertTrue(loc.fresh)
        assertEquals(true, loc.insideArea)
        assertEquals("Lokasi 08:48", loc.label)
    }

    @Test
    fun `outside geofence badge`() {
        val loc = AttendanceWidgetStateResolver.resolve(located(inside = 0), syncedAt, zone).location!!
        assertEquals(false, loc.insideArea)
    }

    @Test
    fun `old fix is dimmed and has no badge`() {
        val now = syncedAt + AttendanceWidgetStateResolver.FRESH_MS + 1
        val loc = AttendanceWidgetStateResolver.resolve(located(), now, zone).location!!
        assertTrue(!loc.fresh)
        assertNull(loc.insideArea)
        assertEquals(0.4f, loc.dotX!!, 1e-6f)
    }

    @Test
    fun `badge refresh is scheduled when the fix goes old`() {
        val s = AttendanceWidgetStateResolver.resolve(located(), syncedAt, zone)
        assertEquals(syncedAt + AttendanceWidgetStateResolver.FRESH_MS, s.nextRefreshAtMs)
    }

    @Test
    fun `stale attendance never shows a current badge`() {
        val afterMidnight = at(2026, 11, 20, 0, 5)
        val s = AttendanceWidgetStateResolver.resolve(
            located(at = afterMidnight - 60_000), afterMidnight, zone,
        )
        assertEquals(WidgetKind.STALE, s.kind)
        assertNull(s.location!!.insideArea)
        assertTrue(!s.location!!.fresh)
    }

    @Test
    fun `no fix, off-image dot and signed out`() {
        assertNull(AttendanceWidgetStateResolver.resolve(data("checked_in"), syncedAt, zone).location)

        val off = AttendanceWidgetStateResolver.resolve(located(x = -1.0, y = -1.0), syncedAt, zone).location!!
        assertNull(off.dotX)
        assertEquals(true, off.insideArea)

        val out = AttendanceWidgetStateResolver.resolve(located().copy(signedIn = false), syncedAt, zone)
        assertNull(out.location)
    }

    @Test
    fun `old payload without location fields still parses`() {
        val d = AttendanceWidgetData.parse("""{"schema":1,"signedIn":true,"status":"checked_in"}""")!!
        assertEquals(-1.0, d.mapDotX, 0.0)
        assertEquals(0L, d.locationAtEpochMs)
        assertEquals(-1, d.insideArea)
    }
}
