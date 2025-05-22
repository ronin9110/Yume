import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:spotify/spotify.dart' as spo;
import 'package:transparent_image/transparent_image.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/get_song_art_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/get_song_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/songs_provider_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/online_playing_comp.dart'
    as opc;
import 'package:yume/Screens/playlist_page.dart';
import 'package:yume/Utlities/NetworkChecker.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/uri_to_file.dart';
import 'package:yume/Utlities/global_variables.dart' as global;

class SearchPage extends StatefulWidget {
  static const String routeName = '/search';
  final SongHandler songHandler;
  const SearchPage({super.key, required this.songHandler});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String speechwords = "";
  TextEditingController searchcontroller = TextEditingController();
  final AutoScrollController autoScrollController = AutoScrollController();
  late Future<List<Map<String, dynamic>>> playlists;
  bool res = true;
  Map? titles = {"id": [], "title": [], "artist": [], "image": []};
  bool searched = false;
  bool searching = false;
  bool notsearched = true;
  @override
  void initState() {
    super.initState();
    if (global.cards.isEmpty) {
      playlists = opc.OnlinePlayingComp().featuredPlaylists();
    } else {
      playlists = songsOncards();
    }
    initspeech();
  }

  void initspeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListeing() async {
    setState(() {
      speechwords = "";
    });
    await _speechToText.listen(onResult: _onSpeechRes);
    setState(() {});
  }

  void _stopListenings() async {
    await _speechToText.stop();

    setState(() {});
  }

  void _onSpeechRes(res) {
    setState(() {
      speechwords = res.recognizedWords;
      searchcontroller.text = speechwords;
    });
  }

  Future<List<Map<String, dynamic>>> songsOncards() async {
    List<Map<String, dynamic>> temp;

    temp = global.cards;

    return temp;
  }

  void assign() async {
    global.cards = await playlists;
  }

