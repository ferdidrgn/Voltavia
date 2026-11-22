package com.ferdidrgn.voltavia.kmp.feature.route

import com.ferdidrgn.voltavia.kmp.feature.vehicle.VehicleProfile

/** Energy-only estimate for a user-supplied distance; it does not claim a road route or live range. */
data class RouteEnergyEstimate(
    val energyNeededKwh: Double,
    val arrivalBatteryPercent: Int,
    val reserveMet: Boolean,
)

fun estimateRouteEnergy(
    distanceKm: Double,
    vehicle: VehicleProfile,
): RouteEnergyEstimate? {
    if (distanceKm <= 0 || vehicle.batteryCapacityKwh <= 0 || vehicle.consumptionWhPerKm <= 0) return null
    val energy = distanceKm * vehicle.consumptionWhPerKm / 1000.0
    val startingEnergy = vehicle.batteryCapacityKwh * vehicle.currentBatteryPercent / 100.0
    val remainingEnergy = startingEnergy - energy
    val arrivalPercent = ((remainingEnergy / vehicle.batteryCapacityKwh) * 100.0)
        .toInt()
        .coerceIn(0, 100)
    return RouteEnergyEstimate(
        energyNeededKwh = energy,
        arrivalBatteryPercent = arrivalPercent,
        reserveMet = remainingEnergy >= vehicle.batteryCapacityKwh * vehicle.reservePercent / 100.0,
    )
}
