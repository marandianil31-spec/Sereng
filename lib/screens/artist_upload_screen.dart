Future<void> submitSong() async {
  final artist = artistController.text.trim();
  final song = songController.text.trim();
  final album = albumController.text.trim();
  final description = descriptionController.text.trim();

  if (artist.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Artist name enter kijiye.'),
      ),
    );
    return;
  }

  if (song.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Song title enter kijiye.'),
      ),
    );
    return;
  }

  if (coverImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cover image select kijiye.'),
      ),
    );
    return;
  }

  if (audioFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio file select kijiye.'),
      ),
    );
    return;
  }

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please login karke dobara try kijiye.',
        ),
      ),
    );
    return;
  }

  setState(() {
    isSubmitting = true;
  });

  try {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final basePath =
        'artists/${user.uid}/songs/$timestamp';

    // -----------------------------
    // COVER IMAGE UPLOAD
    // -----------------------------
    final coverRef = FirebaseStorage.instance
        .ref()
        .child('$basePath/cover');

    await coverRef.putFile(coverImage!);

    final coverUrl =
        await coverRef.getDownloadURL();

    // -----------------------------
    // AUDIO FILE UPLOAD
    // -----------------------------
    final audioRef = FirebaseStorage.instance
        .ref()
        .child('$basePath/audio');

    await audioRef.putFile(audioFile!);

    final audioUrl =
        await audioRef.getDownloadURL();

    // -----------------------------
    // FIRESTORE SONG DATA
    // -----------------------------
    await FirebaseFirestore.instance
        .collection('songs')
        .add({
      'artistName': artist,
      'songTitle': song,
      'albumName': album,
      'genre': selectedGenre,
      'description': description,
      'coverUrl': coverUrl,
      'audioUrl': audioUrl,
      'artistUid': user.uid,
      'artistEmail': user.email,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Song successfully submitted for approval.',
        ),
      ),
    );

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Upload failed: $e',
        ),
      ),
    );
  }
}
