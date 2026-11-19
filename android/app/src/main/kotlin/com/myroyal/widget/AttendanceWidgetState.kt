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

/**
 * Live timers only count **up**: an Android widget Chronometer cannot stop
 * at zero, and the refresh at the end of the break is an inexact alarm
 * (minutes late), so a count-down would show negative time.
 */
sealed class WidgetTimer {
    /** Worked time or break time so far, counting up from [elapsedMs] at render time. */
    data class CountUp(val elapsedMs: Long) : WidgetTimer()
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
                if (remaining > 0) {
                    val breakElapsed =
                        if (data.breakStartedAtEpochMs > 0) serverNow - data.breakStartedAtEpochMs else -1L
                    AttendanceWidgetViewState(
                        kind = WidgetKind.ON_BREAK,
                        title = "Sedang istirahat",
                        subtitle = "Mulai ${data.breakStart} · s/d ${clockLabel(data.breakEndsAtEpochMs, zone)}",
                        timer = if (breakElapsed >= 0) WidgetTimer.CountUp(breakElapsed) else null,
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

            "checked_out" -> AttendanceWidgetViewState(
                kind = WidgetKind.DONE,
                title = "Selesai hari ini",
                subtitle = "${data.checkIn} – ${data.checkOut}",
                value = formatHoursMinutes(data.workedMinutesAtSync),
                officeName = data.officeName,
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

    /** Below this, the next refresh targets the break end itself. */
    const val BREAK_FINAL_STEP_MS = 40_000L

    /**
     * Next wake-up while on break. Inexact alarms may fire up to ~75 % of
     * their delay late, so one alarm at the break end can be minutes late
     * (End Break shown late). Waking at half the remaining time each step
     * keeps every alarm before the end and shrinks the error to seconds,
     * without the restricted exact-alarm permission (~8 wakes for 60 min).
     */
    fun breakRefreshAt(nowMs: Long, remainingMs: Long): Long =
        if (remainingMs > BREAK_FINAL_STEP_MS) nowMs + remainingMs / 2 else nowMs + remainingMs

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
