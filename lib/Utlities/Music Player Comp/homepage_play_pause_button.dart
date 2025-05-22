import 'package:audio_service/audio_service.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:flutter/material.dart';

// PlayPauseButton class responsible for displaying a play/pause button
class HomepagePlayPauseButton extends StatefulWidget {
  // SongHandler instance to control playback
  final SongHandler songHandler;

  // Size of the button

  // Constructor to initialize the PlayPauseButton
  const HomepagePlayPauseButton({
    super.key,
    required this.songHandler,
  });

  @override
  State<HomepagePlayPauseButton> createState() =>
      _HomepagePlayPauseButtonState();
}

class _HomepagePlayPauseButtonState extends State<HomepagePlayPauseButton> {
  // Build method to create the widget
  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens to changes in the playback state
    return StreamBuilder<PlaybackState>(
      stream: widget.songHandler.playbackState.stream,
      builder: (context, snapshot) {
        // Check if there's data in the snapshot
        if (snapshot.hasData) {
          // Retrieve the playing status from the playback state
          bool playing = snapshot.data!.playing;
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.songHandler.skipToPrevious();
                },
                icon: const Icon(Icons.keyboard_double_arrow_left_outlined),
              ),
              IconButton(
                color: Theme.of(context).colorScheme.surface,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  if (playing) {
                    widget.songHandler.pause();
                  } else {
                    widget.songHandler.play();
                  }
                },
                icon: playing
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow_outlined),
              ),
              IconButton(
                onPressed: () {
                  widget.songHandler.skipToNext();
                },
                icon: const Icon(Icons.keyboard_double_arrow_right_outlined),
              ),
            ],
          );
        } else {
          //   // If there's no data in the snapshot, return an empty SizedBox
          return const SizedBox.shrink();
        }
      },
    );
  }
}
