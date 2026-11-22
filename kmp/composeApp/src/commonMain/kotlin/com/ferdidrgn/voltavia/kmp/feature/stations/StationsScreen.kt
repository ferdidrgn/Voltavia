package com.ferdidrgn.voltavia.kmp.feature.stations

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ferdidrgn.voltavia.kmp.core.model.AvailabilityStatus
import com.ferdidrgn.voltavia.kmp.core.model.ChargingStation

private val stationFilters = listOf("Tümü", "Hızlı şarj", "Araç uyumlu", "Uygun", "Favoriler")

@Composable
fun StationsScreen(
    stations: List<ChargingStation>,
    query: String,
    selectedFilter: String,
    vehicleConnector: String,
    selectedConnector: String?,
    sortMode: String,
    isDemoCatalog: Boolean,
    favoriteIds: Set<String>,
    onQueryChange: (String) -> Unit,
    onFilterChange: (String) -> Unit,
    onConnectorChange: (String?) -> Unit,
    onSortChange: (String) -> Unit,
    onStationClick: (ChargingStation) -> Unit,
    onToggleFavorite: (ChargingStation) -> Unit,
    modifier: Modifier = Modifier,
) {
    val visibleStations = stations.filter { station ->
        val matchesQuery = query.isBlank() || listOf(station.name, station.operatorName, station.address)
            .any { it.contains(query, ignoreCase = true) }
        val matchesFilter = when (selectedFilter) {
            "Hızlı şarj" -> station.powerKw >= 50.0
            "Araç uyumlu" -> station.connectors.any { it.uppercase().replace(" ", "").replace("-", "") == vehicleConnector.uppercase().replace(" ", "").replace("-", "") }
            "Uygun" -> station.availability == AvailabilityStatus.Available
            "Favoriler" -> station.id in favoriteIds
            else -> true
        }
        val matchesConnector = selectedConnector == null || station.connectors.any {
            it.uppercase().replace(" ", "").replace("-", "") == selectedConnector.uppercase().replace(" ", "").replace("-", "")
        }
        matchesQuery && matchesFilter && matchesConnector
    }.let { filtered ->
        when (sortMode) {
            "En güçlü" -> filtered.sortedByDescending { it.powerKw }
            else -> filtered.sortedBy { it.distanceKm }
        }
    }

    Column(modifier.fillMaxSize().padding(horizontal = 20.dp)) {
        Spacer(Modifier.height(18.dp))
        Text("İstasyonlar", color = MaterialTheme.colorScheme.onSurface, fontSize = 27.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(4.dp))
        Text("Aracına uyan şarj noktalarını keşfet.", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 14.sp)
        if (isDemoCatalog) {
            Spacer(Modifier.height(10.dp))
            Surface(color = MaterialTheme.colorScheme.secondary.copy(alpha = .12f), shape = RoundedCornerShape(14.dp)) {
                Text(
                    "Örnek katalog · canlı istasyon ve uygunluk verisi bağlı değil",
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    fontSize = 12.sp,
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 9.dp),
                )
            }
        }
        Spacer(Modifier.height(16.dp))
        OutlinedTextField(
            value = query,
            onValueChange = onQueryChange,
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(18.dp),
            singleLine = true,
            label = { Text("Şehir, operatör veya istasyon") },
            leadingIcon = { Text("⌕", color = MaterialTheme.colorScheme.primary, fontSize = 22.sp) },
        )
        Spacer(Modifier.height(10.dp))
        Row(Modifier.horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            stationFilters.forEach { filter ->
                FilterChip(
                    selected = selectedFilter == filter,
                    onClick = { onFilterChange(filter) },
                    label = { Text(filter) },
                )
            }
        }
        Spacer(Modifier.height(4.dp))
        Row(Modifier.horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            listOf("Yakına göre", "En güçlü").forEach { sort ->
                FilterChip(selected = sortMode == sort, onClick = { onSortChange(sort) }, label = { Text(sort) })
            }
        }
        Spacer(Modifier.height(4.dp))
        Row(Modifier.horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            val connectorOptions = listOf(null, "CCS2", "Type 2", "CHAdeMO", "GB/T")
            connectorOptions.forEach { connector ->
                FilterChip(
                    selected = selectedConnector == connector,
                    onClick = { onConnectorChange(connector) },
                    label = { Text(connector ?: "Tüm soketler") },
                )
            }
        }
        Spacer(Modifier.height(10.dp))
        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
            Text("${visibleStations.size} nokta", color = MaterialTheme.colorScheme.onSurface, fontWeight = FontWeight.SemiBold, modifier = Modifier.weight(1f))
            Text("Örnek katalog", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
        }
        Spacer(Modifier.height(8.dp))
        if (visibleStations.isEmpty()) {
            EmptyStationsState(query = query, onClear = { onQueryChange(""); onFilterChange("Tümü"); onConnectorChange(null) })
        } else {
            LazyColumn(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                contentPadding = androidx.compose.foundation.layout.PaddingValues(bottom = 20.dp),
            ) {
                items(visibleStations, key = { it.id }) { station ->
                    StationListCard(
                        station = station,
                        isFavorite = station.id in favoriteIds,
                        onClick = { onStationClick(station) },
                        onToggleFavorite = { onToggleFavorite(station) },
                    )
                }
            }
        }
    }
}