  Future onsearch() async {
    final text = searchcontroller.text;
    setState(() {
      notsearched = false;
      searching = true;
    });
    final credentials = spo.SpotifyApiCredentials(
        '5243e7807dc0421a8efc2b2d0ddcb453', "978aa099b3d24ae49aa75d94df7ae23c");
    final spotify = spo.SpotifyApi(credentials);
    var search = await spotify.search.get(searchcontroller.text).first();

    for (var pages in search) {
      if (pages.items == null) {
        print('Empty items');
        setState(() {
          res = false;
        });
      }

      for (var item in pages.items!) {
        if (item is spo.PlaylistSimple) {
          print('Playlist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}:\n'
              'collaborative: ${item.collaborative}\n'
              'href: ${item.href}\n'
              'trackslink: ${item.tracksLink!.href}\n'
              'owner: ${item.owner}\n'
              'public: ${item.owner}\n'
              'snapshotId: ${item.snapshotId}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'images: ${item.images![0].url}}\n'
              '-------------------------------');
          setState(() {
            titles?['id'].add(item.id);
          });
        }
        if (item is spo.Artist) {
          print('Artist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'popularity: ${item.popularity}\n'
              '-------------------------------');
          setState(() {
            titles?['artist'].add(item.name);
          });
        }
        if (item is spo.Track) {
          print('Track:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'isPlayable: ${item.isPlayable}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'discNumber: ${item.discNumber}\n'
              'trackNumber: ${item.trackNumber}\n'
              'explicit: ${item.explicit}\n'
              'popularity: ${item.popularity}\n'
              '-------------------------------');
          setState(() {
            titles?['title'].add(item.name);
          });
        }
        if (item is spo.AlbumSimple) {
          print('Album:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'albumType: ${item.albumType}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'images: ${item.images!.length}\n'
              'releaseDate: ${item.releaseDate}\n'
              'releaseDatePrecision: ${item.releaseDatePrecision}\n'
              '-------------------------------');
          print(item.images![0].url);
          setState(() {
            titles?['image'].add(item.images![0].url);
          });
        }
      }
    }
    setState(() {
      searching = false;
      searched = true;
      searchcontroller.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return mainBackground(
      context: context,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                textAlign: TextAlign.start,
                "Search your \nFavroite Songs",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textInputField(
                    width: size.width * 0.0032,
                    size: size,
                    controller: searchcontroller,
                    inputType: TextInputType.text,
                    hintText: "Search for songs",
                    icon: Icons.search,
                    context: context,
                    onsub: () {
                      setState(() {
                        titles!['id'] = [];
                        titles!['title'] = [];
                        titles!['image'] = [];
                        titles!['artist'] = [];
                      });
                      onsearch();
                    },
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: IconButton.filledTonal(
                      onPressed: () {
                        _speechToText.isListening
                            ? _stopListenings()
                            : _startListeing();
                      },
                      icon: Icon(
                        Icons.mic,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              _speechToText.isListening
                  ? Container(
                      padding: EdgeInsets.all(20),
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.primary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Text(
                              "Listening...",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface,
                                  fontSize: 29,
                                  fontWeight: FontWeight.w800,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              NetworkChecker(
                child: Expanded(
                  child: Stack(
                    children: [
                      notsearched
                          ? FutureBuilder(
                              future: playlists,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Expanded(
                                      child: Center(
                                          child:
                                              const CircularProgressIndicator()));
                                }
                                assign();
                                return SingleChildScrollView(
                                  child: Column(
                                    children: snapshot.data!.map((data) {
                                      return Card(cards: data);
                                    }).toList(),
                                  ),
                                );
                              },
                            )
                          : searching
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : searched
                                  ? res
                                      ? ListView.builder(
                                          // Build a scrollable list of songs
                                          controller: autoScrollController,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: titles!['id'].length,
                                          itemBuilder: (context, index) {
                                            return StreamBuilder<MediaItem?>(
                                              stream: widget
                                                  .songHandler.mediaItem.stream,
                                              builder: (context, snapshot) {
                                                // Check if the current item is the last one
                                                return AutoScrollTag(
                                                  // Utilize AutoScrollTag for automatic scrolling
                                                  key: ValueKey(index),
                                                  controller:
                                                      autoScrollController,
                                                  index: index,
                                                  child: ListTile(
                                                    // Set tile color based on whether the song is playing

                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    // Handle tap on the ListTile
                                                    onTap: () async {
                                                      opc.OnlinePlayingComp
                                                          .addqueue(
                                                              title: titles?[
                                                                      'title']
                                                                  [index],
                                                              songHandler: widget
                                                                  .songHandler);
                                                    },
                                                    // Build leading widget (artwork)
                                                    leading: _buildLeading(
                                                        titles?['image']
                                                            [index]),
                                                    // Build title and subtitle widgets
                                                    title: Text(titles?['title']
                                                        [index]),
                                                    subtitle: Text(
                                                        titles?['artist']
                                                            [index]),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : Center(child: Text("No songs Found"))
                                  : Center(
                                      child: Text("data"),
                                    )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listeningWidget(Size size) {
    return Row(
      children: [
        SizedBox(
          height: size.height * 0.01,
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "title",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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

  Widget Card({required Map cards}) {
    return Column(
      children: [
        Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  cards['title'],
                  style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return PlaylistPage(
                        img: cards['img'],
                        title: cards['title'],
                        id: cards['id'],
                        songHandler: widget.songHandler,
                      );
                    }),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    "view all",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: cards['name']!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(right: 13, top: 10, bottom: 10),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(cards['image']![index])),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        opc.OnlinePlayingComp.addqueue(
                            title: cards['name']![index],
                            songHandler: widget.songHandler);
                      },
                      child: Flexible(
                        child: Container(
                          height: 50,
                          width: 150,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).colorScheme.primary),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cards['name']![index],
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  cards['artist']![index],
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
