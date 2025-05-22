import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:flutter/material.dart';

// PlayPauseButton class responsible for displaying a play/pause button
class PlayPauseButton extends StatefulWidget {
  // SongHandler instance to control playback
  final SongHandler songHandler;

  // Size of the button
  final Size size;

  // Constructor to initialize the PlayPauseButton
  const PlayPauseButton({
    super.key,
    required this.size,
    required this.songHandler,
  });

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  // Build method to create the widget
  @override
  Widget build(BuildContext context) {
    bool shuff = widget.songHandler.audioPlayer.shuffleModeEnabled;
    LoopMode repMode = widget.songHandler.audioPlayer.loopMode;
    final repList = [LoopMode.off, LoopMode.all, LoopMode.one];
    int repIndex = repList.indexOf(repMode);

    void toggleshuff() {
      setState(() {
        shuff = !shuff;
      });
    }

    void togglerep() {
      setState(
        () {
          if (repIndex == 2) {
            repIndex = 0;
          } else {
            repIndex++;
          }
        },
      );
    }

    // StreamBuilder listens to changes in the playback state
    return StreamBuilder<PlaybackState>(
      stream: widget.songHandler.playbackState.stream,
      builder: (context, snapshot) {
        // Check if there's data in the snapshot
        if (snapshot.hasData) {
          // Retrieve the playing status from the playback state
          bool playing = snapshot.data!.playing;
          return SizedBox(
            height: 130,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, 0.1),
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            toggleshuff();
                            widget.songHandler.shuffleQueue(shuff);
                          },
                          child: !shuff
                              ? const Icon(
                                  Icons.shuffle_outlined,
                                  size: 40,
                                )
                              : Icon(
                                  Icons.shuffle_outlined,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.songHandler.skipToPrevious();
                          },
                          child: const Icon(
                            Icons.keyboard_double_arrow_left_outlined,
                            size: 45,
                          ),
                        ),
                        const SizedBox(width: 90),
                        GestureDetector(
                          onTap: () {
                            widget.songHandler.skipToNext();
                          },
                          child: const Icon(
                            Icons.keyboard_double_arrow_right_outlined,
                            size: 45,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglerep();
                            widget.songHandler.repeatMode(repList[repIndex]);
                          },
                          child: repIndex == 0
                              ? const Icon(
                                  Icons.repeat,
                                  size: 40,
                                )
                              : Icon(
                                  repIndex == 1
                                      ? Icons.repeat
                                      : Icons.repeat_one_outlined,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.3),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 55,
                    child: GestureDetector(
                      onTap: () {
                        // Toggle play/pause based on the current playing status
                        if (playing) {
                          widget.songHandler.pause();
                        } else {
                          widget.songHandler.play();
                        }
                      },
                      child: playing
                          ? const Icon(Icons.pause, size: 50)
                          : const Icon(Icons.play_arrow_outlined, size: 50),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          //   // If there's no data in the snapshot, return an empty SizedBox
          return const SizedBox.shrink();
        }
      },
    );
  }
}
