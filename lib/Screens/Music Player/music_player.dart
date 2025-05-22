import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Screens/Music%20Player/songs_queue.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/play_pause_button.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_progress.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayer extends StatefulWidget {
  static const String routeName = '/musicplayer';
  final SongHandler songHandler;
  final Function onTap;
  final bool isLast;
  final String playlist;

  // Constructor for the PlayerDeck class
  const MusicPlayer({
    super.key,
    required this.songHandler,
    required this.isLast,
    required this.onTap,
    required this.playlist,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to reactively build UI based on changes to the mediaItem stream
    return StreamBuilder<MediaItem?>(
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_outlined),
                          iconSize: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongsQueue(
                                  playlist: widget.playlist,
                                  songHandler: widget.songHandler,
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.menu_outlined,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.016,
                  ),
                  NeoBox(
                    widget: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: size.width / 1.1,
                            width: size.width / 1.1,
                            child: DecoratedBox(
                              // Leading widget with a decorated box or artwork
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: widget.isLast
                                    ? Colors.transparent
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.13,
                  ),
                  PlayPauseButton(size: size, songHandler: widget.songHandler),
                ],
              ),
              Align(
                alignment: const Alignment(0, 0.38),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    height: 140,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildContent(context, playingSong),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.isLast ? "" : "${playingSong.title},",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                playingSong.artist == null
                                    ? ""
                                    : playingSong.artist!,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the main content of the card
  Widget _buildContent(BuildContext context, MediaItem playingSong) {
    return _buildProgress(playingSong.duration!);
  }

  // Build the trailing widget with song progress and play/pause button
  Widget _buildTrailingWidget(BuildContext context, MediaItem playingSong) {
    return Stack(
      children: [
        StreamBuilder<Duration>(
          stream: AudioService.position,
          builder: (context, durationSnapshot) {
            if (durationSnapshot.hasData) {
              // Calculate and display song progress
              double progress = durationSnapshot.data!.inMilliseconds /
                  playingSong.duration!.inMilliseconds;
              return Center(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3,
                  backgroundColor: widget.isLast
                      ? Colors.transparent
                      : Theme.of(context).hoverColor,
                  value: progress,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // Build the song progress section
  Widget _buildProgress(Duration totalDuration) {
    return ListTile(
      title: widget.isLast
          ? null
          : SongProgress(
              // Use SongProgress widget to display progress bar
              totalDuration: totalDuration,
              songHandler: widget.songHandler),
    );
  }

  Widget homepageMusicPlayer(Size size, MediaItem playingSong) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
        ),
        height: size.height * 0.2,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: size.width / 1.1,
                width: size.width / 1.1,
                child: DecoratedBox(
                  // Leading widget with a decorated box or artwork
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
          ],
        ),
      ),
    );
  }
}
