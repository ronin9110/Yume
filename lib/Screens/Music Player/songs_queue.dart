import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Local%20Storage/songs_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_item.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/formatted_title.dart';
import 'package:yume/Utlities/global_variables.dart' as global;
import 'package:yume/Utlities/Music%20Player%20Comp/online_playing_comp.dart'
    as opc;

class SongsQueue extends StatefulWidget {
  final SongHandler songHandler;
  final String playlist;
  const SongsQueue(
      {super.key, required this.songHandler, required this.playlist});

  @override
  State<SongsQueue> createState() => _SongsQueueState();
}

class _SongsQueueState extends State<SongsQueue> {
  final AutoScrollController _autoScrollController = AutoScrollController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<SongsProvider>(
      builder: (context, songsProvider, child) {
        return SafeArea(
          child: Scaffold(
            body: songsProvider.isLoading
                ? _buildLoadingIndicator() // Display a loading indicator while songs are loading
                : Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.09,
                        child: Container(
                          decoration: BoxDecoration(
                            backgroundBlendMode: BlendMode.color,
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.27,
                                ),
                                Text(
                                  "Queue",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                                // PopupMenuButton(
                                //   child: Icon(Icons.more_vert_rounded),
                                //   itemBuilder: (context) => [
                                //     PopupMenuItem(
                                //       onTap: () {
                                //         widget.songHandler.queue.value.clear();
                                //         setState(() {});
                                //       },
                                //       child:
                                //           Text("Clear queue"), // menu setting
                                //       value: 1,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: global.localsongs
                              ? _buildSongsList(songsProvider)
                              : songsList()),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSongsList(SongsProvider songsProvider) {
    var songs = widget.songHandler.queue.value;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Stack(
        children: [
          songs.isEmpty
              ? const Center(
                  child: Text("No Songs Found!"),
                )
              : ListView.builder(
                  // Build a scrollable list of songs
                  controller: _autoScrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    MediaItem song = songs[index];

                    // Build the SongItem based on the playback state
                    return StreamBuilder<MediaItem?>(
                      stream: widget.songHandler.mediaItem.stream,
                      builder: (context, snapshot) {
                        MediaItem? playingSong = snapshot.data;

                        // Check if the current item is the last one
                        return AutoScrollTag(
                          // Utilize AutoScrollTag for automatic scrolling
                          key: ValueKey(index),
                          controller: _autoScrollController,
                          index: index,
                          child:
                              _buildRegularSongItem(context, song, playingSong),
                        );
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildRegularSongItem(
      BuildContext context, MediaItem song, MediaItem? playingSong) {
    return SongItem(
      id: int.parse(song.displayDescription!),
      isPlaying: song == playingSong,
      title: formattedTitle(song.title),
      artist: song.artist,
      onSongTap: () async {
        await widget.songHandler
            .skipToQueueItem(widget.songHandler.queue.value.indexOf(song));
      },
      art: song.artUri,
    );
  }

  Widget songsList() {
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            controller: _autoScrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: global.queue['title'].length,
            itemBuilder: (context, index) {
              return ListTile(
                // Set tile color based on whether the song is playing

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                // Handle tap on the ListTile
                onTap: () async {
                  opc.OnlinePlayingComp.addqueue(
                      title: global.queue['title'][index],
                      songHandler: widget.songHandler);
                },
                // Build leading widget (artwork)
                leading: _buildLeading(global.queue['image']![index]),
                // Build title and subtitle widgets
                title: Text(
                  global.queue['title'][index],
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
                subtitle: Text(global.queue['artist'][index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(String img) {
    Future<ImageProvider> getImage() async {
      return NetworkImage(img.toString());
    }

    return FutureBuilder<ImageProvider?>(
      // Use the uriToFile function to convert Uri to File
      future: getImage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Handle error, e.g., show a placeholder or log the error
          return const Icon(Icons.error_outline);
        }

        return Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          child: snapshot.data == null
              ? const Icon(Icons.music_note_rounded)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage(
                    height: 45,
                    width: 45,
                    image: snapshot.data!,
                    placeholder: MemoryImage(kTransparentImage),
                    fadeInDuration: const Duration(milliseconds: 700),
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }
}
