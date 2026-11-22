package com.ferdidrgn.voltavia.kmp

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ferdidrgn.voltavia.kmp.core.data.DemoStations
import com.ferdidrgn.voltavia.kmp.core.data.VoltaviaSettings
import com.ferdidrgn.voltavia.kmp.core.data.VoltaviaSettingsRepository
import com.ferdidrgn.voltavia.kmp.core.data.filterStations
import com.ferdidrgn.voltavia.kmp.core.data.toggleFavorite
import com.ferdidrgn.voltavia.kmp.core.designsystem.ThemePreset
import com.ferdidrgn.voltavia.kmp.core.designsystem.ThemePresetPicker
import com.ferdidrgn.voltavia.kmp.core.designsystem.VoltaviaTheme
import com.ferdidrgn.voltavia.kmp.core.model.ChargingStation
import com.ferdidrgn.voltavia.kmp.core.model.StationFilters
import com.ferdidrgn.voltavia.kmp.feature.home.MapHomeScreen
import com.ferdidrgn.voltavia.kmp.feature.route.RoutePlannerScreen
import com.ferdidrgn.voltavia.kmp.feature.stations.StationDetailScreen
import com.ferdidrgn.voltavia.kmp.feature.stations.StationsScreen
import com.ferdidrgn.voltavia.kmp.feature.vehicle.VehicleProfile
import com.ferdidrgn.voltavia.kmp.feature.vehicle.VehicleProfileScreen
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.collect

private enum class AppTab(val title: String, val symbol: String) {
    Map("Harita", "⌖"),
    Stations("İstasyon", "ϟ"),
    Route("Yol planı", "⇢"),
    Vehicle("Aracım", "EV"),
    Profile("Profil", "◉"),
}

private fun VehicleProfile.toSettings() = VoltaviaSettings(
    vehicleName = name,
    batteryCapacityKwh = batteryCapacityKwh,
    connector = connector,
    batteryPercent = currentBatteryPercent,
    consumptionWhPerKm = consumptionWhPerKm,
    reservePercent = reservePercent,
    vehicleCatalogId = catalogId,
)

