package com.example.pump_gym

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pump_gym/pdf_download")
            .setMethodCallHandler { call, result ->
                if (call.method != "downloadPdf") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val bytes = call.argument<ByteArray>("bytes")
                val fileName = call.argument<String>("fileName")
                if (bytes == null || fileName == null) {
                    result.error("INVALID_ARGUMENT", "PDF data or filename is missing", null)
                    return@setMethodCallHandler
                }

                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                    result.error(
                        "UNSUPPORTED_ANDROID_VERSION",
                        "Direct Downloads-folder saving requires Android 10 or later.",
                        null
                    )
                    return@setMethodCallHandler
                }

                try {
                    val values = ContentValues().apply {
                        put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                        put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                        put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                        put(MediaStore.Downloads.IS_PENDING, 1)
                    }
                    val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                        ?: throw IllegalStateException("Could not create PDF in Downloads")
                    contentResolver.openOutputStream(uri).use { output ->
                        checkNotNull(output) { "Could not open PDF output stream" }.write(bytes)
                    }
                    values.clear()
                    values.put(MediaStore.Downloads.IS_PENDING, 0)
                    contentResolver.update(uri, values, null, null)
                    result.success(true)
                } catch (error: Exception) {
                    result.error("DOWNLOAD_FAILED", error.message, null)
                }
            }
    }
}
