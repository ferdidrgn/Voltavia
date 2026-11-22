package com.ferdidrgn.voltavia.kmp.core.model

enum class AvailabilityStatus {
    Available,
    Busy,
    Offline,
    Unknown,
}

enum class DataConfidence { Verified, OperatorReported, CommunityReported, Unverified }
enum class LiveState { Live, Cached, Stale, Unknown }

/** Provenance travels with each mutable fact so conflicting or old data is never silently trusted. */
data class StationFact<T>(
    val value: T,
    val source: String,
    val updatedAtEpochMillis: Long?,
    val confidence: DataConfidence,
) {
    fun liveState(nowEpochMillis: Long, maxAgeMillis: Long): LiveState {
        val updated = updatedAtEpochMillis ?: return LiveState.Unknown
        if (nowEpochMillis < updated) return LiveState.Unknown
        return if (nowEpochMillis - updated <= maxAgeMillis) LiveState.Live else LiveState.Stale
    }
}

/** Station shape shared by the discovery and detail screens. */
data class ChargingStation(
    val id: String,
    val name: String,
    val operatorName: String,
    val address: String,
    val distanceKm: Double,
    val connectors: List<String>,
    val powerKw: Double,
    /** TRY/kWh; null means there is no verified tariff in the current data source. */
    val pricePerKwh: Double? = null,
    val availability: AvailabilityStatus = AvailabilityStatus.Unknown,
    /** e.g. "Demo veri · canlı değil" or a named regulator/operator source. */
    val sourceLabel: String,
    /** Human-readable update time; use "Güncelleme zamanı bilinmiyor" when absent. */
    val updatedAtLabel: String,
    val chargingStartSupported: Boolean = false,
    val availabilityFact: StationFact<AvailabilityStatus>? = null,
    val priceFact: StationFact<Double>? = null,
)

data class StationFilters(
    val query: String = "",
    val connector: String? = null,
    val compatibleConnector: String? = null,
    val minimumPowerKw: Double? = null,
    val maximumPricePerKwh: Double? = null,
    val status: AvailabilityStatus? = null,
    val favoritesOnly: Boolean = false,
)
