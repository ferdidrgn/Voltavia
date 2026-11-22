package com.ferdidrgn.voltavia.kmp.core.designsystem

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp

/** Ready-to-use color palettes. The palette choice is not tied to a user's gender. */
enum class ThemePreset(
    val title: String,
    val swatch: Color,
    val isDark: Boolean,
    val isGlass: Boolean,
    private val backgroundColor: Color,
    private val surfaceColor: Color,
    private val elevatedSurfaceColor: Color,
    private val primaryColor: Color,
    private val secondaryColor: Color,
    private val textColor: Color,
    private val mutedTextColor: Color,
    private val outlineColor: Color,
) {
    Harbor(
        "Liman", Color(0xFF3BE58B), true, false,
        Color(0xFF081311), Color(0xFF101D19), Color(0xFF182822),
        Color(0xFF3BE58B), Color(0xFF82E9BD), Color(0xFFF0F8F4),
        Color(0xFFAABBB2), Color(0xFF294039),
    ),
    Rose(
        "Gül", Color(0xFFFA78C7), true, false,
        Color(0xFF130B18), Color(0xFF21142A), Color(0xFF2B1B36),
        Color(0xFFFA78C7), Color(0xFFD6A0FF), Color(0xFFFFF5FC),
        Color(0xFFC5B4C6), Color(0xFF49354F),
    ),
    Violet(
        "Menekşe", Color(0xFFB28AFF), true, false,
        Color(0xFF100C19), Color(0xFF1D1729), Color(0xFF292039),
        Color(0xFFB28AFF), Color(0xFF79DCC4), Color(0xFFF6F2FF),
        Color(0xFFB8B0C8), Color(0xFF403653),
    ),
    Amber(
        "Kehribar", Color(0xFFFFC15C), true, false,
        Color(0xFF171108), Color(0xFF261D10), Color(0xFF342818),
        Color(0xFFFFC15C), Color(0xFF9FE0C3), Color(0xFFFFF8EB),
        Color(0xFFC8B99E), Color(0xFF51432B),
    ),
    Glass(
        "Cam", Color(0xFF3C7C78), false, true,
        Color(0xFFEAF1EE), Color(0xFFF7FAF8), Color(0xFFFFFFFF),
        Color(0xFF176D66), Color(0xFFAC5A91), Color(0xFF17241F),
        Color(0xFF61716A), Color(0xFFD8E3DE),
    ),
    RoseGlass(
        "Gül cam", Color(0xFFB4518D), false, true,
        Color(0xFFF4EAF0), Color(0xFFFFF8FC), Color(0xFFFFFFFF),
        Color(0xFFA63D7D), Color(0xFF6E6BAA), Color(0xFF281822),
        Color(0xFF75616C), Color(0xFFE5D7DF),
    ),
    VioletGlass(
        "Mor cam", Color(0xFF7556AA), false, true,
        Color(0xFFEDEAF4), Color(0xFFFAF8FF), Color(0xFFFFFFFF),
        Color(0xFF68459E), Color(0xFF437F79), Color(0xFF211A2A),
        Color(0xFF6A6275), Color(0xFFDDD7E7),
    );

    fun colorScheme(darkMode: Boolean = isDark, accentOverride: Color? = null): ColorScheme {
        val accent = accentOverride ?: primaryColor
        val background = when {
            darkMode && isDark -> backgroundColor
            darkMode -> Color(0xFF111014)
            !darkMode && !isDark -> backgroundColor
            else -> Color(0xFFF4F0F4)
        }
        val surface = when {
            darkMode && isDark -> surfaceColor
            darkMode -> Color(0xFF1D1A21)
            !darkMode && !isDark -> surfaceColor
            else -> Color(0xFFFFFBFF)
        }
        val elevated = when {
            darkMode && isDark -> elevatedSurfaceColor
            darkMode -> Color(0xFF29242E)
            !darkMode && !isDark -> elevatedSurfaceColor
            else -> Color(0xFFEAE4EC)
        }
        val foreground = if (darkMode) Color(0xFFF4EFF7) else Color(0xFF211A22)
        val muted = if (darkMode) Color(0xFFC9BECF) else Color(0xFF675D69)
        return if (darkMode) {
            darkColorScheme(
                primary = accent,
                onPrimary = if (accent.luminance() > .42f) Color(0xFF17121A) else Color.White,
                secondary = secondaryColor,
                background = background,
                surface = surface,
                surfaceVariant = elevated,
                onSurface = foreground,
                onBackground = foreground,
                onSurfaceVariant = muted,
                outline = if (isDark) outlineColor else Color(0xFF49414D),
            )
        } else {
            lightColorScheme(
                primary = accent,
                onPrimary = if (accent.luminance() > .42f) Color(0xFF17121A) else Color.White,
                secondary = secondaryColor,
                background = background,
                surface = surface,
                surfaceVariant = elevated,
                onSurface = foreground,
                onBackground = foreground,
                onSurfaceVariant = muted,
                outline = if (isDark) Color(0xFFD7CED9) else outlineColor,
            )
        }
    }
}

@Composable
fun VoltaviaTheme(
    preset: ThemePreset = ThemePreset.Harbor,
    darkMode: Boolean = preset.isDark,
    accentOverride: Color? = null,
    content: @Composable () -> Unit,
) {
    MaterialTheme(colorScheme = preset.colorScheme(darkMode, accentOverride), content = content)
}

/** Horizontally scrollable and screen-reader-labelled palette selector. */
@Composable
fun ThemePresetPicker(
    selected: ThemePreset,
    onSelected: (ThemePreset) -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier = modifier.horizontalScroll(rememberScrollState()),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        ThemePreset.entries.forEach { preset ->
            FilterChip(
                selected = preset == selected,
                onClick = { onSelected(preset) },
                label = { Text(preset.title) },
                leadingIcon = {
                    Box(
                        Modifier
                            .size(14.dp)
                            .clip(CircleShape)
                            .background(preset.swatch)
                            .semantics { contentDescription = "${preset.title} vurgu rengi" },
                    )
                },
            )
        }
    }
}

/** A translucent, outlined surface for small overlays on top of map or image content. */
@Composable
fun GlassSurface(
    modifier: Modifier = Modifier,
    content: @Composable () -> Unit,
) {
    Surface(
        modifier = modifier,
        color = MaterialTheme.colorScheme.surface.copy(alpha = .78f),
        contentColor = MaterialTheme.colorScheme.onSurface,
        shape = RoundedCornerShape(16.dp),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.onSurface.copy(alpha = .18f)),
        tonalElevation = 1.dp,
    ) {
        Box(Modifier.padding(horizontal = 14.dp, vertical = 10.dp)) {
            content()
        }
    }
}
