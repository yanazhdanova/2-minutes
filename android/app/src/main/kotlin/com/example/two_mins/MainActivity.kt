package com.example.two_mins

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "two_mins/app_icon"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "setIcon" -> {
                    val icon = call.arguments as? String
                    setLauncherIcon(if (icon == "alt") "alt" else "main")
                    result.success(null)
                }
                "getIcon" -> result.success(currentLauncherIcon())
                else -> result.notImplemented()
            }
        }
    }

    private fun setLauncherIcon(icon: String) {
        val packageManager = packageManager
        val main = ComponentName(packageName, "$packageName.MainActivityMain")
        val alt = ComponentName(packageName, "$packageName.MainActivityAlt")
        val enabled = if (icon == "alt") alt else main
        val disabled = if (icon == "alt") main else alt

        packageManager.setComponentEnabledSetting(
            enabled,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
        packageManager.setComponentEnabledSetting(
            disabled,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }

    private fun currentLauncherIcon(): String {
        val alt = ComponentName(packageName, "$packageName.MainActivityAlt")
        val state = packageManager.getComponentEnabledSetting(alt)
        return if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) "alt" else "main"
    }
}
