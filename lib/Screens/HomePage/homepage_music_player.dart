import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:get/get.dart';
import 'package:overflow_text/overflow_text.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:text_marquee/text_marquee.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/homepage_play_pause_button.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomepageMusicPlayer extends StatefulWidget {
  final SongHandler songHandler;
  final Function onTap;
  final bool isLast;

  // Constructor for the PlayerDeck class
  const HomepageMusicPlayer({
    super.key,
    required this.songHandler,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<HomepageMusicPlayer> createState() => _HomepageMusicPlayerState();
}

class _HomepageMusicPlayerState extends State<HomepageMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Use StreamBuilder to reactively build UI based on changes to the mediaItem stream
    return StreamBuilder(
      stream: widget.songHandler.mediaItem.stream,
      builder: (context, snapshot) {
        MediaItem? playingSong = snapshot.data;
        // If there's no playing song, return an empty widget
        return playingSong == null
            ? const SizedBox.shrink()
            : _buildCard(context, playingSong);
      },
    );
  }

  // Build the main card widget
  Widget _buildCard(BuildContext context, MediaItem playingSong) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
        ),
        height: size.height * 0.17,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 9, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: size.width * 0.32,
                  width: size.width * 0.32,
                  child: DecoratedBox(
                    // Leading widget with a decorated box or artwork
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: QueryArtworkWidget(
                      id: int.parse(playingSong.displayDescription!),
                      type: ArtworkType.AUDIO,
                      size: 500,
                      quality: 100,
                      artworkBorder: BorderRadius.circular(8.0),
                      errorBuilder: (p0, p1, p2) =>
                          const Icon(Icons.music_note_rounded),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: size.width * 0.32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playingSong.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.primary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          playingSong.artist == null ? "" : playingSong.artist!,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ],
                    ),
                    HomepagePlayPauseButton(songHandler: widget.songHandler),
                    _buildContent(context, playingSong, size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the main content of the card
  Widget _buildContent(BuildContext context, MediaItem playingSong, Size size) {
    return _buildProgress(playingSong.duration!, size);
  }

  // Build the song progress section
  Widget _buildProgress(Duration totalDuration, Size size) {
    return SizedBox(
      width: size.width * 0.5,
      height: size.height * 0.02,
      child: widget.isLast
          ? null
          : StreamBuilder<Duration>(
              stream: AudioService.position,
              builder: (context, positionSnapshot) {
                // Retrieve the current position from the stream
                Duration? position = positionSnapshot.data;

                // Display the ProgressBar widget
                return ProgressBar(
                  // Set the progress to the current position or zero if null
                  progress: position ?? Duration.zero,
                  // Set the total duration of the song
                  total: totalDuration,
                  // Callback for seeking when the user interacts with the progress bar
                  onSeek: (position) {
                    widget.songHandler.seek(position);
                  },
                  // Customize the appearance of the progress bar
                  barHeight: 5,
                  thumbRadius: 5,
                  thumbColor: Theme.of(context).colorScheme.primary,
                  thumbGlowRadius: 5,
                  timeLabelLocation: TimeLabelLocation.above,
                  timeLabelPadding: 5,
                  baseBarColor: Theme.of(context).colorScheme.inversePrimary,
                  timeLabelTextStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inversePrimary),
                  progressBarColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
    );
  }
}
