package com.ferdidrgn.voltavia.kmp.feature.vehicle

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.weight
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Slider
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
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

/** Values used by the UI prototype; persist in the vehicle feature repository later. */
data class VehicleProfile(
    val name: String,
    val batteryCapacityKwh: Int,
    val connector: String,
    val currentBatteryPercent: Int,
    val consumptionWhPerKm: Int = 180,
    val reservePercent: Int = 15,
    val catalogId: String = "custom",
)

/** Conservative planning range; it is a user-configured estimate, never a live vehicle reading. */
fun estimateUsableRangeKm(profile: VehicleProfile): Int {
    if (profile.batteryCapacityKwh <= 0 || profile.consumptionWhPerKm <= 0) return 0
    val usablePercent = (profile.currentBatteryPercent - profile.reservePercent).coerceAtLeast(0)
    val usableEnergyKwh = profile.batteryCapacityKwh * usablePercent / 100.0
    return (usableEnergyKwh * 1000.0 / profile.consumptionWhPerKm).toInt()
}

@Composable
fun VehicleProfileScreen(
    initialProfile: VehicleProfile = VehicleProfile(
        name = "Togg T10X · V1 RWD Uzun Menzil",
        batteryCapacityKwh = 89,
        connector = "CCS2",
        currentBatteryPercent = 64,
        catalogId = "togg-t10x-long",
    ),
    onSave: (VehicleProfile) -> Unit = {},
    modifier: Modifier = Modifier,
) {
    var name by remember(initialProfile) { mutableStateOf(initialProfile.name) }
    var capacity by remember(initialProfile) { mutableStateOf(initialProfile.batteryCapacityKwh.toFloat()) }
    var connector by remember(initialProfile) { mutableStateOf(initialProfile.connector) }
    var battery by remember(initialProfile) { mutableStateOf(initialProfile.currentBatteryPercent.toFloat()) }
    var consumption by remember(initialProfile) { mutableStateOf(initialProfile.consumptionWhPerKm.toFloat()) }
    var reserve by remember(initialProfile) { mutableStateOf(initialProfile.reservePercent.toFloat()) }
    var catalogId by remember(initialProfile) { mutableStateOf(initialProfile.catalogId) }
    var catalogQuery by remember(initialProfile) {
        mutableStateOf(VehicleCatalog.find(initialProfile.catalogId)?.displayName.orEmpty())
    }
    var showCatalog by remember { mutableStateOf(false) }
    var saved by remember { mutableStateOf(false) }
    val colors = MaterialTheme.colorScheme

    Column(
        modifier = modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(20.dp),
    ) {
        Text("Araç profilim", color = colors.onSurface, fontSize = 27.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(6.dp))
        Text(
            "Soket uyumunu ve rota önerilerini aracına göre düzenle.",
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
                Text("Kayıtlı araç", color = colors.primary, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                Spacer(Modifier.height(8.dp))
                androidx.compose.foundation.layout.Box {
                    OutlinedTextField(
                        value = catalogQuery,
                        onValueChange = { catalogQuery = it; showCatalog = true },
                        label = { Text("Elektrikli araç kataloğunda ara") },
                        placeholder = { Text("Marka, model veya versiyon") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                    )
                    androidx.compose.material3.DropdownMenu(
                        expanded = showCatalog && catalogQuery.isNotBlank(),
                        onDismissRequest = { showCatalog = false },
                        modifier = Modifier.fillMaxWidth(.92f),
                    ) {
                        VehicleCatalog.entries.filter { it.displayName.contains(catalogQuery, ignoreCase = true) }
                            .take(8).forEach { item ->
                                androidx.compose.material3.DropdownMenuItem(
                                    text = {
                                        Column {
                                            Text(item.displayName, fontWeight = FontWeight.SemiBold)
                                            Text("${item.batteryCapacityKwh} kWh · ${item.connector}${item.wltpRangeKm?.let { " · WLTP $it km" }.orEmpty()}", fontSize = 12.sp, color = colors.onSurfaceVariant)
                                        }
                                    },
                                    onClick = {
                                        catalogId = item.id
                                        catalogQuery = item.displayName
                                        name = item.displayName
                                        capacity = item.batteryCapacityKwh.toFloat()
                                        connector = item.connector
                                        consumption = item.baselineConsumptionWhPerKm.toFloat()
                                        saved = false
                                        showCatalog = false
                                    },
                                )
                            }
                    }
                }
                Spacer(Modifier.height(8.dp))
                Text(
                    "Başlangıç kataloğu: ${VehicleCatalog.entries.size} varyant. Katalog tüketimi batarya/WLTP değerlerinden türetilen yaklaşık başlangıç değeridir; araç yılını ve ruhsat/üretici verisini doğrula.",
                    color = colors.onSurfaceVariant,
                    fontSize = 11.sp,
                    lineHeight = 16.sp,
                )
                VehicleCatalog.find(catalogId)?.let { item ->
                    val uriHandler = androidx.compose.ui.platform.LocalUriHandler.current
                    androidx.compose.material3.TextButton(onClick = { uriHandler.openUri(item.sourceUrl) }) {
                        Text("Teknik kaynak: ${item.sourceLabel}")
                    }
                }
                Spacer(Modifier.height(8.dp))
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it; saved = false },
                    label = { Text("Marka ve model") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(12.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Batarya kapasitesi", color = colors.onSurface, modifier = Modifier.weight(1f))
                    Text("${capacity.toInt()} kWh", color = colors.primary, fontWeight = FontWeight.Bold)
                }
                Slider(
                    value = capacity,
                    onValueChange = { capacity = it; saved = false },
                    valueRange = 20f..150f,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(8.dp))
                Text("Aracın soket tipi", color = colors.onSurface, fontWeight = FontWeight.SemiBold)
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf("CCS2", "Type 2", "CHAdeMO").forEach { item ->
                        FilterChip(
                            selected = connector == item,
                            onClick = { connector = item; saved = false },
                            label = { Text(item) },
                        )
                    }
                }
                Spacer(Modifier.height(10.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Mevcut batarya", color = colors.onSurface, modifier = Modifier.weight(1f))
                    Text("${battery.toInt()}%", color = colors.primary, fontWeight = FontWeight.Bold)
                }
                Slider(
                    value = battery,
                    onValueChange = { battery = it; saved = false },
                    valueRange = 0f..100f,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(8.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Tahmini tüketim", color = colors.onSurface, modifier = Modifier.weight(1f))
                    Text("${consumption.toInt()} Wh/km", color = colors.primary, fontWeight = FontWeight.Bold)
                }
                Slider(
                    value = consumption,
                    onValueChange = { consumption = it; saved = false },
                    valueRange = 120f..350f,
                    modifier = Modifier.fillMaxWidth(),
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Korunacak batarya rezervi", color = colors.onSurface, modifier = Modifier.weight(1f))
                    Text("${reserve.toInt()}%", color = colors.primary, fontWeight = FontWeight.Bold)
                }
                Slider(
                    value = reserve,
                    onValueChange = { reserve = it; saved = false },
                    valueRange = 5f..40f,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(8.dp))
                Button(
                    onClick = {
                        onSave(VehicleProfile(name.trim(), capacity.toInt(), connector, battery.toInt(), consumption.toInt(), reserve.toInt(), catalogId))
                        saved = true
                    },
                    enabled = name.isNotBlank(),
                    modifier = Modifier.fillMaxWidth().height(50.dp),
                    shape = RoundedCornerShape(15.dp),
                ) {
                    Text(if (saved) "Araç profili kaydedildi" else "Araç profilini kaydet")
                }
            }
        }

        Spacer(Modifier.height(14.dp))
        Surface(
            color = colors.surfaceVariant,
            shape = RoundedCornerShape(18.dp),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Column(Modifier.padding(15.dp)) {
                Text("Rezerv korunursa tahmini menzil", color = colors.onSurfaceVariant, fontSize = 12.sp)
                Spacer(Modifier.height(4.dp))
                Text("${estimateUsableRangeKm(VehicleProfile(name, capacity.toInt(), connector, battery.toInt(), consumption.toInt(), reserve.toInt()))} km", color = colors.onSurface, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text("Girilen tüketim değerine dayalı kaba hesap; hava, hız, eğim ve batarya sağlığı dahil değildir.", color = colors.onSurfaceVariant, fontSize = 12.sp, lineHeight = 18.sp)
            }
        }

        Spacer(Modifier.height(14.dp))
        Surface(
            color = colors.primary.copy(alpha = .10f),
            shape = RoundedCornerShape(18.dp),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Row(Modifier.padding(15.dp), verticalAlignment = Alignment.Top) {
                Text("ⓘ", color = colors.primary, fontWeight = FontWeight.Bold)
                Spacer(Modifier.width(10.dp))
                Text(
                    "Araç değerleri şimdilik bu prototipin örnek girdileridir. Resmî araç kataloğu bağlanmadan menzil veya şarj süresi garantisi verilmez.",
                    color = colors.onSurfaceVariant,
                    fontSize = 12.sp,
                    lineHeight = 18.sp,
                )
            }
        }
    }
}
