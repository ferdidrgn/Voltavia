package com.ferdidrgn.voltavia.kmp

import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import android.os.Bundle
import com.ferdidrgn.voltavia.kmp.core.data.createVoltaviaSettingsStore
import com.ferdidrgn.voltavia.kmp.core.data.VoltaviaSettingsRepository

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val settingsRepository = VoltaviaSettingsRepository(createVoltaviaSettingsStore(applicationContext))
        setContent { VoltaviaApp(settingsRepository) }
    }
}
