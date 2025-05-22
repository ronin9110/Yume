import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/online_playing_comp.dart'
    as opc;

class PlaylistPage extends StatefulWidget {
  final String id;
  final String title;
  final String img;
  final SongHandler songHandler;
  Map<String, dynamic>? tracks;
  PlaylistPage({
    super.key,
    required this.id,
    required this.songHandler,
    required this.title,
    required this.img,
    Map<String, dynamic>? tracks,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<Map<String, dynamic>> title;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    if (widget.id == "") {
      title = opc.OnlinePlayingComp().newReleases();
    } else {
      title = opc.OnlinePlayingComp().fetchPlaylistTracks(widget.id);
    }
  }

  final AutoScrollController autoScrollController = AutoScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return mainBackground(
      appbar: true,
      context: context,
      child: FutureBuilder(
        future: title,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
                child: Center(child: const CircularProgressIndicator()));
          }
          var titles = snapshot.data!;
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: widget.img == "" ? 0 : size.height * 0.45,
                      width: size.width,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: widget.img == ""
                            ? null
                            : Image.network(
                                fit: BoxFit.fill,
                                widget.img,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, 0),
                            child: FloatingActionButton(
                              onPressed: () async {
                                await opc.OnlinePlayingComp().playOnlineSongs(
                                    songHandler: widget.songHandler,
                                    tracks: titles['title']!);
                                widget.songHandler.play();
                              },
                              child: Icon(
                                Icons.play_arrow_outlined,
                                size: 27,
                              ),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: autoScrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: titles['title']!.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<MediaItem?>(
                            stream: widget.songHandler.mediaItem.stream,
                            builder: (context, snapshot) {
                              // Check if the current item is the last one
                              return AutoScrollTag(
                                // Utilize AutoScrollTag for automatic scrolling
                                key: ValueKey(index),
                                controller: autoScrollController,
                                index: index,
                                child: ListTile(
                                  // Set tile color based on whether the song is playing

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  // Handle tap on the ListTile
                                  onTap: () async {
                                    opc.OnlinePlayingComp.addqueue(
                                        title: titles['title']![index],
                                        songHandler: widget.songHandler);
                                  },
                                  // Build leading widget (artwork)
                                  leading:
                                      _buildLeading(titles['image']![index]),
                                  // Build title and subtitle widgets
                                  title: Text(titles['title']![index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis)),
                                  subtitle: Text(titles['artist']![index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
