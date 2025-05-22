import 'package:audio_service/audio_service.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/get_songs.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:yume/Utlities/global_variables.dart' as global;

// Define a class for managing songs using ChangeNotifier
class SongsProvider extends ChangeNotifier {
  // Private variable to store the list of songs
  List<MediaItem> _songs = [];

  // Getter for accessing the list of songs
  List<MediaItem> get songs => _songs;

  // Private variable to track the loading state
  bool _isLoading = true;

  // Getter for accessing the loading state
  bool get isLoading => _isLoading;
  // Asynchronous method to load songs
  Future<void> loadSongs(SongHandler songHandler, String playlist) async {
    try {
      // if (global.songs.isNotEmpty) {
      //   global.songs.clear();
      // }
      _songs = await getSongs();

      global.songs.addAll(_songs);
      // _songs = await getSongsYT();

      // Initialize the song handler with the loaded songs
      await songHandler.initSongs(songs: global.songs);

      // Update the loading state to indicate completion
      _isLoading = false;

      // Notify listeners about the changes in the state
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the process
      debugPrint('Error loading songs: $e');
      // You might want to set _isLoading to false here as well, depending on your use case
    }
  }
}
