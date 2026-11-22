package com.ferdidrgn.voltavia.kmp.core.data

import androidx.datastore.core.DataStore
import androidx.datastore.core.okio.WebLocalStorage
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.PreferencesSerializer

private var settingsDataStore: DataStore<Preferences>? = null

actual fun createVoltaviaSettingsStore(platformContext: Any?): DataStore<Preferences> {
    settingsDataStore?.let { return it }
    return createSettingsStore(
        WebLocalStorage(
            serializer = PreferencesSerializer,
            name = voltaviaSettingsFileName,
        ),
    ).also { settingsDataStore = it }
}