@Composable
private fun StationListCard(
    station: ChargingStation,
    isFavorite: Boolean,
    onClick: () -> Unit,
    onToggleFavorite: () -> Unit,
) {
    val availabilityLabel = when (station.availability) {
        AvailabilityStatus.Available -> "uygun"
        AvailabilityStatus.Busy -> "dolu"
        AvailabilityStatus.Offline -> "hizmet dışı"
        AvailabilityStatus.Unknown -> "durum bilinmiyor"
    }
    Card(
        onClick = onClick,
        shape = RoundedCornerShape(22.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = androidx.compose.foundation.BorderStroke(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = .45f)),
        modifier = Modifier.fillMaxWidth().semantics {
            contentDescription = "${station.name}, ${station.powerKw.toInt()} kilovat, ${station.connectors.joinToString()}, $availabilityLabel"
        },
    ) {
        Column(Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Surface(
                    color = MaterialTheme.colorScheme.primary.copy(alpha = .14f),
                    shape = RoundedCornerShape(13.dp),
                ) { Text("ϟ", color = MaterialTheme.colorScheme.primary, fontSize = 20.sp, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 11.dp, vertical = 8.dp)) }
                Column(Modifier.weight(1f).padding(start = 12.dp, end = 4.dp)) {
                    Text(station.name, color = MaterialTheme.colorScheme.onSurface, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, maxLines = 1, overflow = TextOverflow.Ellipsis)
                    Text(station.operatorName, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp)
                }
                TextButton(
                    onClick = onToggleFavorite,
                    modifier = Modifier.semantics { contentDescription = if (isFavorite) "Favorilerden çıkar" else "Favorilere ekle" },
                ) {
                    Text(if (isFavorite) "♥" else "♡", color = MaterialTheme.colorScheme.primary, fontSize = 22.sp)
                }
            }
            Spacer(Modifier.height(10.dp))
            Text(station.address, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 12.sp, maxLines = 1, overflow = TextOverflow.Ellipsis)
            Spacer(Modifier.height(12.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(7.dp), verticalAlignment = Alignment.CenterVertically) {
                StationTag("${station.powerKw.toInt()} kW")
                station.connectors.take(2).forEach { StationTag(it) }
                StatusTag(station.availability)
            }
            Spacer(Modifier.height(12.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                Column(Modifier.weight(1f)) {
                    Text(
                        station.pricePerKwh?.let { "₺${it} / kWh" } ?: "Tarife bilgisi yok",
                        color = MaterialTheme.colorScheme.onSurface,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 14.sp,
                    )
                    Text("${station.sourceLabel} · ${station.updatedAtLabel}", color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp, maxLines = 1, overflow = TextOverflow.Ellipsis)
                }
                Text("Detaylar  ›", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.SemiBold, fontSize = 12.sp)
            }
        }
    }
}

@Composable
internal fun StationTag(label: String) {
    Surface(color = MaterialTheme.colorScheme.surfaceVariant, shape = RoundedCornerShape(9.dp)) {
        Text(label, color = MaterialTheme.colorScheme.onSurfaceVariant, fontSize = 10.sp, modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp))
    }
}

@Composable
internal fun StatusTag(status: AvailabilityStatus) {
    val (label, tint) = when (status) {
        AvailabilityStatus.Available -> "Uygun" to MaterialTheme.colorScheme.primary
        AvailabilityStatus.Busy -> "Dolu" to MaterialTheme.colorScheme.tertiary
        AvailabilityStatus.Offline -> "Hizmet dışı" to MaterialTheme.colorScheme.error
        AvailabilityStatus.Unknown -> "Durum bilinmiyor" to MaterialTheme.colorScheme.onSurfaceVariant
    }
    Surface(color = tint.copy(alpha = .12f), shape = CircleShape) {
        Text(label, color = tint, fontSize = 10.sp, fontWeight = FontWeight.Medium, modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp))
    }
}

@Composable
private fun EmptyStationsState(query: String, onClear: () -> Unit) {
    Column(
        Modifier.fillMaxWidth().padding(vertical = 34.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Text("Aramana uygun nokta yok", color = MaterialTheme.colorScheme.onSurface, fontWeight = FontWeight.SemiBold)
        Text(
            if (query.isBlank()) "Filtreleri değiştirip yeniden dene." else "Başka bir şehir, operatör veya istasyon adı dene.",
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            fontSize = 13.sp,
        )
        TextButton(onClick = onClear) { Text("Aramayı ve filtreleri temizle") }
    }
}
