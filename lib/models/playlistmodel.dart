import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/models/songmodel.dart';
part 'playlistmodel.g.dart';

@HiveType(typeId: 6)
class PlaylistSongs {
  @HiveField(0)
  String? playlistname;
  @HiveField(1)
  List<Songs>? playlistssongs;
  PlaylistSongs({required this.playlistname, required this.playlistssongs});
}

class PlaylistSongsbox {
  static Box<PlaylistSongs>? _box;
  static Box<PlaylistSongs> getInstance() {
    return _box ??= Hive.box('playlist');
  }
}