@Composable
fun VoltaviaApp(settingsRepository: VoltaviaSettingsRepository) {
    var palette by remember { mutableStateOf(ThemePreset.Harbor) }
    var darkMode by remember { mutableStateOf(true) }
    var accentHex by remember { mutableStateOf("") }
    var customAccent by remember { mutableStateOf<Color?>(null) }
    var selectedTab by remember { mutableStateOf(AppTab.Map) }
    var selectedStation by remember { mutableStateOf<ChargingStation?>(null) }
    var query by remember { mutableStateOf("") }
    var stationFilter by remember { mutableStateOf("Tümü") }
    var connectorFilter by remember { mutableStateOf<String?>(null) }
    var stationSort by remember { mutableStateOf("Yakına göre") }
    var favoriteIds by remember { mutableStateOf(emptySet<String>()) }
    var vehicle by remember { mutableStateOf(VehicleProfile("Togg T10X · V1 RWD Uzun Menzil", 89, "CCS2", 64, 170, 15, "togg-t10x-long")) }
    val snackbarState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(settingsRepository) {
        settingsRepository.settings.collect { settings ->
            palette = ThemePreset.entries.firstOrNull { it.name == settings.themePreset } ?: ThemePreset.Harbor
            darkMode = settings.darkMode
            accentHex = settings.accentHex
            customAccent = settings.accentHex.removePrefix("#").takeIf { it.length == 6 }
                ?.toLongOrNull(16)?.let { Color(0xFF000000 or it) }
            favoriteIds = settings.favoriteStationIds
            stationFilter = settings.stationFilter
            connectorFilter = settings.connectorFilter.takeIf { it.isNotBlank() }
            stationSort = settings.stationSort
            vehicle = VehicleProfile(
                name = settings.vehicleName,
                batteryCapacityKwh = settings.batteryCapacityKwh,
                connector = settings.connector,
                currentBatteryPercent = settings.batteryPercent,
                consumptionWhPerKm = settings.consumptionWhPerKm,
                reservePercent = settings.reservePercent,
                catalogId = settings.vehicleCatalogId,
            )
        }
    }

    VoltaviaTheme(palette, darkMode, customAccent) {
        val colors = MaterialTheme.colorScheme
        val filteredStations = filterStations(
            stations = DemoStations.all,
            filters = StationFilters(
                query = query,
                connector = connectorFilter,
                compatibleConnector = if (stationFilter == "Araç uyumlu") vehicle.connector else null,
                minimumPowerKw = if (stationFilter == "Hızlı şarj") 50.0 else null,
                status = if (stationFilter == "Uygun") com.ferdidrgn.voltavia.kmp.core.model.AvailabilityStatus.Available else null,
                favoritesOnly = stationFilter == "Favoriler",
            ),
            favoriteIds = favoriteIds,
        )

        Scaffold(
            containerColor = colors.background,
            contentWindowInsets = WindowInsets(0, 0, 0, 0),
            snackbarHost = { SnackbarHost(snackbarState) },
            bottomBar = {
                if (selectedStation == null) {
                    NavigationBar(
                        containerColor = colors.surface,
                        contentColor = colors.onSurface,
                        tonalElevation = 0.dp,
                        modifier = Modifier.windowInsetsPadding(WindowInsets.navigationBars),
                    ) {
                        AppTab.entries.forEach { item ->
                            NavigationBarItem(
                                selected = selectedTab == item,
                                onClick = { selectedTab = item },
                                icon = { Text(item.symbol, fontSize = 20.sp, fontWeight = FontWeight.SemiBold) },
                                label = { Text(item.title, maxLines = 1) },
                                colors = NavigationBarItemDefaults.colors(
                                    selectedIconColor = colors.primary,
                                    selectedTextColor = colors.primary,
                                    indicatorColor = colors.primary.copy(alpha = .12f),
                                    unselectedIconColor = colors.onSurface.copy(alpha = .68f),
                                    unselectedTextColor = colors.onSurface.copy(alpha = .68f),
                                ),
                            )
                        }
                    }
                }
            },
        ) { insets ->
            when (val station = selectedStation) {
                null -> when (selectedTab) {
                    AppTab.Map -> MapHomeScreen(
                        station = DemoStations.all.first(),
                        vehicle = vehicle,
                        onSeeStations = { selectedTab = AppTab.Stations },
                        onStationClick = { selectedStation = DemoStations.all.first() },
                        onOpenVehicle = { selectedTab = AppTab.Vehicle },
                        onOpenThemes = { selectedTab = AppTab.Profile },
                        modifier = Modifier.padding(insets),
                    )

                    AppTab.Stations -> StationsScreen(
                        stations = filteredStations,
                        query = query,
                        selectedFilter = stationFilter,
                        vehicleConnector = vehicle.connector,
                        selectedConnector = connectorFilter,
                        sortMode = stationSort,
                        isDemoCatalog = true,
                        favoriteIds = favoriteIds,
                        onQueryChange = { query = it },
                        onFilterChange = {
                            stationFilter = it
                            scope.launch { settingsRepository.saveStationFilter(it) }
                        },
                        onConnectorChange = {
                            connectorFilter = it
                            scope.launch { settingsRepository.saveConnectorFilter(it) }
                        },
                        onSortChange = {
                            stationSort = it
                            scope.launch { settingsRepository.saveStationSort(it) }
                        },
                        onStationClick = { selectedStation = it },
                        onToggleFavorite = {
                            favoriteIds = toggleFavorite(favoriteIds, it.id)
                            scope.launch { settingsRepository.saveFavorites(favoriteIds) }
                        },
                        modifier = Modifier.padding(insets),
                    )

                    AppTab.Route -> RoutePlannerScreen(
                        initialBatteryPercent = vehicle.currentBatteryPercent,
                        initialReservePercent = vehicle.reservePercent,
                        vehicle = vehicle,
                        onPlanRequested = {
                            scope.launch {
                                snackbarState.showSnackbar("Rota hesabı için harita ve araç verisi henüz bağlı değil.")
                            }
                        },
                        modifier = Modifier.padding(insets),
                    )

                    AppTab.Vehicle -> VehicleProfileScreen(
                        initialProfile = vehicle,
                        onSave = {
                            vehicle = it
                            scope.launch { settingsRepository.saveVehicle(it.toSettings()) }
                        },
                        modifier = Modifier.padding(insets),
                    )

                    AppTab.Profile -> ProfileScreen(
                        palette = palette,
                        onPaletteChange = {
                            palette = it
                            scope.launch { settingsRepository.saveTheme(it.name, darkMode, accentHex) }
                        },
                        darkMode = darkMode,
                        onDarkModeChange = {
                            darkMode = it
                            scope.launch { settingsRepository.saveTheme(palette.name, it, accentHex) }
                        },
                        accentHex = accentHex,
                        onAccentHexChange = { value ->
                            val normalized = value.trim().removePrefix("#")
                            accentHex = normalized.take(6).filter { it.isDigit() || it.lowercaseChar() in 'a'..'f' }
                            customAccent = accentHex.takeIf { it.length == 6 }?.toLongOrNull(16)?.let { Color(0xFF000000 or it) }
                            scope.launch { settingsRepository.saveTheme(palette.name, darkMode, accentHex) }
                        },
                        favoriteCount = favoriteIds.size,
                        vehicleName = vehicle.name,
                        vehicleBattery = vehicle.currentBatteryPercent,
                        vehicleRange = com.ferdidrgn.voltavia.kmp.feature.vehicle.estimateUsableRangeKm(vehicle),
                        vehicleConnector = vehicle.connector,
                        onOpenVehicle = { selectedTab = AppTab.Vehicle },
                        modifier = Modifier.padding(insets),
                    )
                }

                else -> StationDetailScreen(
                    station = station,
                    isFavorite = station.id in favoriteIds,
                    onBack = { selectedStation = null },
                    onToggleFavorite = {
                        favoriteIds = toggleFavorite(favoriteIds, station.id)
                        scope.launch { settingsRepository.saveFavorites(favoriteIds) }
                    },
                    onStartCharging = {
                        scope.launch { snackbarState.showSnackbar("Bu demo noktada şarj başlatma desteklenmiyor.") }
                    },
                    onOpenOperator = {
                        scope.launch { snackbarState.showSnackbar("Operatör uygulaması bağlantısı henüz yapılandırılmadı.") }
                    },
                    modifier = Modifier.padding(insets),
                )
            }
        }
    }
}

