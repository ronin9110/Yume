import 'package:audio_service/audio_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_to_media_item.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<MediaItem?> getSongYT(String song) async {
  final yt = YoutubeExplode();
  try {
    final res = await yt.search(song);
    var mainfest =
        await yt.videos.streamsClient.getManifest(res.first.id.value);
    final audioUrl = mainfest.audioOnly.first.url;
    var info = {
      "_id": res.first.hashCode,
      "_data": res.first.thumbnails.highResUrl.toString(),
      "_uri": audioUrl.toString(),
      "_display_name": res.first.title,
      "_display_name_wo_ext": "",
      "_size": 0,
      "album": "",
      "album_id": "",
      "artist": res.first.author,
      "artist_id": 0,
      "genre": "",
      "genre_id": 0,
      "bookmark": 0,
      "duration": res.first.duration?.inMilliseconds,
      "title": res.first.title,
      "track": 0,
      "is_music": true,
    };
    final MediaItem realsong = await songToMediaItem(SongModel(info));

    return realsong;
  } catch (e) {
    debugPrint('Error fetching song: $e');
    return null;
  }
}
