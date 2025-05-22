import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/firestore_methods.dart';

class Chat extends StatefulWidget {
  final String channelId;
  final SongHandler songHandler;
  const Chat({super.key, required this.channelId, required this.songHandler});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.primary, width: 3),
    );
    final userproivder = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          Container(
            height: size.height / 2.3,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 3.0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('VoiceRoom')
                  .doc(widget.channelId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      snapshot.data.docs[index]['firstname'],
                      style: TextStyle(
                          color: snapshot.data.docs[index]['firstname'] ==
                                  userproivder.user.firstname
                              ? Colors.blue
                              : Colors.black),
                    ),
                    subtitle: Text(
                      snapshot.data.docs[index]['message'],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            height: size.height / 13,
            child: TextField(
              onSubmitted: (str) {
                FirestoreMethods()
                    .Chat(textController.text, widget.channelId, context);
                setState(() {
                  textController.text = "";
                });
              },
              controller: textController,
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.inversePrimary,
                fontFamily: 'Circular book',
              ),
              maxLines: 1,
              keyboardType: TextInputType.text,
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(23),
                  prefixIcon: Icon(
                    Icons.chat_outlined,
                    size: 23,
                  ),
                  hintText: "Type Something",
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.6),
                    height: 1.0,
                    fontWeight: FontWeight.w100,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  focusedBorder: textBorder,
                  enabledBorder: textBorder,
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