@Composable
private fun ProfileScreen(
    palette: ThemePreset,
    onPaletteChange: (ThemePreset) -> Unit,
    darkMode: Boolean,
    onDarkModeChange: (Boolean) -> Unit,
    accentHex: String,
    onAccentHexChange: (String) -> Unit,
    favoriteCount: Int,
    vehicleName: String,
    vehicleBattery: Int,
    vehicleRange: Int,
    vehicleConnector: String,
    onOpenVehicle: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier.fillMaxSize().padding(horizontal = 20.dp)) {
        Spacer(Modifier.height(22.dp))
        Text("Profil ve görünüm", color = MaterialTheme.colorScheme.onSurface, fontSize = 26.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(5.dp))
        Text("Renklerini ve sürüş tercihlerini kişiselleştir.", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 13.sp)
        Spacer(Modifier.height(22.dp))
        Text("Tema paleti", color = MaterialTheme.colorScheme.onSurface, fontSize = 17.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(5.dp))
        Text("Koyu pembe ve mor seçenekleri dahil 7 hazır palet.", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
        Spacer(Modifier.height(12.dp))
        ThemePresetPicker(selected = palette, onSelected = onPaletteChange)
        Spacer(Modifier.height(16.dp))
        Text("Görünüm", color = MaterialTheme.colorScheme.onSurface, fontSize = 17.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(8.dp))
        androidx.compose.foundation.layout.Row(horizontalArrangement = androidx.compose.foundation.layout.Arrangement.spacedBy(8.dp)) {
            androidx.compose.material3.FilterChip(selected = darkMode, onClick = { onDarkModeChange(true) }, label = { Text("Koyu") })
            androidx.compose.material3.FilterChip(selected = !darkMode, onClick = { onDarkModeChange(false) }, label = { Text("Açık") })
        }
        Spacer(Modifier.height(8.dp))
        androidx.compose.material3.OutlinedTextField(
            value = accentHex,
            onValueChange = onAccentHexChange,
            label = { Text("Özel vurgu rengi (HEX)") },
            placeholder = { Text("3BE58B") },
            supportingText = { Text("6 haneli HEX gir; boş bırakınca seçili paletin rengi kullanılır.") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
        )
        Spacer(Modifier.height(25.dp))
        Text("Aracım", color = MaterialTheme.colorScheme.onSurface, fontSize = 17.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(10.dp))
        androidx.compose.material3.Card(
            onClick = onOpenVehicle,
            modifier = Modifier.fillMaxWidth(),
            colors = androidx.compose.material3.CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        ) {
            Column(Modifier.padding(16.dp)) {
                Text(vehicleName, color = MaterialTheme.colorScheme.onSurface, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                Spacer(Modifier.height(6.dp))
                Text("Batarya %$vehicleBattery · tahmini ${vehicleRange} km · $vehicleConnector", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 13.sp)
                Spacer(Modifier.height(8.dp))
                Text("Aracı değiştir veya düzenle →", color = MaterialTheme.colorScheme.primary, fontSize = 13.sp, fontWeight = FontWeight.SemiBold)
            }
        }
        Spacer(Modifier.height(14.dp))
        Text("Hesabım", color = MaterialTheme.colorScheme.onSurface, fontSize = 17.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(7.dp))
        Text("Kaydedilen istasyon: $favoriteCount", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 14.sp)
        Spacer(Modifier.height(18.dp))
        Text("Tema ve araç tercihleri bu cihazda saklanır. Hesaplar arası eşitleme ayrıca kurulmalıdır.", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
    }
}
