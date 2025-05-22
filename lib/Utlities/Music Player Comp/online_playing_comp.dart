import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spotify/spotify.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/get_song_yt.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/request_song_permission.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;
import 'package:yume/Utlities/global_variables.dart' as global;

class OnlinePlayingComp {
  static final spo = SpotifyApi(SpotifyApiCredentials(
      dotenv.env["CLIENT_ID"], dotenv.env["CLIENT_sECRET"]));
  static final yt = youtube.YoutubeExplode();

  static addqueue(
      {required String title, required SongHandler songHandler}) async {
    await requestSongPermission();
    final MediaItem? song = await getSongYT(title);
    songHandler.addtoqueue(song: song!);
  }

  Future playOnlineSongs(
      {required List<dynamic> tracks, required SongHandler songHandler}) async {
    await requestSongPermission();
    global.playlistsongs.clear();
    print("Sucker 0 ${tracks.length}");
    var i = 1;
    final List<MediaItem> songsList = [];
    final List<SongModel> songmodelSongs = [];
    for (var track in tracks) {
      if (i == 1) {
        MediaItem? song = await getSongYT(track);
        global.playlistsongs.add(song!);
        songHandler.initSongs(songs: global.playlistsongs);
        print("Sucker 1 ${global.playlistsongs.length}");
        songHandler.play();
      } else {
        MediaItem? song = await getSongYT(track);
        songsList.add(song!);
        print("Sucker 2 ${global.playlistsongs.length}");
      }
      i++;
    }
    global.playlistsongs.addAll(songsList);
    songHandler.initSongs(songs: global.playlistsongs);
    print("Sucker 3 ${global.playlistsongs.length}");

    return songsList;
  }

  // static fetchPlaylist() async {
  //   final res = await yt.playlists.;
  //   var f = res.first.title.indexOf(' - ');
  //   var mainfest =
  //       await yt.videos.streamsClient.getManifest(res.first.id.value);
  //   final audioUrl = mainfest.audioOnly.first.url;
  //   var info = {
  //     "_id": res.first.hashCode,
  //     "_data": res.first.thumbnails.highResUrl.toString(),
  //     "_uri": audioUrl.toString(),
  //     "_display_name": res.first.title,
  //     "_display_name_wo_ext": "",
  //     "_size": 0,
  //     "album": "",
  //     "album_id": "",
  //     "artist": res.first.author,
  //     "artist_id": 0,
  //     "genre": "",
  //     "genre_id": 0,
  //     "bookmark": 0,
  //     "duration": res.first.duration?.inMilliseconds,
  //     "title": res.first.title.substring(f + 2),
  //     "track": 0,
  //     "is_music": true,
  //   };

  //   // global.songs.add(realsong);

  //   return realsong;
  // }

  Future<List<Map<String, dynamic>>> featuredPlaylists() async {
    var relatedArtists = await spo.playlists.featured.getPage(10);
    print('\nRelated Artists: ${relatedArtists}');

    List<Map<String, dynamic>> playlists = [];
    var featuredPlaylists = await spo.playlists.featured.all();

    for (var playlist in featuredPlaylists) {
      if (playlist.name!.isCaseInsensitiveContainsAny("hits") ||
          playlist.name!.isCaseInsensitiveContainsAny("trending") ||
          playlist.name!.isCaseInsensitiveContainsAny("top")) {
        Map<String, dynamic> temp = {
          'img': playlist.images!.first.url,
          "id": playlist.id,
          'image': [],
          'name': [],
          'artist': [],
          'title': playlist.name!
        };
        var tracks =
            await spo.playlists.getTracksByPlaylistId(playlist.id!).first(10);
        for (var track in tracks.items!) {
          temp['name']!.add(track.name.toString());
          temp['image']!.add(track.album!.images![1].url);
          temp['artist']!.add(track.artists?[0].name);
        }
        playlists.add(temp);
      }
    }

    return playlists;
  }

  Future<Map<String, dynamic>> newReleases() async {
    print("fuck 2");
    var newReleases = await spo.browse.getNewReleases().all();
    Map<String, dynamic> newreleases = {
      'image': [],
      'title': [],
      'artist': [],
      'name': "New Releases"
    };
    int i = 0;
    for (var album in newReleases) {
      if (i <= 20) {
        newreleases['title']!.add(album.name.toString());
        newreleases['image']!.add(album.images![0].url);
        newreleases['artist']!.add(album.artists?[0].name);
        i++;
      } else {
        break;
      }
    }
    return newreleases;
  }

  Future<Map<String, List>> fetchPlaylistTracks(String playlistId) async {
    Map<String, List> titles = {
      "id": [],
      "title": [],
      "artist": [],
      "image": []
    };
    var tracks = await spo.playlists.getTracksByPlaylistId(playlistId).all();

    for (var track in tracks) {
      if (track == null) {
        print('Empty items');
      }
      titles['id']!.add(track.id);
      titles['title']!.add(track.name);
      titles['artist']!.add(track.artists![0].name);
      titles['image']!.add(track.album!.images![0].url);
    }

    return titles;
  }
}
