package com.ferdidrgn.voltavia.kmp.feature.vehicle

/** Small, manually curated starter catalogue. Variant numbers stay editable in the profile. */
data class VehicleCatalogItem(
    val id: String,
    val brand: String,
    val model: String,
    val trim: String,
    val batteryCapacityKwh: Int,
    val wltpRangeKm: Int?,
    val connector: String = "CCS2",
    val sourceLabel: String,
    val sourceUrl: String,
) {
    val displayName: String get() = "$brand $model · $trim"
    val baselineConsumptionWhPerKm: Int
        get() = wltpRangeKm?.takeIf { it > 0 }?.let { (batteryCapacityKwh * 1000.0 / it).toInt() } ?: 180
}

object VehicleCatalog {
    val entries = listOf(
        VehicleCatalogItem("togg-t10x-standard", "Togg", "T10X", "V1 RWD Standart Menzil", 52, 314, sourceLabel = "Togg T10X", sourceUrl = "https://togg.com.tr/t10x"),
        VehicleCatalogItem("togg-t10x-long", "Togg", "T10X", "V1 RWD Uzun Menzil", 89, 523, sourceLabel = "Togg T10X", sourceUrl = "https://togg.com.tr/t10x"),
        VehicleCatalogItem("togg-t10f-standard", "Togg", "T10F", "RWD Standart Menzil", 52, 350, sourceLabel = "Togg T10F", sourceUrl = "https://togg.com.tr/t10f"),
        VehicleCatalogItem("togg-t10f-long", "Togg", "T10F", "RWD Uzun Menzil", 89, 623, sourceLabel = "Togg T10F", sourceUrl = "https://togg.com.tr/t10f"),
        VehicleCatalogItem("byd-dolphin-comfort", "BYD", "DOLPHIN", "Comfort", 60, 427, sourceLabel = "BYD Türkiye DOLPHIN", sourceUrl = "https://www.bydauto.com.tr/dolphin"),
        VehicleCatalogItem("byd-atto3-design", "BYD", "ATTO 3", "Design", 60, 420, sourceLabel = "BYD Türkiye ATTO 3", sourceUrl = "https://www.bydauto.com.tr/atto3"),
        VehicleCatalogItem("hyundai-ioniq5-84", "Hyundai", "IONIQ 5", "84 kWh 2WD", 84, 570, sourceLabel = "Hyundai Türkiye IONIQ 5", sourceUrl = "https://www.hyundai.com/tr/tr/modeller/ioniq5.html"),
        VehicleCatalogItem("hyundai-kona-654", "Hyundai", "KONA Elektrik", "65,4 kWh", 65, null, sourceLabel = "Hyundai Türkiye Elektrikli Modeller", sourceUrl = "https://www.hyundai.com/tr/tr/electrification/electrified-models/e-mobility.html"),
        VehicleCatalogItem("kia-ev3-standard", "Kia", "EV3", "Standard Range", 58, null, sourceLabel = "Kia Türkiye EV3", sourceUrl = "https://www.kia.com/tr/modeller/ev3/teknik-ozellikler.html"),
        VehicleCatalogItem("kia-ev3-long", "Kia", "EV3", "Long Range", 81, 604, sourceLabel = "Kia Türkiye EV3", sourceUrl = "https://www.kia.com/tr/modeller/ev3/teknik-ozellikler.html"),
    )

    fun find(id: String?): VehicleCatalogItem? = entries.firstOrNull { it.id == id }
}
