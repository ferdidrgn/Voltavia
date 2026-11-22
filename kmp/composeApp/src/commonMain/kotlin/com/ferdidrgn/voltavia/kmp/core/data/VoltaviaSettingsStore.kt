package com.ferdidrgn.voltavia.kmp.core.data

import androidx.datastore.core.DataStore
import androidx.datastore.core.DataStoreFactory
import androidx.datastore.core.Storage
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.PreferencesSerializer
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.core.stringSetPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private const val SETTINGS_FILE = "voltavia.preferences_pb"

expect fun createVoltaviaSettingsStore(platformContext: Any? = null): DataStore<Preferences>

fun createSettingsStore(storage: Storage<Preferences>): DataStore<Preferences> =
    DataStoreFactory.create(storage = storage)

data class VoltaviaSettings(
    val themePreset: String = "Harbor",
    val darkMode: Boolean = true,
    val accentHex: String = "",
    val favoriteStationIds: Set<String> = emptySet(),
    val stationFilter: String = "Tümü",
    val connectorFilter: String = "",
    val stationSort: String = "Yakına göre",
    val vehicleName: String = "Togg T10X · V1 RWD Uzun Menzil",
    val batteryCapacityKwh: Int = 89,
    val connector: String = "CCS2",
    val batteryPercent: Int = 64,
    val consumptionWhPerKm: Int = 180,
    val reservePercent: Int = 15,
    val vehicleCatalogId: String = "togg-t10x-long",
)

class VoltaviaSettingsRepository(private val store: DataStore<Preferences>) {
    private object Keys {
        val themePreset = stringPreferencesKey("theme_preset")
        val darkMode = booleanPreferencesKey("dark_mode")
        val accentHex = stringPreferencesKey("accent_hex")
        val favorites = stringSetPreferencesKey("favorite_station_ids")
        val stationFilter = stringPreferencesKey("station_filter")
        val connectorFilter = stringPreferencesKey("connector_filter")
        val stationSort = stringPreferencesKey("station_sort")
        val vehicleName = stringPreferencesKey("vehicle_name")
        val batteryCapacity = intPreferencesKey("battery_capacity_kwh")
        val connector = stringPreferencesKey("connector")
        val batteryPercent = intPreferencesKey("battery_percent")
        val consumption = intPreferencesKey("consumption_wh_per_km")
        val reserve = intPreferencesKey("reserve_percent")
        val vehicleCatalogId = stringPreferencesKey("vehicle_catalog_id")
    }

    val settings: Flow<VoltaviaSettings> = store.data.map { prefs ->
        VoltaviaSettings(
            themePreset = prefs[Keys.themePreset] ?: "Harbor",
            darkMode = prefs[Keys.darkMode] ?: true,
            accentHex = prefs[Keys.accentHex] ?: "",
            favoriteStationIds = prefs[Keys.favorites] ?: emptySet(),
            stationFilter = prefs[Keys.stationFilter] ?: "Tümü",
            connectorFilter = prefs[Keys.connectorFilter] ?: "",
            stationSort = prefs[Keys.stationSort] ?: "Yakına göre",
            vehicleName = prefs[Keys.vehicleName] ?: "Togg T10X · V1 RWD Uzun Menzil",
            batteryCapacityKwh = prefs[Keys.batteryCapacity] ?: 89,
            connector = prefs[Keys.connector] ?: "CCS2",
            batteryPercent = prefs[Keys.batteryPercent] ?: 64,
            consumptionWhPerKm = prefs[Keys.consumption] ?: 180,
            reservePercent = prefs[Keys.reserve] ?: 15,
            vehicleCatalogId = prefs[Keys.vehicleCatalogId] ?: "togg-t10x-long",
        )
    }

    suspend fun saveTheme(preset: String, darkMode: Boolean, accentHex: String) {
        store.edit { prefs ->
            prefs[Keys.themePreset] = preset
            prefs[Keys.darkMode] = darkMode
            prefs[Keys.accentHex] = accentHex
        }
    }

    suspend fun saveFavorites(favorites: Set<String>) {
        store.edit { it[Keys.favorites] = favorites }
    }

    suspend fun saveStationFilter(filter: String) {
        store.edit { it[Keys.stationFilter] = filter }
    }

    suspend fun saveConnectorFilter(filter: String?) {
        store.edit { it[Keys.connectorFilter] = filter.orEmpty() }
    }

    suspend fun saveStationSort(sort: String) {
        store.edit { it[Keys.stationSort] = sort }
    }

    suspend fun saveVehicle(settings: VoltaviaSettings) {
        store.edit { prefs ->
            prefs[Keys.vehicleName] = settings.vehicleName
            prefs[Keys.batteryCapacity] = settings.batteryCapacityKwh
            prefs[Keys.connector] = settings.connector
            prefs[Keys.batteryPercent] = settings.batteryPercent
            prefs[Keys.consumption] = settings.consumptionWhPerKm
            prefs[Keys.reserve] = settings.reservePercent
            prefs[Keys.vehicleCatalogId] = settings.vehicleCatalogId
        }
    }
}

internal const val voltaviaSettingsFileName = SETTINGS_FILE
