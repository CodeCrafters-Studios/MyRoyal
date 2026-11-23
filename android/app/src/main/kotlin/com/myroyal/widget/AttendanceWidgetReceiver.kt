package com.myroyal.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.glance.appwidget.updateAll
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * Registered in AndroidManifest.xml. The Flutter side refreshes it through
 * `HomeWidget.updateWidget(qualifiedAndroidName: 'com.myroyal.widget.AttendanceWidgetReceiver')`.
 */
class AttendanceWidgetReceiver : HomeWidgetGlanceWidgetReceiver<AttendanceGlanceWidget>() {

    override val glanceAppWidget = AttendanceGlanceWidget()

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == AttendanceWidgetScheduler.ACTION_REFRESH) {
            // Scheduled state change (midnight → stale, break allowance over).
            val pending = goAsync()
            CoroutineScope(Dispatchers.Default).launch {
                try {
                    glanceAppWidget.updateAll(context)
                } finally {
                    pending.finish()
                }
            }
            return
        }
        super.onReceive(context, intent)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        AttendanceWidgetScheduler.schedule(context, null)
    }
}

/**
 * One inexact alarm for the next time the widget's displayed state changes
 * without new data (no exact-alarm permission, no background work).
 */
object AttendanceWidgetScheduler {
    const val ACTION_REFRESH = "com.myroyal.widget.action.ATTENDANCE_REFRESH"

    fun schedule(context: Context, atMs: Long?) {
        val alarmManager = context.getSystemService(AlarmManager::class.java) ?: return
        val intent = Intent(context, AttendanceWidgetReceiver::class.java).setAction(ACTION_REFRESH)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        if (atMs == null) {
            alarmManager.cancel(pendingIntent)
        } else {
            alarmManager.set(AlarmManager.RTC, atMs, pendingIntent)
        }
    }
}
