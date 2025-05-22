import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/songs_list.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Local%20Storage/songs_provider.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Screens/HomePage/homepage_music_player.dart';
import 'package:yume/Screens/Music%20Player/music_player.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/global_variables.dart' as global;

class LocalStorageSongs extends StatefulWidget {
  final SongHandler songHandler;
  const LocalStorageSongs({super.key, required this.songHandler});

  @override
  State<LocalStorageSongs> createState() => _LocalStorageSongsState();
}

class _LocalStorageSongsState extends State<LocalStorageSongs> {
  final AutoScrollController _autoScrollController = AutoScrollController();
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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Local Songs",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w800),
                        )
                      ],
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
                GestureDetector(
                  onTap: () {
                    global.queue.clear();
                    global.localsongs = true;
                    widget.songHandler.initSongs(songs: global.songs);
                    widget.songHandler.play();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 80,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Play All",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.play_arrow_outlined,
                          size: 27,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<SongsProvider>(
                    builder: (context, songsProvider, child) {
                      return songsProvider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _buildSongsList(songsProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongsList(SongsProvider songsProvider) {
    return Stack(
      children: [
        SongsList(
          playlist: 'local',
          songHandler: widget.songHandler,
          songs: songsProvider.songs,
          autoScrollController: _autoScrollController,
        ),
      ],
    );
  }
}
