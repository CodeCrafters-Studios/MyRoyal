package com.myroyal.widget

import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.util.Locale

/**
 * Widget buttons. Each one only opens the app with this action
 * (design decision D1); the app runs its normal guarded flow.
 */
enum class WidgetAction(val uriAction: String, val label: String) {
    CHECK_IN("check_in", "Check In"),
    CHECK_OUT("check_out", "Check Out"),
    BREAK_START("break_start", "Take a Break"),
    BREAK_END("break_end", "End Break"),
}

sealed class WidgetTimer {
    /** Worked time, counting up from [elapsedMs] at render time. */
    data class CountUp(val elapsedMs: Long) : WidgetTimer()

    /**
     * Break allowance left, counting down from [remainingMs] at render time.
     * A widget Chronometer cannot stop at zero, so the resolver replaces it
     * before it gets there (see BREAK_SWITCH_EARLY_MS / breakRefreshAt).
     */
    data class CountDown(val remainingMs: Long) : WidgetTimer()
}

/**
 * Where the user was at the last GPS fix while the app was in use (design
 * option A + B). Display only: actions are always re-validated by the app.
 */
data class WidgetLocation(
    /** Dot position on the map image (0..1), null when off the image. */
    val dotX: Float?,
    val dotY: Float?,
    /** Recent enough to be shown as current (see FRESH_MS). */
    val fresh: Boolean,
    /** "Lokasi 10:54". */
    val label: String,
    /** Inside/outside badge; only for a fresh fix, else null. */
    val insideArea: Boolean?,
)

/** End-of-day summary, same values and formats as the Attendance page. */
data class WidgetSummary(
    val checkIn: String,
    val checkOut: String,
    val workDuration: String,
    val breakStart: String,
    val breakEnd: String,
    val breakDuration: String,
)

enum class WidgetKind { UNKNOWN, SIGNED_OUT, STALE, NOT_STARTED, WORKING, ON_BREAK, BREAK_OVER, DONE }

data class AttendanceWidgetViewState(
    val kind: WidgetKind,
    val title: String,
    val subtitle: String = "",
    val timer: WidgetTimer? = null,
    val value: String = "",
    val actions: List<WidgetAction> = emptyList(),
    val officeName: String = "",
    val dimmed: Boolean = false,
    val showMap: Boolean = true,
    val location: WidgetLocation? = null,
    /** Set for the checked-out state: summary layout instead of the map. */
    val summary: WidgetSummary? = null,
    /** Device time of the next state change (midnight, break end, max age). */
    val nextRefreshAtMs: Long? = null,
)

/**
 * Pure mapping from the last backend-confirmed payload to what the widget
 * shows. It never invents a state transition: when the data may be out of
 * date the widget becomes [WidgetKind.STALE] and offers no actions.
 */
object AttendanceWidgetStateResolver {

    /** Data older than this is shown as stale (design §6). */
    const val MAX_AGE_MS = 12L * 60 * 60 * 1000

    /** A location fix older than this is shown dimmed and without a badge. */
    const val FRESH_MS = 15L * 60 * 1000

    fun resolve(data: AttendanceWidgetData?, nowMs: Long, zone: ZoneId): AttendanceWidgetViewState {
        val state = resolveStatus(data, nowMs, zone)
        if (data == null || !state.showMap) return state

        val location = resolveLocation(data, nowMs, zone, stale = state.kind == WidgetKind.STALE)
            ?: return state
        // Re-render when the fix stops being fresh, so the badge disappears.
        val freshUntil = data.locationAtEpochMs + FRESH_MS
        val next = listOfNotNull(state.nextRefreshAtMs, freshUntil.takeIf { location.fresh && it > nowMs })
            .minOrNull()
        return state.copy(location = location, nextRefreshAtMs = next)
    }

    fun resolveLocation(
        data: AttendanceWidgetData,
        nowMs: Long,
        zone: ZoneId,
        stale: Boolean = false,
    ): WidgetLocation? {
        if (data.locationAtEpochMs <= 0) return null
        val age = nowMs - data.locationAtEpochMs
        val fresh = !stale && age in 0..FRESH_MS
        val onImage = data.mapDotX in 0.0..1.0 && data.mapDotY in 0.0..1.0
        val time = Instant.ofEpochMilli(data.locationAtEpochMs).atZone(zone).toLocalTime()
        return WidgetLocation(
            dotX = if (onImage) data.mapDotX.toFloat() else null,
            dotY = if (onImage) data.mapDotY.toFloat() else null,
            fresh = fresh,
            label = String.format(Locale.ROOT, "Lokasi %02d:%02d", time.hour, time.minute),
            insideArea = if (fresh && data.insideArea in 0..1) data.insideArea == 1 else null,
        )
    }

