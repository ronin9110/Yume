// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' str;

import 'dart:async';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Screens/HomePage/homepage.dart';
import 'package:yume/Screens/local_songs_page.dart';
import 'package:yume/Screens/Music%20Room/music_room_page.dart';
import 'package:yume/Screens/search_page.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';

class MainNavBar extends StatefulWidget {
  static const String routeName = '/mainnav';
  final SongHandler songHandler;
  const MainNavBar({super.key, required this.songHandler});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  static int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Widget> screens = [
      HomePage(
        songHandler: widget.songHandler,
      ),
      SearchPage(
        songHandler: widget.songHandler,
      ),
      LocalStorageSongs(
        songHandler: widget.songHandler,
      ),
      LocalVoiceRoom(
        songHandler: widget.songHandler,
      )
    ];
    void ontap(i) {
      setState(() {
        selectedIndex = i;
      });
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.secondary
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        body: screens[selectedIndex],
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.2))
              ],
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.surface
                ],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.center,
              ),
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ),
            width: size.width / 1.1,
            height: size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bottomIcons(
                    fun: () {
                      ontap(0);
                    },
                    size: size,
                    str: "Home",
                    icon1: Icons.home_sharp,
                    sel: selectedIndex == 0 ? true : false),
                bottomIcons(
                    fun: () {
                      ontap(1);
                    },
                    size: size,
                    str: "Search",
                    icon1: Icons.search,
                    sel: selectedIndex == 1 ? true : false),
                bottomIcons(
                    fun: () {
                      ontap(2);
                    },
                    size: size,
                    icon1: Icons.storage_outlined,
                    str: "Local media",
                    sel: selectedIndex == 2 ? true : false),
                bottomIcons(
                    fun: () {
                      ontap(3);
                    },
                    size: size,
                    str: "Music Room",
                    icon1: Icons.voice_chat,
                    sel: selectedIndex == 3 ? true : false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomIcons(
      {required Size size,
      required IconData icon1,
      required bool sel,
      required Function fun,
      required String str}) {
    Color color1 = Theme.of(context).colorScheme.primary;
    Color color2 = Theme.of(context).colorScheme.inversePrimary;
    return GestureDetector(
      onTap: () {
        fun();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            color: sel ? color2 : color1,
            icon1,
            size: sel ? size.width * 0.10 : size.width * 0.10,
          ),
          sel
              ? Text(
                  str,
                  style: TextStyle(fontWeight: FontWeight.w800),
                )
              : Text(
                  str,
                )
        ],
      ),
    );
  }
}

Widget mainBackground({
  required BuildContext context,
  required Widget child,
  bool appbar = false,
}) {
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
    child: SafeArea(
      child: Scaffold(
        appBar: appbar
            ? AppBar(
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                backgroundColor: Colors.transparent,
              )
            : null,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: child,
      ),
    ),
  );
}
