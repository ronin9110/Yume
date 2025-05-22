import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart' as dur;
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as you;
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_to_media_item.dart';

// Class for handling audio playback using AudioService and Just Audio
class SongHandlerVC extends BaseAudioHandler with QueueHandler, SeekHandler {
  // Create an instance of the AudioPlayer class from just_audio package
  final AudioPlayer audioPlayer = AudioPlayer();

  // Function to create an audio source from a MediaItem
  // UriAudioSource _createAudioSource(MediaItem item) {
  //   return ProgressiveAudioSource(Uri.parse(item.id));
  // }

  // Listen for changes in the current song index and update the media item
  void _listenForCurrentSongIndexChanges() {
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }

  // Broadcast the current playback state based on the received PlaybackEvent
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    ));
  }

  // Function to initialize the songs and set up the audio player
  Future<void> initSong({required title, required channelid}) async {
    final yt = you.YoutubeExplode();
    final res = await yt.search(title);
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
    final MediaItem song = await songToMediaItem(SongModel(info));
    song;
    // Listen for playback events and broadcast the state
    audioPlayer.playbackEventStream.listen(_broadcastState);
    final MediaItem son = song;
    // Create a list of audio sources from the provided songs
    final audioSource = ProgressiveAudioSource(audioUrl);
    Duration? pos;
    // Set the audio source of the audio player to the concatenation of the audio sources
    await audioPlayer.setAudioSource(audioSource);
    FirebaseFirestore.instance
        .collection("VoiceRoom")
        .doc(channelid)
        .snapshots()
        .listen((onData) {
      print(onData);
    });
    queue.value.clear();
    queue.value.add(son);
    queue.add(queue.value);

    audioPlayer.play();
    audioPlayer.seek(pos);
    await audioPlayer.seek(Duration.zero, index: 0);

    // Listen for processing state changes and skip to the next song when completed
    // audioPlayer.processingStateStream.listen((state) {
    //   if (state == ProcessingState.completed) skipToNext();
    // });
  }

  // Future<void> playYt(Uri str) {
  //   audioPlayer.setUrl(str.toString());
  //   return audioPlayer.play();
  // }

  // Play function to start playback
  @override
  Future<void> play() => audioPlayer.play();

  // Pause function to pause playback
  @override
  Future<void> pause() => audioPlayer.pause();

  // Seek function to change the playback position
  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  // Skip to a specific item in the queue and start playback
  @override
  Future<void> skipToQueueItem(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
    play();
  }

  // Skip to the next item in the queue
  @override
  Future<void> skipToNext() => audioPlayer.seekToNext();

  // Skip to the previous item in the queue
  @override
  Future<void> skipToPrevious() => audioPlayer.seekToPrevious();

  Future<void> shuffleQueue(shuff) => audioPlayer.setShuffleModeEnabled(shuff);

  Future<void> repeatMode(rep) => audioPlayer.setLoopMode(rep);
}

class YoutubeExplode {}
