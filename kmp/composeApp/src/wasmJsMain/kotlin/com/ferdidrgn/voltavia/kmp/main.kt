package com.ferdidrgn.voltavia.kmp

import androidx.compose.ui.window.ComposeViewport
import com.ferdidrgn.voltavia.kmp.core.data.VoltaviaSettingsRepository
import com.ferdidrgn.voltavia.kmp.core.data.createVoltaviaSettingsStore
import kotlinx.browser.document

fun main() {
    ComposeViewport(document.body!!) {
        VoltaviaApp(VoltaviaSettingsRepository(createVoltaviaSettingsStore()))
    }
}
