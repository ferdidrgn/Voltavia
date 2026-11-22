package com.ferdidrgn.voltavia.kmp.feature.home

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ferdidrgn.voltavia.kmp.core.designsystem.GlassSurface
import com.ferdidrgn.voltavia.kmp.core.model.ChargingStation
import com.ferdidrgn.voltavia.kmp.feature.vehicle.VehicleProfile
import com.ferdidrgn.voltavia.kmp.feature.vehicle.estimateUsableRangeKm

@Composable
fun MapHomeScreen(
    station: ChargingStation,
    vehicle: VehicleProfile,
    onSeeStations: () -> Unit,
    onStationClick: () -> Unit,
    onOpenVehicle: () -> Unit,
    onOpenThemes: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MaterialTheme.colorScheme
    Column(modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(horizontal = 20.dp)) {
        Spacer(Modifier.height(20.dp))
        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
            Column(Modifier.weight(1f)) {
                Text("VOLTAVIA", color = colors.primary, fontSize = 12.sp, fontWeight = FontWeight.Bold, letterSpacing = 2.sp)
                Text("Yolun açık olsun", color = colors.onSurface, fontSize = 27.sp, fontWeight = FontWeight.Bold)
                Text("Yakın şarj noktalarını keşfet", color = colors.onSurfaceVariant, fontSize = 13.sp)
            }
            Surface(shape = CircleShape, color = colors.surfaceVariant, modifier = Modifier.size(48.dp)) {
                Box(contentAlignment = Alignment.Center) { Text("EV", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = colors.primary) }
            }
        }
        Spacer(Modifier.height(18.dp))
        Card(
            onClick = onOpenVehicle,
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = colors.surface),
            border = androidx.compose.foundation.BorderStroke(1.dp, colors.outline.copy(alpha = .5f)),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Column(Modifier.padding(16.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Surface(color = colors.primary.copy(alpha = .14f), shape = CircleShape, modifier = Modifier.size(44.dp)) {
                        Box(contentAlignment = Alignment.Center) { Text("EV", color = colors.primary, fontWeight = FontWeight.Bold, fontSize = 12.sp) }
                    }
                    Column(Modifier.weight(1f).padding(start = 12.dp)) {
                        Text("Aracım", color = colors.onSurfaceVariant, fontSize = 12.sp)
                        Text(vehicle.name, color = colors.onSurface, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                    }
                    Text("Düzenle →", color = colors.primary, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                }
                Spacer(Modifier.height(12.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    SummaryTag("${vehicle.currentBatteryPercent}% batarya")
                    SummaryTag("${estimateUsableRangeKm(vehicle)} km tahmini")
                    SummaryTag(vehicle.connector)
                }
            }
        }
        Spacer(Modifier.height(18.dp))
        MapCanvas()
        Spacer(Modifier.height(18.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                Text("Yakınındaki örnek nokta", color = colors.onSurface, fontSize = 18.sp, fontWeight = FontWeight.SemiBold)
                Text("Gerçek istasyon verisi bağlı değil", color = colors.onSurfaceVariant, fontSize = 12.sp)
            }
            androidx.compose.material3.TextButton(onClick = onSeeStations) { Text("Tümünü gör") }
        }
        Spacer(Modifier.height(10.dp))
        Card(
            onClick = onStationClick,
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = colors.surface),
            border = androidx.compose.foundation.BorderStroke(1.dp, colors.outline.copy(alpha = .5f)),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Column(Modifier.padding(16.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Surface(color = colors.primary.copy(alpha = .14f), shape = RoundedCornerShape(13.dp)) {
                        Text("⚡", color = colors.primary, fontSize = 20.sp, modifier = Modifier.padding(horizontal = 11.dp, vertical = 8.dp))
                    }
                    Column(Modifier.weight(1f).padding(start = 12.dp)) {
                        Text(station.name, color = colors.onSurface, fontWeight = FontWeight.SemiBold, fontSize = 16.sp)
                        Text(station.operatorName, color = colors.onSurfaceVariant, fontSize = 12.sp)
                    }
                    Text("›", color = colors.primary, fontSize = 24.sp)
                }
                Spacer(Modifier.height(12.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    SummaryTag("${station.powerKw.toInt()} kW")
                    station.connectors.take(2).forEach { SummaryTag(it) }
                    SummaryTag("Durum bilinmiyor")
                }
                Spacer(Modifier.height(12.dp))
                GlassSurface(modifier = Modifier.fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("${station.sourceLabel} · ${station.updatedAtLabel}", color = colors.onSurfaceVariant, fontSize = 11.sp, modifier = Modifier.weight(1f))
                        Text("Detay", color = colors.primary, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                    }
                }
            }
        }
        Spacer(Modifier.height(12.dp))
        Button(onClick = onOpenThemes, modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(16.dp)) {
            Text("Renk ve görünümü kişiselleştir")
        }
    }
}

@Composable
private fun MapCanvas() {
    val colors = MaterialTheme.colorScheme
    Card(
        shape = RoundedCornerShape(28.dp),
        colors = CardDefaults.cardColors(containerColor = colors.surfaceVariant),
        modifier = Modifier.fillMaxWidth().height(260.dp),
    ) {
        Box(Modifier.fillMaxSize()) {
            Canvas(Modifier.fillMaxSize().padding(4.dp)) {
                val roadColor = colors.onSurface.copy(alpha = .09f)
                val road = Path().apply {
                    moveTo(-20f, size.height * .72f)
                    cubicTo(size.width * .22f, size.height * .95f, size.width * .28f, size.height * .1f, size.width * .53f, size.height * .48f)
                    cubicTo(size.width * .7f, size.height * .7f, size.width * .76f, size.height * .14f, size.width + 20f, size.height * .34f)
                }
                drawPath(road, roadColor, style = Stroke(width = 17.dp.toPx(), cap = StrokeCap.Round))
                drawPath(road, colors.primary.copy(alpha = .82f), style = Stroke(width = 3.dp.toPx(), cap = StrokeCap.Round))
                listOf(Offset(size.width * .24f, size.height * .39f), Offset(size.width * .64f, size.height * .7f), Offset(size.width * .82f, size.height * .26f)).forEach { point ->
                    drawCircle(colors.primary.copy(alpha = .18f), radius = 19.dp.toPx(), center = point)
                    drawCircle(colors.primary, radius = 7.dp.toPx(), center = point)
                }
            }
            Column(Modifier.align(Alignment.TopStart).padding(16.dp)) {
                Text("İstanbul", color = colors.onSurface, fontWeight = FontWeight.SemiBold)
                Text("Şematik harita önizlemesi", color = colors.onSurfaceVariant, fontSize = 11.sp)
            }
            GlassSurface(Modifier.align(Alignment.BottomEnd).padding(12.dp)) {
                Text("Harita sağlayıcısı seçilmedi", color = colors.onSurface, fontSize = 11.sp)
            }
        }
    }
}

@Composable
private fun SummaryTag(label: String) {
    Surface(color = MaterialTheme.colorScheme.surfaceVariant, shape = RoundedCornerShape(9.dp)) {
        Text(label, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp, modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp))
    }
}
