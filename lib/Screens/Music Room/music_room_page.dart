import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Screens/Music%20Room/create_room.dart';
import 'package:yume/Utlities/firestore_methods.dart';
import 'package:yume/Screens/Music%20Room/live_music_room.dart';
import 'package:yume/Screens/Music%20Room/musi_croom.dart';
import 'package:yume/Utlities/NetworkChecker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';

class LocalVoiceRoom extends StatefulWidget {
  final SongHandler songHandler;
  static const String routeName = '/voiceroom';
  const LocalVoiceRoom({super.key, required this.songHandler});

  @override
  State<LocalVoiceRoom> createState() => _LocalVoiceRoomState();
}

class _LocalVoiceRoomState extends State<LocalVoiceRoom> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Music Room",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 3,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5))
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: FloatingActionButton.extended(
                        onPressed: () =>
                            Navigator.pushNamed(context, CreateRoom.routeName),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        splashColor: Theme.of(context).colorScheme.primary,
                        icon: Icon(
                          Icons.add,
                          size: 20,
                          weight: 4,
                        ),
                        label: Text(
                          "Create Room",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                NetworkChecker(
                  child: SingleChildScrollView(
                    child: StreamBuilder<dynamic>(
                      stream: FirebaseFirestore.instance
                          .collection('VoiceRoom')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: size.height * 0.7,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.data.docs.length == 0) {
                          return SizedBox(
                            height: size.height * 0.7,
                            child: Center(
                              child: Text(
                                "No Voice Rooms! Create One",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            Voiceroom post = Voiceroom.fromMap(
                                snapshot.data.docs[index].data());
                            return GestureDetector(
                              onTap: () async {
                                await FirestoreMethods().updateviewCount(
                                    context, post.roomid, true);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LiveVoiceRoomCopy2(
                                        isbroadcaster: false,
                                        channelId: post.roomid,
                                        songHandler: widget.songHandler),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3.0),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text(
                                        "${post.username}'s Room",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Playing ${post.currentsongUrl}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                          ),
                                          Text(
                                            "${post.memebers}s Memebers",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                          ),
                                          Text(
                                            "Started ${timeago.format(post.startedAt.toDate())}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
}
