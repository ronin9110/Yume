import 'package:flutter/material.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_progress.dart';

Widget buildProgress(
    {required Duration totalDuration, required SongHandler songHandler}) {
  return ListTile(
    title: SongProgress(
        // Use SongProgress widget to display progress bar
        totalDuration: totalDuration,
        songHandler: songHandler),
  );
}
