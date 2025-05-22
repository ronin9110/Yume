import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Screens/HomePage/homepage_music_player.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Screens/Music%20Room/music_room_player.dart';
import 'package:yume/Screens/Music%20Room/music_room_player_main.dart';
import 'package:yume/Screens/Music%20Room/chat_widget.dart';
import 'package:yume/Utlities/firestore_methods.dart';
import 'package:yume/Screens/Music%20Room/music_room_page.dart';
import 'package:yume/Screens/Music%20Room/music_room_search_page.dart';
import 'package:yume/Screens/playlist_page.dart';
import 'package:yume/Screens/search_page.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/global_variables.dart' as global;
import 'package:yume/Utlities/Music%20Player%20Comp/online_playing_comp.dart'
    as opc;
import 'package:spotify/spotify.dart' as spo;

class LiveVoiceRoomCopy2 extends StatefulWidget {
  static const String routeName = '/livevoiceroom';
  final bool isbroadcaster;
  final String channelId;
  final SongHandler songHandler;
  const LiveVoiceRoomCopy2(
      {super.key,
      required this.isbroadcaster,
      required this.channelId,
      required this.songHandler});

  @override
  State<LiveVoiceRoomCopy2> createState() => _LiveVoiceRoomState();
}

class _LiveVoiceRoomState extends State<LiveVoiceRoomCopy2> {
  bool res = true;
  Map? titles = {"id": [], "title": [], "artist": [], "image": []};
  bool searched = false;
  bool searching = false;
  bool notsearched = true;
  _endVoiceRoom() async {
    if ('${Provider.of<UserProvider>(context, listen: false).user.uid}${Provider.of<UserProvider>(context, listen: false).user.firstname}' ==
        widget.channelId) {
      await FirestoreMethods().EndvoiceRoom(context, widget.channelId);
    } else {
      await FirestoreMethods()
          .updateviewCount(context, widget.channelId, false);
      widget.songHandler.pause();
    }
    Navigator.pushReplacementNamed(context, MainNavBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    TextEditingController searchcontroller = TextEditingController();
    final AutoScrollController autoScrollController = AutoScrollController();

    Future onsearch() async {
      setState(() {
        notsearched = false;
        searching = true;
      });
      final credentials = spo.SpotifyApiCredentials(
          '5243e7807dc0421a8efc2b2d0ddcb453',
          "978aa099b3d24ae49aa75d94df7ae23c");
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
      });
    }

    final user = Provider.of<UserProvider>(context).user;
    bool creator = "${user.uid}${user.firstname}" == widget.channelId;

    return WillPopScope(
      onWillPop: () async {
        await _endVoiceRoom();
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.secondary
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              creator
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, VoiceroomSearchPage.routeName);
                      },
                      icon: Icon(Icons.search))
                  : SizedBox.shrink()
            ],
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('VoiceRoom')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return !creator
                          ? VoiceRoomPlayer(
                              channelid: widget.channelId,
                              songHandler: widget.songHandler,
                              isLast: false,
                              onTap: () {},
                            )
                          : VoiceRoomPlayerMain(
                              channelid: widget.channelId,
                              songHandler: widget.songHandler,
                              isLast: false,
                              onTap: () {},
                            );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chat",
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.w800),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                width: size.width * 0.4,
                                child: styledButton(
                                  size,
                                  "Leave Room",
                                  context,
                                  () async {
                                    await _endVoiceRoom();
                                    return Future.value(true);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Chat(
                          channelId: widget.channelId,
                          songHandler: widget.songHandler,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
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