    private fun resolveStatus(data: AttendanceWidgetData?, nowMs: Long, zone: ZoneId): AttendanceWidgetViewState {
        if (data == null) {
            return AttendanceWidgetViewState(
                kind = WidgetKind.UNKNOWN,
                title = "Kehadiran",
                subtitle = "Buka MyRoyal untuk memuat data",
                showMap = false,
            )
        }
        if (!data.signedIn) {
            return AttendanceWidgetViewState(
                kind = WidgetKind.SIGNED_OUT,
                title = "Belum masuk",
                subtitle = "Masuk ke MyRoyal untuk melihat kehadiran",
                showMap = false,
            )
        }

        val elapsed = (nowMs - data.syncedAtEpochMs).coerceAtLeast(0L)
        val serverNow =
            if (data.serverNowAtSyncEpochMs > 0) data.serverNowAtSyncEpochMs + elapsed else nowMs
        val serverToday = Instant.ofEpochMilli(serverNow).atZone(zone).toLocalDate()
        val recordDate = parseDate(data.date)
        val nextMidnightDeviceMs =
            serverToday.plusDays(1).atStartOfDay(zone).toInstant().toEpochMilli() - (serverNow - nowMs)
        val maxAgeAtMs = data.syncedAtEpochMs + MAX_AGE_MS

        val stale = data.syncedAtEpochMs <= 0 ||
            elapsed > MAX_AGE_MS ||
            (recordDate != null && recordDate.isBefore(serverToday))

        if (stale) {
            return AttendanceWidgetViewState(
                kind = WidgetKind.STALE,
                title = statusLabel(data.status),
                subtitle = "Ketuk untuk memperbarui",
                officeName = data.officeName,
                dimmed = true,
            )
        }

        fun refreshAt(vararg candidates: Long?): Long? =
            candidates.filterNotNull().filter { it > nowMs }.minOrNull()

        val workedMs = data.workedMinutesAtSync * 60_000L
        return when (data.status) {
            "not_started" -> AttendanceWidgetViewState(
                kind = WidgetKind.NOT_STARTED,
                title = "Belum check-in",
                subtitle = "Mulailah hari Anda yang produktif",
                actions = listOf(WidgetAction.CHECK_IN),
                officeName = data.officeName,
                nextRefreshAtMs = refreshAt(nextMidnightDeviceMs, maxAgeAtMs),
            )

            "checked_in" -> AttendanceWidgetViewState(
                kind = WidgetKind.WORKING,
                title = "Sedang bekerja",
                subtitle = "Masuk ${data.checkIn}",
                timer = WidgetTimer.CountUp(workedMs + elapsed),
                actions = listOf(WidgetAction.CHECK_OUT, WidgetAction.BREAK_START),
                officeName = data.officeName,
                nextRefreshAtMs = refreshAt(nextMidnightDeviceMs, maxAgeAtMs),
            )

            "break_start" -> {
                val remaining =
                    if (data.breakEndsAtEpochMs > 0) data.breakEndsAtEpochMs - serverNow else 0L
                if (remaining > BREAK_SWITCH_EARLY_MS) {
                    AttendanceWidgetViewState(
                        kind = WidgetKind.ON_BREAK,
                        title = "Sedang istirahat",
                        subtitle = "Mulai ${data.breakStart} · s/d ${clockLabel(data.breakEndsAtEpochMs, zone)}",
                        timer = WidgetTimer.CountDown(remaining),
                        officeName = data.officeName,
                        // Show "End Break" as close to 0 as possible (see breakRefreshAt).
                        nextRefreshAtMs = refreshAt(breakRefreshAt(nowMs, remaining), nextMidnightDeviceMs, maxAgeAtMs),
                    )
                } else {
                    AttendanceWidgetViewState(
                        kind = WidgetKind.BREAK_OVER,
                        title = "Istirahat selesai",
                        subtitle = "Mulai ${data.breakStart}",
                        actions = listOf(WidgetAction.BREAK_END),
                        officeName = data.officeName,
                        nextRefreshAtMs = refreshAt(nextMidnightDeviceMs, maxAgeAtMs),
                    )
                }
            }

            "break_end" -> AttendanceWidgetViewState(
                kind = WidgetKind.WORKING,
                title = "Sedang bekerja",
                subtitle = "Istirahat ${data.breakStart}–${data.breakEnd}",
                timer = WidgetTimer.CountUp(workedMs + elapsed),
                actions = listOf(WidgetAction.CHECK_OUT),
                officeName = data.officeName,
                nextRefreshAtMs = refreshAt(nextMidnightDeviceMs, maxAgeAtMs),
            )

            // Like the Attendance page after check-out: summary, no map.
            "checked_out" -> AttendanceWidgetViewState(
                kind = WidgetKind.DONE,
                title = "The End Of The Day!",
                officeName = data.officeName,
                showMap = false,
                summary = WidgetSummary(
                    checkIn = clock12(data.checkIn),
                    checkOut = clock12(data.checkOut),
                    workDuration = formatHoursMinutes(data.workedMinutesAtSync),
                    breakStart = clock12(data.breakStart),
                    breakEnd = clock12(data.breakEnd),
                    breakDuration = if (data.breakMinutes >= 0) formatHoursMinutes(data.breakMinutes) else "--h --m",
                ),
                nextRefreshAtMs = refreshAt(nextMidnightDeviceMs, maxAgeAtMs),
            )

            else -> AttendanceWidgetViewState(
                kind = WidgetKind.UNKNOWN,
                title = "Kehadiran",
                subtitle = "Buka MyRoyal untuk melihat status",
                officeName = data.officeName,
            )
        }
    }

