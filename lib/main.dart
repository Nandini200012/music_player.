import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/screens/library/favourite/addTofavorite.dart';
import 'package:musicplayer2/functions/addplaylist.dart';
import 'package:musicplayer2/models/dbfunctions.dart';
import 'package:musicplayer2/models/favourites.dart';
import 'package:musicplayer2/models/mostplayed.dart';
import 'package:musicplayer2/models/playlistmodel.dart';
import 'package:musicplayer2/models/recentlyplayed.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/library/recent_played/recentlyfunction.dart';
import 'package:musicplayer2/screens/splash/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>(boxname);
  Hive.registerAdapter(favouritesAdapter());
  await Hive.openBox<favourites>(boxname3);
  openFavouritesDB();
  Hive.registerAdapter(MostPlayedAdapter());
  openmostplayeddb();
  //late Box<MostPlayed> mostplayedsongs;
   Hive.registerAdapter(RecentlyPlayedAdapter());
  openrecentlyplayeddb();
    Hive.registerAdapter(PlaylistSongsAdapter());
  await Hive.openBox<PlaylistSongs>('playlist');
  openDatabase();
  // openmostplayeddb() async {
  //   mostplayedsongs = await Hive.openBox("Mostplayed");
  // }

  runApp(const MaterialApp(
    title: 'MUSIFY',
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
