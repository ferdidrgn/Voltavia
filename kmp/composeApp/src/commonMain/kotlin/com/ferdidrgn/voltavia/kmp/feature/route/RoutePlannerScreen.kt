package com.ferdidrgn.voltavia.kmp.feature.route

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.weight
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Slider
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.ui.text.input.KeyboardOptions
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ferdidrgn.voltavia.kmp.feature.vehicle.VehicleProfile

data class RoutePlanDraft(
    val origin: String,
    val destination: String,
    val currentBatteryPercent: Int,
    val arrivalReservePercent: Int,
    val userEstimatedDistanceKm: Double?,
)

@Composable
fun RoutePlannerScreen(
    initialOrigin: String = "Kadıköy, İstanbul",
    initialDestination: String = "Bursa, Türkiye",
    initialBatteryPercent: Int = 64,
    initialReservePercent: Int = 15,
    vehicle: VehicleProfile = VehicleProfile("Demo EV", 88, "CCS2", initialBatteryPercent, reservePercent = initialReservePercent),
    onPlanRequested: (RoutePlanDraft) -> Unit = {},
    modifier: Modifier = Modifier,
) {
    var origin by remember(initialOrigin) { mutableStateOf(initialOrigin) }
    var destination by remember(initialDestination) { mutableStateOf(initialDestination) }
    var battery by remember(initialBatteryPercent) { mutableStateOf(initialBatteryPercent.toFloat()) }
    var reserve by remember(initialReservePercent) { mutableStateOf(initialReservePercent.toFloat()) }
    var distanceInput by remember { mutableStateOf("") }
    val energyEstimate = estimateRouteEnergy(distanceInput.replace(',', '.').toDoubleOrNull() ?: 0.0, vehicle.copy(
        currentBatteryPercent = battery.toInt(), reservePercent = reserve.toInt(),
    ))
    val colors = MaterialTheme.colorScheme

    Column(
        modifier = modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(20.dp),
    ) {
        Text("Yol planı", color = colors.onSurface, fontSize = 27.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(6.dp))
        Text(
            "Aracın ve tercih ettiğin varış rezervi için şarj duraklarını hazırla.",
            color = colors.onSurfaceVariant,
            fontSize = 14.sp,
        )
        Spacer(Modifier.height(20.dp))

        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = colors.surface),
        ) {
            Column(Modifier.padding(18.dp)) {
                OutlinedTextField(
                    value = origin,
                    onValueChange = { origin = it },
                    label = { Text("Nereden") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(10.dp))
                OutlinedTextField(
                    value = destination,
                    onValueChange = { destination = it },
                    label = { Text("Nereye") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(16.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Yola çıkış bataryası", color = colors.onSurface, modifier = Modifier.weight(1f))
                    Text("${battery.toInt()}%", color = colors.primary, fontWeight = FontWeight.Bold)
                }
                Slider(
                    value = battery,
                    onValueChange = { battery = it },
                    valueRange = 10f..100f,
                    modifier = Modifier.fillMaxWidth(),
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Varışta korunacak rezerv", color = colors.onSurface, modifier = Modifier.weight(1f))
                    Text("${reserve.toInt()}%", color = colors.primary, fontWeight = FontWeight.Bold)
                }
                Slider(
                    value = reserve,
                    onValueChange = { reserve = it },
                    valueRange = 5f..40f,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(8.dp))
                OutlinedTextField(
                    value = distanceInput,
                    onValueChange = { distanceInput = it.filter { char -> char.isDigit() || char == '.' || char == ',' } },
                    label = { Text("Tahmini yol mesafesi (km, isteğe bağlı)") },
                    supportingText = { Text("Harita rotası değildir; elindeki mesafe için enerji hesabı yapar.") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                if (energyEstimate != null) {
                    Spacer(Modifier.height(10.dp))
                    Surface(
                        color = if (energyEstimate.reserveMet) colors.primary.copy(alpha = .10f) else colors.errorContainer,
                        shape = RoundedCornerShape(16.dp),
                        modifier = Modifier.fillMaxWidth(),
                    ) {
                        Column(Modifier.padding(14.dp)) {
                            Text(
                                if (energyEstimate.reserveMet) "Rezerv hesabı karşılanıyor" else "Bu mesafede rezerv korunmuyor",
                                color = if (energyEstimate.reserveMet) colors.primary else colors.onErrorContainer,
                                fontWeight = FontWeight.SemiBold,
                            )
                            Spacer(Modifier.height(4.dp))
                            Text(
                                "Yaklaşık ${(energyEstimate.energyNeededKwh * 10).toInt() / 10.0} kWh gerekir · varışta yaklaşık %${energyEstimate.arrivalBatteryPercent}",
                                color = colors.onSurfaceVariant,
                                fontSize = 12.sp,
                            )
                        }
                    }
                }
                Spacer(Modifier.height(10.dp))
                Button(
                    onClick = {
                        onPlanRequested(RoutePlanDraft(origin.trim(), destination.trim(), battery.toInt(), reserve.toInt(), distanceInput.replace(',', '.').toDoubleOrNull()))
                    },
                    enabled = origin.isNotBlank() && destination.isNotBlank(),
                    modifier = Modifier.fillMaxWidth().height(50.dp),
                    shape = RoundedCornerShape(15.dp),
                ) {
                    Text("Durak adaylarını göster")
                }
            }
        }

        Spacer(Modifier.height(18.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text("Örnek durak adayları", color = colors.onSurface, fontSize = 18.sp, fontWeight = FontWeight.SemiBold)
        }
        Spacer(Modifier.height(4.dp))
        Text("Gerçek rota ve menzil verisi bağlı değil.", color = colors.onSurfaceVariant, fontSize = 12.sp)
        Spacer(Modifier.height(10.dp))
        SampleStopCard("Gebze dinlenme tesisi", "Örnek ağ · CCS2 · güç bilgisi doğrulanmadı")
        Spacer(Modifier.height(9.dp))
        SampleStopCard("Osmangazi çevresi", "Örnek ağ · araç uyumu ve doluluk bilinmiyor")
        Spacer(Modifier.height(14.dp))
        Surface(color = colors.primary.copy(alpha = .10f), shape = RoundedCornerShape(18.dp), modifier = Modifier.fillMaxWidth()) {
            Text(
                "Menzil tahmini; hız, hava, yük, yol eğimi ve batarya sağlığına göre değişir. Canlı harita/araç verisi olmadan bu ekran rota tavsiyesi vermez.",
                color = colors.onSurfaceVariant,
                fontSize = 12.sp,
                lineHeight = 18.sp,
                modifier = Modifier.padding(15.dp),
            )
        }
    }
}

@Composable
private fun SampleStopCard(title: String, detail: String) {
    val colors = MaterialTheme.colorScheme
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(18.dp),
        colors = CardDefaults.cardColors(containerColor = colors.surfaceVariant),
    ) {
        Column(Modifier.padding(15.dp)) {
            Text(title, color = colors.onSurface, fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
            Spacer(Modifier.height(4.dp))
            Text(detail, color = colors.onSurfaceVariant, fontSize = 12.sp)
        }
    }
}
