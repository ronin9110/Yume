import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_item.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/formatted_title.dart';
import 'package:yume/Utlities/global_variables.dart' as global;

// SongsList class to display a list of songs
class SongsList extends StatelessWidget {
  final List<MediaItem> songs;
  final SongHandler songHandler;
  final String playlist;
  final AutoScrollController autoScrollController;

  // Constructor for the SongsList class
  const SongsList({
    super.key,
    required this.songs,
    required this.songHandler,
    required this.autoScrollController,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    // Display a message if there are no songs
    return songs.isEmpty
        ? const Center(
            child: Text("No Songs Found!"),
          )
        : ListView.builder(
            // Build a scrollable list of songs
            controller: autoScrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              MediaItem song = songs[index];

              // Build the SongItem based on the playback state
              return StreamBuilder<MediaItem?>(
                stream: songHandler.mediaItem.stream,
                builder: (context, snapshot) {
                  MediaItem? playingSong = snapshot.data;

                  // Check if the current item is the last one
                  return AutoScrollTag(
                    // Utilize AutoScrollTag for automatic scrolling
                    key: ValueKey(index),
                    controller: autoScrollController,
                    index: index,
                    child: _buildRegularSongItem(context, song, playingSong),
                  );
                },
              );
            },
          );
  }

  // Build a regular song item
  Widget _buildRegularSongItem(
      BuildContext context, MediaItem song, MediaItem? playingSong) {
    return SongItem(
      id: int.parse(song.displayDescription!),
      isPlaying: song == playingSong,
      title: formattedTitle(song.title),
      artist: song.artist,
      onSongTap: () async {
        await songHandler.skipToQueueItem(global.songs.indexOf(song));
      },
      art: song.artUri,
    );
  }
}
