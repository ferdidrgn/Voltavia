package com.ferdidrgn.voltavia.kmp.feature.stations

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ferdidrgn.voltavia.kmp.core.model.AvailabilityStatus
import com.ferdidrgn.voltavia.kmp.core.model.DataConfidence
import com.ferdidrgn.voltavia.kmp.core.model.DataConfidence
import com.ferdidrgn.voltavia.kmp.core.model.ChargingStation

@Composable
fun StationDetailScreen(
    station: ChargingStation,
    isFavorite: Boolean,
    onBack: () -> Unit,
    onToggleFavorite: () -> Unit,
    onStartCharging: () -> Unit,
    onOpenOperator: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(horizontal = 20.dp)) {
        Spacer(Modifier.height(16.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            TextButton(onClick = onBack) { Text("‹  İstasyonlara dön") }
            TextButton(onClick = onToggleFavorite) { Text(if (isFavorite) "♥ Kaydedildi" else "♡ Kaydet") }
        }
        Spacer(Modifier.height(8.dp))
        Text(station.operatorName, color = MaterialTheme.colorScheme.primary, fontSize = 13.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(3.dp))
        Text(station.name, color = MaterialTheme.colorScheme.onSurface, fontSize = 25.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(6.dp))
        Text(station.address, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 14.sp)
        Spacer(Modifier.height(16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            StationTag("${station.distanceKm} km")
            StationTag("${station.powerKw.toInt()} kW")
            StatusTag(station.availability)
        }
        Spacer(Modifier.height(18.dp))
        DetailPanel(title = "Konnektörler") {
            if (station.connectors.isEmpty()) {
                Text("Konnektör bilgisi henüz yok.", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 13.sp)
            } else {
                station.connectors.forEach { connector ->
                    Row(Modifier.fillMaxWidth().padding(vertical = 5.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text(connector, color = MaterialTheme.colorScheme.onSurface, fontWeight = FontWeight.Medium)
                        Text("Uyumluluğu araç profilinde kontrol et", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 11.sp)
                    }
                }
            }
        }
        Spacer(Modifier.height(12.dp))
        DetailPanel(title = "Tarife ve veri") {
            Text(
                station.pricePerKwh?.let { "₺${it} / kWh" } ?: "Tarife bilgisi bulunmuyor",
                color = MaterialTheme.colorScheme.onSurface,
                fontSize = 17.sp,
                fontWeight = FontWeight.SemiBold,
            )
            Spacer(Modifier.height(4.dp))
            Text("Kaynak: ${station.sourceLabel}", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
            Text("Son güncelleme: ${station.updatedAtLabel}", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
            station.availabilityFact?.let { fact ->
                Spacer(Modifier.height(5.dp))
                Text("Uygunluk kaynağı: ${fact.source} · ${confidenceLabel(fact.confidence)}", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
            }
            station.priceFact?.let { fact ->
                Spacer(Modifier.height(5.dp))
                Text("Tarife kaynağı: ${fact.source} · ${confidenceLabel(fact.confidence)}", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
            }
            Spacer(Modifier.height(8.dp))
            val stateDescription = when (station.availability) {
                AvailabilityStatus.Available -> "Uygun bilgisi kaynağın bildirdiği durumu yansıtır; istasyona varmadan önce operatörden doğrula."
                AvailabilityStatus.Busy -> "Dolu durumu son alınan bilgidir; güncellik zamanını kontrol et."
                AvailabilityStatus.Offline -> "Bu nokta şu an hizmet dışı olarak işaretli."
                AvailabilityStatus.Unknown -> "Canlı uygunluk verisi alınamadı. Durum bilinmiyor."
            }
            Text(stateDescription, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
        }
        Spacer(Modifier.height(12.dp))
        if (station.chargingStartSupported) {
            Button(onClick = onStartCharging, modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(16.dp)) {
                Text("Şarj akışını aç")
            }
        } else {
            OutlinedButton(onClick = onOpenOperator, modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(16.dp)) {
                Text("Operatör uygulamasında aç")
            }
        }
        Spacer(Modifier.height(8.dp))
        Text(
            "Şarj başlatma yalnızca bu istasyon için doğrulanmış operatör bağlantısı olduğunda kullanılabilir.",
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            fontSize = 11.sp,
        )
    }
}

private fun confidenceLabel(confidence: DataConfidence): String = when (confidence) {
    DataConfidence.Verified -> "doğrulanmış"
    DataConfidence.OperatorReported -> "operatör bildirimi"
    DataConfidence.CommunityReported -> "topluluk bildirimi"
    DataConfidence.Unverified -> "doğrulanmamış"
}

@Composable
private fun DetailPanel(title: String, content: @Composable ColumnScope.() -> Unit) {
    Card(
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        shape = RoundedCornerShape(22.dp),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = .5f)),
        modifier = Modifier.fillMaxWidth(),
    ) {
        Column(Modifier.padding(16.dp)) {
            Text(title, color = MaterialTheme.colorScheme.onSurface, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
            Spacer(Modifier.height(8.dp))
            content()
        }
    }
}
