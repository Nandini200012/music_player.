import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/models/recentlyplayed.dart';

late Box<RecentlyPlayed> recentplaybox;
openrecentlyplayeddb() async {
  recentplaybox = await Hive.openBox("Recentlyplayed");
}
addRecentPlay(RecentlyPlayed value) async{
  
  List<RecentlyPlayed> recentList = recentplaybox.values.toList();
  bool isAdded =
      recentList.where((element) => element.songname == value.songname).isEmpty;
  if (isAdded == true) {
    recentplaybox.add(value);
  } else {
    int position =
        recentList.indexWhere((element) => element.songname == value.songname);
    recentplaybox.deleteAt(position);
    recentplaybox.add(value);
  }
}
//late Box<RecentlyPlayed> RecentlyPlayedBox;

// late Box<RecentlyPlayed> recentlyplayedbox;
// openrecentlyplayedDb() async {
//   recentlyplayedbox = await Hive.openBox('Recentlyplayed');
// }

// openrecentlyplayeddb() async {
//   recentplaybox = await Hive.openBox<RecentlyPlayed>("Recentlyplayed");
// }
// updateRecentlyPlayed(RecentlyPlayed value) {
//   // recentlyplayedbox.clear();
//   // mostplayedsongs.clear();
//   List<RecentlyPlayed> list = recentplaybox.values.toList();
//   bool isAlready =
//       list.where((element) => element.songname == value.songname).isNotEmpty;

//   if (isAlready == false) {
//     recentplaybox.add(value);

//     // print(recentlyplayedbox.values.toList());
//   } else {
//     int index =
//         list.indexWhere((element) => element.songname == value.songname);

//     recentplaybox.deleteAt(index);
//     recentplaybox.add(value);
//   }
// }
