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

            when (call.method) {
                "getSongs" -> {
                    try {
                        result.success(getSongs())
                    } catch (e: Exception) {
                        result.error(
                            "MUSIC_QUERY_ERROR",
                            e.message ?: "Unable to query music",
                            null
                        )
                    }
                }

                else -> result.notImplemented()
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
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media.IS_MUSIC
        )

        // Include files marked as music and audio files
        // at least 60 seconds long.
        val selection =
            "(${MediaStore.Audio.Media.IS_MUSIC} != 0) OR " +
            "(${MediaStore.Audio.Media.DURATION} >= 60000)"

        val sortOrder =
            "${MediaStore.Audio.Media.TITLE} COLLATE NOCASE ASC"

        contentResolver.query(
            collection,
            projection,
            selection,
            null,
            sortOrder
        )?.use { cursor ->

            val idIndex = cursor.getColumnIndexOrThrow(
                MediaStore.Audio.Media._ID
            )

            val titleIndex = cursor.getColumnIndexOrThrow(
                MediaStore.Audio.Media.TITLE
            )

            val artistIndex = cursor.getColumnIndexOrThrow(
                MediaStore.Audio.Media.ARTIST
            )

            val albumIndex = cursor.getColumnIndexOrThrow(
                MediaStore.Audio.Media.ALBUM
            )

            val durationIndex = cursor.getColumnIndexOrThrow(
                MediaStore.Audio.Media.DURATION
            )

            val nameIndex = cursor.getColumnIndexOrThrow(
                MediaStore.Audio.Media.DISPLAY_NAME
            )

            while (cursor.moveToNext()) {
                val id = cursor.getLong(idIndex)

                val title =
                    cursor.getString(titleIndex)
                        ?.takeIf { it.isNotBlank() }
                        ?: cursor.getString(nameIndex)
                        ?: "Unknown Song"

                val artist =
                    cursor.getString(artistIndex)
                        ?.takeIf {
                            it.isNotBlank() && it != "<unknown>"
                        }
                        ?: "Unknown Artist"

                val album =
                    cursor.getString(albumIndex)
                        ?.takeIf { it.isNotBlank() }
                        ?: "Unknown Album"

                val duration =
                    cursor.getLong(durationIndex)

                val fileName =
                    cursor.getString(nameIndex) ?: title

                val uri = ContentUris.withAppendedId(
                    collection,
                    id
                ).toString()

                songs.add(
                    mapOf(
                        "id" to id,
                        "title" to title,
                        "artist" to artist,
                        "album" to album,
                        "duration" to duration,
                        "name" to fileName,
                        "uri" to uri
                    )
                )
            }
        }

        return songs
    }
}
