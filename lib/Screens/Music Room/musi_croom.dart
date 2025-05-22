import 'package:duration/duration.dart';

class Voiceroom {
  final String title;
  // final String image;
  final String uid;
  final String username;
  final startedAt;
  final int memebers;
  final String roomid;
  final String currentsongUrl;
  final String pos;
  final String pause;
  final String play;

  Voiceroom({
    required this.title,
    required this.uid,
    required this.username,
    required this.memebers,
    required this.roomid,
    required this.startedAt,
    required this.currentsongUrl,
    required this.pos,
    required this.pause,
    required this.play,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      // 'image': image,
      'uid': uid,
      'username': username,
      'memebers': memebers,
      'roomid': roomid,
      'startedAt': startedAt,
      'pos': pos.toString(),
      'currentsongUrl': currentsongUrl,
      'pause': pause,
      'play': play,
    };
  }

  factory Voiceroom.fromMap(Map<String, dynamic> map) {
    return Voiceroom(
      title: map['title'] ?? "",
      // image: map['image'] ?? "",
      uid: map['uid'] ?? "",
      username: map['username'] ?? "",
      memebers: map['members'] ?? 0,
      roomid: map['roomid'] ?? "",
      startedAt: map['startedAt'] ?? "",
      currentsongUrl: map['currentsongUrl'] ?? "",
      pos: map['pos'] ?? "",
      pause: map['pause'] ?? "",
      play: map['play'] ?? "",
    );
  }
}
