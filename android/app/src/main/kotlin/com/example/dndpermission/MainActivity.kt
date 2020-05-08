package com.example.dndpermission

import android.content.ContentResolver
import android.content.Context
import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private fun resourceToUriString(context: Context, resId: Int): String? {
        return (ContentResolver.SCHEME_ANDROID_RESOURCE
                + "://"
                + context.resources.getResourcePackageName(resId)
                + "/"
                + context.resources.getResourceTypeName(resId)
                + "/"
                + context.resources.getResourceEntryName(resId))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, "crossingthestreams.io/resourceResolver").setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if ("getServiceData" == call.method) {
                var data="This is service data"
                result.success(data)
            }
            if ("getNotificationUri" == call.method) {
                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION).toString())
            }
        }
    }
}
