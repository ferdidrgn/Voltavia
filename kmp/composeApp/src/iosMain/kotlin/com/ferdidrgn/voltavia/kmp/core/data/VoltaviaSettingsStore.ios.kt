package com.ferdidrgn.voltavia.kmp.core.data

import androidx.datastore.core.DataStore
import androidx.datastore.core.okio.OkioStorage
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.PreferencesSerializer
import kotlinx.cinterop.ExperimentalForeignApi
import okio.FileSystem
import okio.Path.Companion.toPath
import platform.Foundation.NSDocumentDirectory
import platform.Foundation.NSFileManager
import platform.Foundation.NSUserDomainMask

private var settingsDataStore: DataStore<Preferences>? = null

@OptIn(ExperimentalForeignApi::class)
actual fun createVoltaviaSettingsStore(platformContext: Any?): DataStore<Preferences> {
    settingsDataStore?.let { return it }
    return createSettingsStore(
        OkioStorage(
            fileSystem = FileSystem.SYSTEM,
            serializer = PreferencesSerializer,
            producePath = {
                val documents = NSFileManager.defaultManager.URLForDirectory(
                    directory = NSDocumentDirectory,
                    inDomain = NSUserDomainMask,
                    appropriateForURL = null,
                    create = true,
                    error = null,
                )?.path ?: error("Could not resolve the iOS documents directory.")
                "$documents/$voltaviaSettingsFileName".toPath()
            },
        ),
    ).also { settingsDataStore = it }
}
