library globals;

import 'package:audio_service/audio_service.dart';

List<MediaItem> songs = [];

List<Map<String, dynamic>> cards = [];
Map<String, dynamic> newrel = {};

List<MediaItem> playlistsongs = [];

Map<String, dynamic> queue = {
  'image': [],
  'title': [],
  'artist': [],
};

bool localsongs = true;
