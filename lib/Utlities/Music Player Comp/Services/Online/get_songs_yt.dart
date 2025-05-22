import 'package:audio_service/audio_service.dart';
import 'package:image_to_byte/image_to_byte.dart';
import 'package:image/image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/request_song_permission.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_to_media_item.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

// final songs = [
//   'Espresso - Double shot version',
//   'Espresso',
//   'its been a Long, Long, Time',
//   'Careless Whisper',
//   'I know its over - 2011 remaster'
// ];
// Asynchronous function to get a list of MediaItems representing songs
Future<List<MediaItem>> getSongsYT(tracks) async {
  await requestSongPermission();

  final yt = YoutubeExplode();
  try {
    
    final List<MediaItem> songsList = [];
    final List<SongModel> songmodelSongs = [];
    var i = 1;
    for (var song in tracks) {
      final res = await yt.search(song);
      var f = res.first.title.indexOf(' - ');
      var mainfest =
          await yt.videos.streamsClient.getManifest(res.first.id.value);
      final audioUrl = mainfest.audioOnly.first.url;
      print(res.first.thumbnails.highResUrl.toString());
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
        "title": res.first.title.substring(f + 2),
        "track": 0,
        "is_music": true,
      };
      songmodelSongs.add(SongModel(info));
      i++;
    }

    final List<SongModel> songModels = songmodelSongs;

    for (final SongModel songModel in songModels) {
      final MediaItem song = await songToMediaItem(songModel);
      songsList.add(song);
    }

    return songsList;
  } catch (e) {
    debugPrint('Error fetching songs: $e');
    return [];
  }
}
