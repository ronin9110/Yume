import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Screens/HomePage/homepage_music_player.dart';
import 'package:yume/Utlities/firestore_methods.dart';
import 'package:yume/Screens/Music%20Room/live_music_room.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/NetworkChecker.dart';

class CreateRoom extends StatefulWidget {
  static const String routeName = '/createroom';
  final SongHandler songHandler;
  const CreateRoom({super.key, required this.songHandler});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    final size = MediaQuery.of(context).size;

    createVoiceRoom() async {
      try {
        String roomid = await FirestoreMethods()
            .startVoiceRoom(context, textController.text, widget.songHandler);
        if (roomid.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LiveVoiceRoomCopy2(
                    isbroadcaster: true,
                    channelId: roomid,
                    songHandler: widget.songHandler,
                  )));
        }
      } on FirebaseException catch (e) {
        worngCred(e.message!, context);
      }
    }

    return Container(
      // padding: EdgeInsets.only(right: 20),
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
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: NetworkChecker(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Music Room",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
                HomepageMusicPlayer(
                  songHandler: widget.songHandler,
                  isLast: false,
                  onTap: () {},
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                textInputField(
                    size: size,
                    controller: textController,
                    inputType: TextInputType.text,
                    hintText: "Enter Title",
                    icon: Icons.title,
                    context: context),
                SizedBox(
                  height: size.height * 0.01,
                ),
                styledButton(size, "Create Room", context, createVoiceRoom)
              ],
            ),
          ),
        )),
      ),
    );
  }
}
