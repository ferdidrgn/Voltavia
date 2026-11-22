package com.ferdidrgn.voltavia.kmp.feature.route

import com.ferdidrgn.voltavia.kmp.core.model.AvailabilityStatus
import com.ferdidrgn.voltavia.kmp.core.model.ChargingStation

/** Distances must come from a routing provider; this model intentionally does not invent geometry. */
data class RouteStopCandidate(
    val station: ChargingStation,
    val distanceAlongRouteKm: Double,
    val detourKm: Double,
)

fun rankRouteStops(
    candidates: List<RouteStopCandidate>,
    vehicleConnectors: Set<String>,
    remainingRangeKm: Int,
): List<RouteStopCandidate> {
    if (remainingRangeKm <= 0 || vehicleConnectors.isEmpty()) return emptyList()
    val normalizedConnectors = vehicleConnectors.map(::normalizeConnector).toSet()
    return candidates
        .filter { candidate ->
            candidate.distanceAlongRouteKm in 0.0..remainingRangeKm.toDouble() &&
                candidate.detourKm >= 0 &&
                candidate.station.connectors.any { normalizeConnector(it) in normalizedConnectors }
        }
        .sortedWith(
            compareBy<RouteStopCandidate> { availabilityRank(it.station.availability) }
                .thenBy { it.detourKm }
                .thenByDescending { it.station.powerKw },
        )
}

private fun availabilityRank(status: AvailabilityStatus): Int = when (status) {
    AvailabilityStatus.Available -> 0
    AvailabilityStatus.Unknown -> 1
    AvailabilityStatus.Busy -> 2
    AvailabilityStatus.Offline -> 3
}

private fun normalizeConnector(value: String): String = value
    .uppercase()
    .replace(" ", "")
    .replace("-", "")
