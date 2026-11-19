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
    fun `break countdown and refresh when the allowance ends`() {
        val breakEnds = syncedAt + 30 * 60_000
        val s = AttendanceWidgetStateResolver.resolve(data("break_start", breakEndsAt = breakEnds), syncedAt, zone)
        assertEquals(WidgetKind.ON_BREAK, s.kind)
        assertEquals(WidgetTimer.CountDown(30 * 60_000L), s.timer)
        assertEquals(breakEnds, s.nextRefreshAtMs)
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
