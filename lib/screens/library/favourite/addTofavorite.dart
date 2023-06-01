
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/models/favourites.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/splash/splash.dart';

late Box<favourites> favouritesdb;
openFavouritesDB() async {
  favouritesdb = await Hive.openBox<favourites>('favourites');
}
addToFavourites(int index) async {
  List<Songs> dbsongs = box.values.toList();
  List<favourites> favouritessongs = [];
  favouritessongs = favouritesdb.values.toList();
  bool isalready = favouritessongs
      .where((element) => element.songname == dbsongs[index].songname)
      .isEmpty;
  if (isalready) {
    favouritesdb.add(favourites(
        songname: dbsongs[index].songname,
        duration: dbsongs[index].duration,
        songurl: dbsongs[index].songurl,
        id: dbsongs[index].id));
  } else { 
    favouritessongs
        .where((element) => element.songname == dbsongs[index].songname)
        .isEmpty;
    int currentindex = favouritessongs
        .indexWhere((element) => element.id == dbsongs[index].id);
    await favouritesdb.deleteAt(currentindex);
    await favouritesdb.deleteAt(index);
  }
}

removefavourite(int index) async {
  final box4 = favouritesbox.getInstance();
  // List<favourites> favouritessongs = [];
  List<favourites> favsongs = box4.values.toList();
  List<Songs> dbsongs = box.values.toList();
  int currentindex =
      favsongs.indexWhere((element) => element.id == dbsongs[index].id);
  await favouritesdb.deleteAt(currentindex);
}

deletefavourite(int index) async {
  await favouritesdb.deleteAt(favouritesdb.length - index - 1);
}

bool checkFavoriteStatus(int index, BuildContext) {
  List<favourites> favouritessongs = [];
  List<Songs> dbsongs = box.values.toList();
  favourites value = favourites(
      songname: dbsongs[index].songname,
      duration: dbsongs[index].duration,
      songurl: dbsongs[index].songurl,
      id: dbsongs[index].id);

  favouritessongs = favouritesdb.values.toList();
  bool isAlreadyThere = favouritessongs
      .where((element) => element.songname == value.songname)
      .isEmpty;
  return isAlreadyThere ? true : false;
}

