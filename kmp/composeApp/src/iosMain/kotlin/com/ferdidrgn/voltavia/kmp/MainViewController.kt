package com.ferdidrgn.voltavia.kmp

import androidx.compose.ui.window.ComposeUIViewController
import com.ferdidrgn.voltavia.kmp.core.data.VoltaviaSettingsRepository
import com.ferdidrgn.voltavia.kmp.core.data.createVoltaviaSettingsStore

fun MainViewController() = ComposeUIViewController {
    VoltaviaApp(VoltaviaSettingsRepository(createVoltaviaSettingsStore()))
}
