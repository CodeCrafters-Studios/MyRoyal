package com.myroyal.widget

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Paint
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
import androidx.glance.action.Action
import androidx.glance.action.clickable
import androidx.glance.appwidget.AndroidRemoteViews
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.ContentScale
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
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
import kotlin.math.min

/**
 * MyRoyal attendance home screen widget (EPIC 02 / TASK 09).
 *
 * Full-screen office map with the user's last in-app location (option A + B)
 * and a status card. Read-only view of the last backend-confirmed state
 * written by the Flutter app; every tap opens the app (decision D1). Nothing
 * here calls the backend, reads GPS or holds credentials.
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
            val map = if (state.showMap) {
                loadMap(prefs.getString(AttendanceWidgetData.MAP_KEY, null))?.let { withDot(it, state.location) }
            } else {
                null
            }

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

/**
 * Draws the location dot into the map bitmap itself, so it stays on the
 * right spot when the image is cropped to the widget's shape.
 */
private fun withDot(map: Bitmap, location: WidgetLocation?): Bitmap {
    val x = location?.dotX ?: return map
    val y = location.dotY ?: return map
    val out = map.copy(Bitmap.Config.ARGB_8888, true) ?: return map
    val canvas = Canvas(out)
    val r = min(out.width, out.height) * 0.035f
    val cx = x * out.width
    val cy = y * out.height
    val color = if (location.fresh) 0xFF1A73E8.toInt() else 0xFF9AA0A6.toInt()
    val paint = Paint(Paint.ANTI_ALIAS_FLAG)

    paint.color = color
    paint.alpha = 0x40
    canvas.drawCircle(cx, cy, r * 3f, paint)
    paint.color = 0xFFFFFFFF.toInt()
    canvas.drawCircle(cx, cy, r * 1.4f, paint)
    paint.color = color
    canvas.drawCircle(cx, cy, r, paint)
    return out
}

private object Palette {
    val background = ColorProvider(day = Color(0xFFE6E8EF), night = Color(0xFF2A2D38))
    val card = ColorProvider(day = Color(0xF2FFFFFF), night = Color(0xE61C1E26))
    val text = ColorProvider(day = Color(0xFF1A1D3B), night = Color(0xFFF2F3F7))
    val muted = ColorProvider(day = Color(0xFF6B6F80), night = Color(0xFFA9ADBD))
    val button = ColorProvider(day = Color(0xFF1A1D3B), night = Color(0xFF5C8DD7))
    val onColor = ColorProvider(day = Color(0xFFFFFFFF), night = Color(0xFFFFFFFF))
    val inside = ColorProvider(day = Color(0xFF1E8E3E), night = Color(0xFF34A853))
    val outside = ColorProvider(day = Color(0xFFD93025), night = Color(0xFFEA4335))
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
    Box(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Palette.background)
            .cornerRadius(16.dp)
            .clickable(openApp(context)),
    ) {
        if (map != null) {
            Image(
                provider = ImageProvider(map),
                contentDescription = "Peta lokasi kantor",
                contentScale = ContentScale.Crop,
                modifier = GlanceModifier.fillMaxSize(),
            )
        }
        Column(modifier = GlanceModifier.fillMaxSize().padding(8.dp)) {
            Row(modifier = GlanceModifier.fillMaxWidth()) {
                StatusCard(context, state)
                Spacer(GlanceModifier.defaultWeight())
                LocationChips(state.location)
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
private fun StatusCard(context: Context, state: AttendanceWidgetViewState) {
    Column(
        modifier = GlanceModifier
            .background(Palette.card)
            .cornerRadius(12.dp)
            .padding(horizontal = 10.dp, vertical = 6.dp),
    ) {
        Text(
            text = state.officeName.ifBlank { "Kehadiran" },
            maxLines = 1,
            style = TextStyle(color = Palette.muted, fontSize = 10.sp),
        )
        Text(
            text = state.title,
            maxLines = 1,
            style = TextStyle(
                color = if (state.dimmed) Palette.muted else Palette.text,
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
            ),
        )
        if (state.subtitle.isNotBlank()) {
            Text(
                text = state.subtitle,
                maxLines = 1,
                style = TextStyle(color = Palette.muted, fontSize = 11.sp),
            )
        }
        when (val timer = state.timer) {
            is WidgetTimer.CountUp -> AndroidRemoteViews(chronometer(context, timer.elapsedMs))
            null -> if (state.value.isNotBlank()) {
                Text(
                    text = state.value,
                    style = TextStyle(color = Palette.text, fontSize = 18.sp, fontWeight = FontWeight.Bold),
                )
            }
        }
    }
}

@Composable
private fun LocationChips(location: WidgetLocation?) {
    if (location == null) return
    Column(horizontalAlignment = Alignment.End) {
        location.insideArea?.let { inside ->
            Chip(
                text = if (inside) "Di dalam area" else "Di luar area",
                background = if (inside) Palette.inside else Palette.outside,
                textColor = Palette.onColor,
            )
            Spacer(GlanceModifier.height(4.dp))
        }
        Chip(text = location.label, background = Palette.card, textColor = Palette.muted)
    }
}

@Composable
private fun Chip(
    text: String,
    background: androidx.glance.unit.ColorProvider,
    textColor: androidx.glance.unit.ColorProvider,
) {
    Box(
        modifier = GlanceModifier
            .background(background)
            .cornerRadius(10.dp)
            .padding(horizontal = 8.dp, vertical = 3.dp),
    ) {
        Text(
            text = text,
            maxLines = 1,
            style = TextStyle(color = textColor, fontSize = 10.sp, fontWeight = FontWeight.Medium),
        )
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
            style = TextStyle(color = Palette.onColor, fontSize = 13.sp, fontWeight = FontWeight.Medium),
        )
    }
}

/**
 * Glance has no ticking text; a RemoteViews Chronometer keeps the worked /
 * break time live without waking the app every second. Count-up only (see
 * [WidgetTimer]).
 */
private fun chronometer(context: Context, elapsedMs: Long): RemoteViews {
    val base = SystemClock.elapsedRealtime() - elapsedMs
    return RemoteViews(context.packageName, R.layout.attendance_widget_chronometer).apply {
        setChronometer(R.id.attendance_widget_chronometer, base, null, true)
        setChronometerCountDown(R.id.attendance_widget_chronometer, false)
    }
}
