package com.myroyal.widget

import org.json.JSONObject

/**
 * Widget payload v1 written by the Flutter app
 * (`lib/app/modules/attendance/widget/attendance_widget_sync.dart`).
 *
 * Display data only: never a token, the employee's identity or GPS position.
 */
data class AttendanceWidgetData(
    val signedIn: Boolean,
    val status: String,
    val date: String,
    val checkIn: String,
    val checkOut: String,
    val breakStart: String,
    val breakEnd: String,
    val workedMinutesAtSync: Int,
    val breakEndsAtEpochMs: Long,
    val serverNowAtSyncEpochMs: Long,
    val syncedAtEpochMs: Long,
    val officeName: String,
) {
    companion object {
        const val DATA_KEY = "attendance_widget_v1"
        const val MAP_KEY = "attendance_widget_map"
        const val SCHEMA = 1

        /** Returns null for missing, malformed or unknown-schema data. */
        fun parse(json: String?): AttendanceWidgetData? {
            if (json.isNullOrBlank()) return null
            return try {
                val o = JSONObject(json)
                if (o.optInt("schema", -1) != SCHEMA) return null
                AttendanceWidgetData(
                    signedIn = o.optBoolean("signedIn", false),
                    status = o.optString("status", "not_started"),
                    date = o.optString("date", ""),
                    checkIn = o.optString("checkIn", ""),
                    checkOut = o.optString("checkOut", ""),
                    breakStart = o.optString("breakStart", ""),
                    breakEnd = o.optString("breakEnd", ""),
                    workedMinutesAtSync = o.optInt("workedMinutesAtSync", 0).coerceAtLeast(0),
                    breakEndsAtEpochMs = o.optLong("breakEndsAtEpochMs", 0L),
                    serverNowAtSyncEpochMs = o.optLong("serverNowAtSyncEpochMs", 0L),
                    syncedAtEpochMs = o.optLong("syncedAtEpochMs", 0L),
                    officeName = o.optString("officeName", ""),
                )
            } catch (e: Exception) {
                null
            }
        }
    }
}
