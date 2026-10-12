package Com.sereng

import android.content.ContentUris
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sereng/local_music"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "getSongs") {
                try {
                    result.success(getSongs())
                } catch (e: Exception) {
                    result.error(
                        "MUSIC_QUERY_ERROR",
                        e.message,
                        null
                    )
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSongs(): List<Map<String, Any?>> {
        val songs = mutableListOf<Map<String, Any?>>()

        val collection =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStore.Audio.Media.getContentUri(
                    MediaStore.VOLUME_EXTERNAL
                )
            } else {
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            }

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.DURATION
        )

        contentResolver.query(
            collection,
            projection,
            null,
            null,
            "${MediaStore.Audio.Media.TITLE} ASC"
        )?.use { cursor ->

            val idIndex =
                cursor.getColumnIndexOrThrow(
                    MediaStore.Audio.Media._ID
                )

            val titleIndex =
                cursor.getColumnIndexOrThrow(
                    MediaStore.Audio.Media.TITLE
                )

            val artistIndex =
                cursor.getColumnIndexOrThrow(
                    MediaStore.Audio.Media.ARTIST
                )

            val durationIndex =
                cursor.getColumnIndexOrThrow(
                    MediaStore.Audio.Media.DURATION
                )

            while (cursor.moveToNext()) {
                val id = cursor.getLong(idIndex)

                val uri = ContentUris.withAppendedId(
                    collection,
                    id
                ).toString()

                songs.add(
                    mapOf(
                        "id" to id,
                        "title" to (
                            cursor.getString(titleIndex)
                                ?: "Unknown Title"
                        ),
                        "artist" to (
                            cursor.getString(artistIndex)
                                ?: "Unknown Artist"
                        ),
                        "duration" to cursor.getLong(durationIndex),
                        "uri" to uri
                    )
                )
            }
        }

        return songs
    }
}
