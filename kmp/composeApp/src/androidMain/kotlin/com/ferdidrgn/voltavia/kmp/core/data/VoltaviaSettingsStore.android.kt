package com.ferdidrgn.voltavia.kmp.core.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.core.FileStorage
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.PreferencesSerializer

private var settingsDataStore: DataStore<Preferences>? = null

actual fun createVoltaviaSettingsStore(platformContext: Any?): DataStore<Preferences> {
    settingsDataStore?.let { return it }
    val context = requireNotNull(platformContext as? Context) { "Android Context is required for Voltavia DataStore." }
    return createSettingsStore(
        FileStorage(
            serializer = PreferencesSerializer,
            produceFile = { context.filesDir.resolve(voltaviaSettingsFileName) },
        ),
    ).also { settingsDataStore = it }
}
