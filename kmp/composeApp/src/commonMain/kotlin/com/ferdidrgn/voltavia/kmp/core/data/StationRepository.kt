package com.ferdidrgn.voltavia.kmp.core.data

import com.ferdidrgn.voltavia.kmp.core.model.AvailabilityStatus
import com.ferdidrgn.voltavia.kmp.core.model.ChargingStation
import com.ferdidrgn.voltavia.kmp.core.model.StationFilters

/** All values below are fabricated UI fixtures, not real charging locations or live data. */
object DemoStations {
    val all: List<ChargingStation> = listOf(
        ChargingStation(
            id = "demo-kadikoy-01",
            name = "Kadıköy demo noktası",
            operatorName = "Demo operatör",
            address = "Örnek adres · gerçek istasyon değil",
            distanceKm = 1.2,
            connectors = listOf("CCS2", "Type 2"),
            powerKw = 180.0,
            availability = AvailabilityStatus.Unknown,
            sourceLabel = "Demo veri · canlı değil",
            updatedAtLabel = "Güncelleme zamanı bilinmiyor",
            chargingStartSupported = false,
        ),
        ChargingStation(
            id = "demo-besiktas-02",
            name = "Beşiktaş demo noktası",
            operatorName = "Demo operatör",
            address = "Örnek adres · gerçek istasyon değil",
            distanceKm = 3.8,
            connectors = listOf("CCS2", "CHAdeMO"),
            powerKw = 120.0,
            availability = AvailabilityStatus.Unknown,
            sourceLabel = "Demo veri · canlı değil",
            updatedAtLabel = "Güncelleme zamanı bilinmiyor",
            chargingStartSupported = false,
        ),
        ChargingStation(
            id = "demo-uskudar-03",
            name = "Üsküdar demo noktası",
            operatorName = "Demo operatör",
            address = "Örnek adres · gerçek istasyon değil",
            distanceKm = 5.1,
            connectors = listOf("Type 2"),
            powerKw = 22.0,
            availability = AvailabilityStatus.Unknown,
            sourceLabel = "Demo veri · canlı değil",
            updatedAtLabel = "Güncelleme zamanı bilinmiyor",
            chargingStartSupported = false,
        ),
        ChargingStation(
            id = "demo-atasehir-04",
            name = "Ataşehir demo noktası",
            operatorName = "Demo operatör",
            address = "Örnek adres · gerçek istasyon değil",
            distanceKm = 8.4,
            connectors = listOf("CCS2", "GB/T"),
            powerKw = 240.0,
            availability = AvailabilityStatus.Unknown,
            sourceLabel = "Demo veri · canlı değil",
            updatedAtLabel = "Güncelleme zamanı bilinmiyor",
            chargingStartSupported = false,
        ),
    )
}

fun filterStations(
    stations: List<ChargingStation>,
    filters: StationFilters,
    favoriteIds: Set<String> = emptySet(),
): List<ChargingStation> {
    val query = normalize(filters.query)
    return stations.filter { station ->
        val textMatches = query.isBlank() || normalize(
            listOf(station.name, station.operatorName, station.address).joinToString(" "),
        ).contains(query)
        val connectorMatches = filters.connector == null || filters.connector in station.connectors
        val compatibleMatches = filters.compatibleConnector == null || station.connectors.any {
            normalizeConnector(it) == normalizeConnector(filters.compatibleConnector)
        }
        val powerMatches = filters.minimumPowerKw == null || station.powerKw >= filters.minimumPowerKw
        // Unknown prices never pass a price cap: absence of evidence is not a cheap tariff.
        val priceMatches = filters.maximumPricePerKwh == null ||
            (station.pricePerKwh != null && station.pricePerKwh <= filters.maximumPricePerKwh)
        val statusMatches = filters.status == null || station.availability == filters.status
        val favoriteMatches = !filters.favoritesOnly || station.id in favoriteIds
        textMatches && connectorMatches && compatibleMatches && powerMatches && priceMatches && statusMatches && favoriteMatches
    }
}

/** Returns a new immutable set so Compose can observe favorite changes. */
fun toggleFavorite(favoriteIds: Set<String>, stationId: String): Set<String> =
    if (stationId in favoriteIds) favoriteIds - stationId else favoriteIds + stationId

private fun normalize(value: String): String = value
    .lowercase()
    .replace('ı', 'i')
    .replace('ş', 's')
    .replace('ğ', 'g')
    .replace('ü', 'u')
    .replace('ö', 'o')
    .replace('ç', 'c')
    .trim()

private fun normalizeConnector(value: String): String = value.uppercase().replace(" ", "").replace("-", "")
