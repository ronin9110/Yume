import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Screens/Music%20Room/musi_croom.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final StorageMethods _storageMethods = StorageMethods();
  Future<String> startVoiceRoom(
      BuildContext context, String title, SongHandler songHandler) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String roomid = '';
    String currentsongUrl = '';
    Duration pos = const Duration(microseconds: 0);
    try {
      if (title.isEmpty) {
        worngCred("Please Enter Title", context);
      } else {
        if (!((await _firestore
                .collection('VoiceRoom')
                .doc('${user.user.uid}${user.user.firstname}')
                .get()))
            .exists) {
          // print("sucker ${songHandler.audioPlayer.position}");snapshot.data
          songHandler.mediaItem.stream.listen((data) {
            currentsongUrl = data!.id;
            pos = songHandler.audioPlayer.position;
            print("sucker${data.id}");
          });
          roomid = '${user.user.uid}${user.user.firstname}';
          Voiceroom voiceroom = Voiceroom(
              pause: songHandler.audioPlayer.playing ? '1' : '0',
              play: songHandler.audioPlayer.playing ? '0' : '1',
              currentsongUrl: currentsongUrl,
              pos: songHandler.audioPlayer.position.toString(),
              title: title,
              // image: url,
              uid: user.user.uid,
              username: user.user.firstname,
              memebers: 0,
              roomid: roomid,
              startedAt: DateTime.now());
          _firestore.collection('VoiceRoom').doc(roomid).set(voiceroom.toMap());
        } else {
          worngCred(
              "Multiple Live Treams cannot start at the same Time!", context);
        }
      }
    } on FirebaseException catch (e) {
      worngCred(e.message!, context);
    }
    return roomid;
  }

  Future<void> EndvoiceRoom(BuildContext context, String channelid) async {
    try {
      QuerySnapshot snap = await _firestore
          .collection('VoiceRoom')
          .doc(channelid)
          .collection('comments')
          .get();
      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('VoiceRoom')
            .doc(channelid)
            .collection('comments')
            .doc((snap.docs[i].data()! as dynamic)['commentid'])
            .delete();
      }
      await _firestore.collection('VoiceRoom').doc(channelid).delete();
    } catch (e) {
      worngCred(e.toString(), context);
    }
  }

  Future<void> updateviewCount(
      BuildContext context, String id, bool isincre) async {
    try {
      await _firestore
          .collection('VoiceRoom')
          .doc(id)
          .update({'memebers': FieldValue.increment(isincre ? 1 : -1)});
    } catch (e) {
      worngCred(e.toString(), context);
    }
  }

  Future<void> Chat(String text, String id, BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    try {
      String commentid = const Uuid().v1();
      await _firestore
          .collection('VoiceRoom')
          .doc(id)
          .collection('comments')
          .doc(commentid)
          .set({
        'firstname': user.user.firstname,
        'message': text,
        'uid': user.user.uid,
        'createdAt': DateTime.now(),
        'commentid': commentid,
      });
    } on FirebaseException catch (e) {
      worngCred(e.message!, context);
    }
  }

  Future<void> songPlaying(String text, String id, BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    try {
      String commentid = const Uuid().v1();
      await _firestore
          .collection('VoiceRoom')
          .doc(id)
          .collection('comments')
          .doc(commentid)
          .set({
        'firstname': user.user.firstname,
        'message': text,
        'uid': user.user.uid,
        'createdAt': DateTime.now(),
        'commentid': commentid,
      });
    } on FirebaseException catch (e) {
      worngCred(e.message!, context);
    }
  }
}
