import 'package:hive/hive.dart';
import 'package:musicplayer2/models/playlistmodel.dart';
import 'package:musicplayer2/models/songmodel.dart';

import 'package:on_audio_query/on_audio_query.dart';

createplaylist(String name) async {
  void initState() {
    // TODO: implement initState
  }
  // List<Songs> dbsongs = box.values.toList();

  // final List<PlaylistModel> playlistsong1 = [];
  final box1 = PlaylistSongsbox.getInstance();

  List<PlaylistModel> playlist = [];
  List<Songs> songsplaylist = [];

  List<PlaylistSongs> playlistDB = box1.values.toList();

  box1.add(PlaylistSongs(playlistname: name, playlistssongs: songsplaylist));
  print(name);
}

addToPlaylist(Songs song, int index) {
  List<Songs> songsplay = [];
  final box = SongBox.getInstance();
  List<Songs> allDbsongs = box.values.toList();
  PlaylistSongs playlistModel;
  void initState() {
    // TODO: implement initState
  }
  // List<Songs> dbsongs = box.values.toList();

  final List<PlaylistModel> playlistsong1 = [];
  final box1 = PlaylistSongsbox.getInstance();

  List<PlaylistSongs> playlistDB = box1.values.toList();

  print(playlistDB);
}

deletePlaylist(int index) {
  final box1 = PlaylistSongsbox.getInstance();
  List<PlaylistModel> playlist = [];
  List<Songs> songsplaylist = [];

  List<PlaylistSongs> playlistDB = box1.values.toList();

  box1.deleteAt(index);
}

deleteFromPlaylist(int index) {
  final box1 = PlaylistSongsbox.getInstance();
  List<PlaylistModel> playlist = [];
  List<Songs> songsplaylist = [];

  List<PlaylistSongs> playlistDB = box1.values.toList();

  box1.delete(index);
}
