import 'package:hive/hive.dart';
part 'favourites.g.dart';

@HiveType(typeId: 3)
class favourites {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  int? duration;
  @HiveField(2)
  String? songurl;
  @HiveField(3)
  int? id;
  favourites(
      {required this.songname,
      required this.duration,
      required this.songurl,
      required this.id});
}

String boxname3 = 'favourites';

class favouritesbox {
  static Box<favourites>? _box;
  static Box<favourites> getInstance() {
    return _box ??= Hive.box(boxname3);
  }
}
