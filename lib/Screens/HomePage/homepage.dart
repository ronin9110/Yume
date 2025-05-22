import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yume/Utlities/Auth/googleauth.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/get_song_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/songs_provider_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/songs_list.dart';

import 'package:yume/Screens/HomePage/homepage_music_player.dart';

import 'package:yume/Screens/Music%20Player/music_player.dart';
import 'package:yume/Screens/playlist_page.dart';
import 'package:yume/Screens/profile_page.dart';
import 'package:yume/Screens/settings_page.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/online_playing_comp.dart'
    as opc;
import 'package:yume/Utlities/NetworkChecker.dart';
import 'package:yume/Utlities/global_variables.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/get_songs_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:yume/Utlities/global_variables.dart' as global;

class HomePage extends StatefulWidget {
  final SongHandler songHandler;
  const HomePage({super.key, required this.songHandler});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> playlists;
  bool loaded = false;
  final AutoScrollController _autoScrollController = AutoScrollController();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (global.newrel.isEmpty) {
      playlists = opc.OnlinePlayingComp().newReleases();
    } else {
      playlists = songsOncards();
    }
  }

  Future<Map<String, dynamic>> songsOncards() async {
    Map<String, dynamic> temp;

    temp = global.newrel;

    return temp;
  }

  void assign() async {
    global.newrel = await playlists;
  }

  bool clicked = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
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
        endDrawer: Drawer(
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
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProfilePage.routeName);
                  },
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          maxRadius: 45,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          Provider.of<UserProvider>(context).user.firstname,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, top: 15),
                //   child: ListTile(
                //     leading: Icon(
                //       Icons.settings,
                //       size: 35,
                //     ),
                //     title: GestureDetector(
                //       onTap: () {
                //         Navigator.pushNamed(context, SettingsPage.routeName);
                //       },
                //       child: Text(
                //         "Settings",
                //         style: TextStyle(
                //             fontSize: 20, fontWeight: FontWeight.w700),
                //       ),
                //     ),
                //   ),
                // ),
                // sideBarCard(
                //     Icons.bookmark, Wishlistpage.routeName, "Liked Songs"),
                sideBarCard(Icons.settings, SettingsPage.routeName, "Settings"),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Explore your \nFavroite Songs",
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () =>
                                    Scaffold.of(context).openEndDrawer(),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  maxRadius: 25,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, MusicPlayer.routeName),
                        child: HomepageMusicPlayer(
                          songHandler: widget.songHandler,
                          isLast: false,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                NetworkChecker(
                  child: Expanded(
                    child: FutureBuilder(
                      future: playlists,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          init();
                          return Expanded(
                              child: Center(
                                  child: const CircularProgressIndicator()));
                        }
                        assign();
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              height: 100,
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).colorScheme.primary),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Text(
                                      "New Releases",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontSize: 29,
                                          fontWeight: FontWeight.w800,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          width: 3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      onPressed: clicked
                                          ? () async {
                                              print(" fuck ${clicked}");
                                              setState(() {
                                                clicked = false;
                                                print(" fuck ${clicked}1");
                                              });
                                              await opc.OnlinePlayingComp()
                                                  .playOnlineSongs(
                                                      songHandler:
                                                          widget.songHandler,
                                                      tracks: snapshot
                                                          .data!['title']);
                                              widget.songHandler.play();
                                              widget.songHandler
                                                  .repeatMode(true);
                                            }
                                          : () => print(" fuck ${clicked}2"),
                                      iconSize: 32,
                                      icon: Icon(
                                        Icons.play_arrow_outlined,
                                      ),
                                      // shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  ListView.builder(
                                    controller: _autoScrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snapshot.data!['title'].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        // Set tile color based on whether the song is playing

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        // Handle tap on the ListTile
                                        onTap: () async {
                                          opc.OnlinePlayingComp.addqueue(
                                              title: snapshot.data!['title']
                                                  [index],
                                              songHandler: widget.songHandler);
                                        },
                                        // Build leading widget (artwork)
                                        leading: _buildLeading(
                                            snapshot.data!['image']![index]),
                                        // Build title and subtitle widgets
                                        title: Text(
                                          snapshot.data!['title'][index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        subtitle: Text(
                                            snapshot.data!['artist'][index]),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sideBarCard(IconData icon, String routename, String str) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: ListTile(
        leading: Icon(
          icon,
          size: 35,
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, routename);
          },
          child: Text(
            str,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
}