    fun statusLabel(status: String): String = when (status) {
        "not_started" -> "Belum check-in"
        "checked_in", "break_end" -> "Sedang bekerja"
        "break_start" -> "Sedang istirahat"
        "checked_out" -> "Selesai hari ini"
        else -> "Kehadiran"
    }

    /**
     * With this much allowance left or less, the widget already shows
     * "Istirahat selesai" + End Break, so the countdown never reaches zero
     * (a widget Chronometer would continue into negative time). An End Break
     * tap in this window waits in the app until its own countdown is done.
     */
    const val BREAK_SWITCH_EARLY_MS = 10_000L

    /**
     * Next wake-up while on break: half the remaining time. Inexact alarms
     * fire at most ~75 % of their delay late, so each wake still lands
     * before the break end (now + 0.5R + 0.375R < now + R), and the steps
     * shrink until the remaining time is within BREAK_SWITCH_EARLY_MS. No
     * exact-alarm permission needed; ~9 wakes for a 60 min break.
     */
    fun breakRefreshAt(nowMs: Long, remainingMs: Long): Long = nowMs + remainingMs / 2

    /** App's `formatApiTime`: `HH:mm` → `hh:mm a` (e.g. `05:01 PM`), `--:--` when empty. */
    fun clock12(hhmm: String): String {
        val parts = hhmm.split(":")
        val h = parts.getOrNull(0)?.toIntOrNull()
        val m = parts.getOrNull(1)?.toIntOrNull()
        if (h == null || m == null || h !in 0..23 || m !in 0..59) return "--:--"
        val h12 = if (h % 12 == 0) 12 else h % 12
        return String.format(Locale.ROOT, "%02d:%02d %s", h12, m, if (h < 12) "AM" else "PM")
    }

    /** `HH:mm` of an epoch instant in [zone]. */
    fun clockLabel(epochMs: Long, zone: ZoneId): String {
        val t = Instant.ofEpochMilli(epochMs).atZone(zone).toLocalTime()
        return String.format(Locale.ROOT, "%02d:%02d", t.hour, t.minute)
    }

    /** Same format as the app (`formatHoursMinutes`): `08h 05m`. */
    fun formatHoursMinutes(minutes: Int): String {
        val m = minutes.coerceAtLeast(0)
        return String.format(Locale.ROOT, "%02dh %02dm", m / 60, m % 60)
    }

    private fun parseDate(value: String): LocalDate? =
        try {
            if (value.isBlank()) null else LocalDate.parse(value)
        } catch (e: Exception) {
            null
        }
}
