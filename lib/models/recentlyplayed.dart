import 'package:hive/hive.dart';
part 'recentlyplayed.g.dart';

@HiveType(typeId: 2)
class RecentlyPlayed {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  int? duration;
  @HiveField(2)
  String? songurl;
  @HiveField(3)
  int? id;
  @HiveField(4)
  int? index;
  RecentlyPlayed(
      {this.songname,
      this.duration,
      this.songurl,
      required this.id,
      required this.index});
}

String boxname2 = 'RecentlyPlayed';

class RecentlyPlayedBox {
  static Box<RecentlyPlayed>? _box;
  static Box<RecentlyPlayed> getInstance() {
    return _box ??= Hive.box(boxname2);
  }
}
