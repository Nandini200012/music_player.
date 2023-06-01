// ignore_for_file: avoid_print

//To add new playlist
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/models/playlistmodel.dart';
import 'package:musicplayer2/models/songmodel.dart';
late Box<PlaylistSongs> playlistbox;
openDatabase() async {
  playlistbox = await Hive.openBox<PlaylistSongs>('playlist');
  // playlistbox.clear();
}

newplaylist(String title) async{
  final playlistbox = PlaylistSongsbox.getInstance();
  List<PlaylistSongs> dbplaylist = playlistbox.values.toList();
  bool isAlready =
      dbplaylist.where((element) => element.playlistname == title).isEmpty;
  if (isAlready) {
    List<Songs> playlistsongs = [];
    playlistbox.add(
      PlaylistSongs(playlistname: title, playlistssongs: playlistsongs),
    );
  }
}

//To add songs to playlists
addtoplaylist(Songs song, int index) async{
  final playlistbox = PlaylistSongsbox.getInstance();
  List<PlaylistSongs> dbplaylist = playlistbox.values.toList();
  print(dbplaylist);
}

//To delete playlist
deleteplaylist(int index) async{
  final playlistbox = PlaylistSongsbox.getInstance();
  playlistbox.deleteAt(index);
}

//To delete songs from playlist
deltefromplaylist(int index) async{
  final playlistbox = PlaylistSongsbox.getInstance();
  playlistbox.delete(index);
}
