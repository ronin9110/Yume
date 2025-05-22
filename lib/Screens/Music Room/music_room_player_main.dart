import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:overflow_text/overflow_text.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/homepage_play_pause_button.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:yume/Screens/Music%20Room/music_room_player.dart';

class VoiceRoomPlayerMain extends StatefulWidget {
  final SongHandler songHandler;
  final Function onTap;
  final bool isLast;
  final String channelid;

  // Constructor for the PlayerDeck class
  const VoiceRoomPlayerMain({
    super.key,
    required this.songHandler,
    required this.isLast,
    required this.onTap,
    required this.channelid,
  });

  @override
  State<VoiceRoomPlayerMain> createState() => _HomepageMusicPlayerState();
}

class _HomepageMusicPlayerState extends State<VoiceRoomPlayerMain> {
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to reactively build UI based on changes to the mediaItem stream
    return StreamBuilder(
      stream: widget.songHandler.mediaItem.stream,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("VoiceRoom")
              .doc(widget.channelid)
              .snapshots(),
          builder: (context, snapshot1) {
            FirebaseFirestore.instance
                .collection("VoiceRoom")
                .doc(widget.channelid)
                .update({
              'currentsongUrl': snapshot.data?.title.toString(),
            });
            MediaItem? playingSong = snapshot.data;
            // If there's no playing song, return an empty widget
            return playingSong == null
                ? const SizedBox.shrink()
                : _buildCard(context, playingSong);
          },
        );
      },
    );
  }

  onplaypause(play, pause, pos) {
    FirebaseFirestore.instance
        .collection("VoiceRoom")
        .doc(widget.channelid)
        .update({'pause': pause, 'play': play, 'pos': pos});
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
                      // Artwork for the leading box
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
                              overflow: TextOverflow.ellipsis),
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
                    player(widget.songHandler),
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

  Widget player(SongHandler songHandler) {
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
                  FirebaseFirestore.instance
                      .collection("VoiceRoom")
                      .doc(widget.channelid)
                      .update({
                    'currentsongUrl': songHandler.queueTitle.toString(),
                    // 'pos': Duration.zero.toString(),
                    'play': songHandler.audioPlayer.playing ? '1' : '0',
                    'pause': songHandler.audioPlayer.playing ? '0' : '1'
                  });
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
                    onplaypause("0", "1",
                        widget.songHandler.audioPlayer.position.toString());
                    widget.songHandler.pause();
                  } else {
                    onplaypause("1", "0",
                        widget.songHandler.audioPlayer.position.toString());
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
