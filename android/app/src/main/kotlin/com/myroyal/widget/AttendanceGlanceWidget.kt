package com.myroyal.widget

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.currentState
import androidx.glance.action.Action
import androidx.glance.action.clickable
import androidx.glance.appwidget.AndroidRemoteViews
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.layout.ContentScale
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.myroyal.MainActivity
import com.myroyal.R
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.actionStartActivity
import java.io.File
import java.time.ZoneId

/**
 * MyRoyal attendance home screen widget (EPIC 02 / TASK 09).
 *
 * Read-only view of the last backend-confirmed state written by the Flutter
 * app. Every tap opens the app (decision D1); nothing here calls the backend,
 * reads GPS or holds credentials.
 */
class AttendanceGlanceWidget : GlanceAppWidget() {

    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // Read inside the composition: HomeWidget.updateWidget bumps the
            // Glance state and recomposes this running session, so values
            // captured outside provideContent would stay stale.
            val prefs = currentState<HomeWidgetGlanceState>().preferences
            val data = AttendanceWidgetData.parse(prefs.getString(AttendanceWidgetData.DATA_KEY, null))
            val state = AttendanceWidgetStateResolver.resolve(
                data, System.currentTimeMillis(), ZoneId.systemDefault(),
            )
            val mapPath = prefs.getString(AttendanceWidgetData.MAP_KEY, null)
            val map = if (state.showMap) loadMap(mapPath) else null

            LaunchedEffect(state.nextRefreshAtMs) {
                AttendanceWidgetScheduler.schedule(context, state.nextRefreshAtMs)
            }

            AttendanceWidgetContent(context, state, map)
        }
    }

    private fun loadMap(path: String?): Bitmap? {
        if (path.isNullOrBlank()) return null
        val file = File(path)
        if (!file.exists()) return null
        return try {
            BitmapFactory.decodeFile(file.absolutePath)
        } catch (e: Exception) {
            null
        }
    }
}

private object Palette {
    val background = ColorProvider(day = Color(0xFFFFFFFF), night = Color(0xFF1C1E26))
    val text = ColorProvider(day = Color(0xFF1A1D3B), night = Color(0xFFF2F3F7))
    val muted = ColorProvider(day = Color(0xFF6B6F80), night = Color(0xFFA9ADBD))
    val button = ColorProvider(day = Color(0xFF1A1D3B), night = Color(0xFF5C8DD7))
    val buttonText = ColorProvider(day = Color(0xFFFFFFFF), night = Color(0xFFFFFFFF))
    val mapPlaceholder = ColorProvider(day = Color(0xFFE6E8EF), night = Color(0xFF2A2D38))
}

private fun openApp(context: Context, action: WidgetAction? = null): Action {
    val uri = if (action == null) {
        Uri.parse("myroyal://attendance")
    } else {
        Uri.parse("myroyal://attendance?action=${action.uriAction}")
    }
    return actionStartActivity<MainActivity>(context, uri)
}

@Composable
private fun AttendanceWidgetContent(
    context: Context,
    state: AttendanceWidgetViewState,
    map: Bitmap?,
) {
    Row(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Palette.background)
            .cornerRadius(16.dp)
            .clickable(openApp(context))
            .padding(12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        if (state.showMap) {
            MapPreview(map)
            Spacer(GlanceModifier.width(12.dp))
        }
        Column(modifier = GlanceModifier.defaultWeight().fillMaxHeight()) {
            Text(
                text = state.officeName.ifBlank { "Kehadiran" },
                maxLines = 1,
                style = TextStyle(color = Palette.muted, fontSize = 11.sp),
            )
            Text(
                text = state.title,
                maxLines = 1,
                style = TextStyle(
                    color = if (state.dimmed) Palette.muted else Palette.text,
                    fontSize = 15.sp,
                    fontWeight = FontWeight.Bold,
                ),
            )
            if (state.subtitle.isNotBlank()) {
                Text(
                    text = state.subtitle,
                    maxLines = 1,
                    style = TextStyle(color = Palette.muted, fontSize = 12.sp),
                )
            }
            when (val timer = state.timer) {
                is WidgetTimer.CountUp -> AndroidRemoteViews(chronometer(context, timer.elapsedMs, false))
                is WidgetTimer.CountDown -> AndroidRemoteViews(chronometer(context, timer.remainingMs, true))
                null -> if (state.value.isNotBlank()) {
                    Text(
                        text = state.value,
                        style = TextStyle(color = Palette.text, fontSize = 20.sp, fontWeight = FontWeight.Bold),
                    )
                }
            }
            Spacer(GlanceModifier.defaultWeight())
            if (state.actions.isNotEmpty()) {
                Row(modifier = GlanceModifier.fillMaxWidth()) {
                    state.actions.forEachIndexed { index, action ->
                        if (index > 0) Spacer(GlanceModifier.width(8.dp))
                        ActionButton(context, action, GlanceModifier.defaultWeight())
                    }
                }
            }
        }
    }
}

@Composable
private fun MapPreview(map: Bitmap?) {
    val modifier = GlanceModifier.width(96.dp).fillMaxHeight().cornerRadius(12.dp)
    if (map != null) {
        Image(
            provider = ImageProvider(map),
            contentDescription = "Peta lokasi kantor",
            contentScale = ContentScale.Crop,
            modifier = modifier,
        )
    } else {
        Box(modifier = modifier.background(Palette.mapPlaceholder)) {}
    }
}

/** Text-only button so it renders identically on every launcher (API 25+). */
@Composable
private fun ActionButton(context: Context, action: WidgetAction, modifier: GlanceModifier) {
    Box(
        modifier = modifier
            .height(36.dp)
            .background(Palette.button)
            .cornerRadius(18.dp)
            .clickable(openApp(context, action)),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = action.label,
            maxLines = 1,
            style = TextStyle(color = Palette.buttonText, fontSize = 13.sp, fontWeight = FontWeight.Medium),
        )
    }
}

/**
 * Glance has no ticking text; a RemoteViews Chronometer keeps the worked
 * time / break countdown live without waking the app every second.
 */
private fun chronometer(context: Context, ms: Long, countDown: Boolean): RemoteViews {
    val base = if (countDown) {
        SystemClock.elapsedRealtime() + ms
    } else {
        SystemClock.elapsedRealtime() - ms
    }
    return RemoteViews(context.packageName, R.layout.attendance_widget_chronometer).apply {
        setChronometer(R.id.attendance_widget_chronometer, base, null, true)
        setChronometerCountDown(R.id.attendance_widget_chronometer, countDown)
    }
}
