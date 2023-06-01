import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer2/colors/colors.dart';
import 'package:musicplayer2/screens/library/favourite/addTofavorite.dart';
import 'package:musicplayer2/models/dbfunctions.dart';
import 'package:musicplayer2/models/favourites.dart';
import 'package:musicplayer2/models/mostplayed.dart';
import 'package:musicplayer2/models/recentlyplayed.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/songs_by_playlist.dart';
import 'package:musicplayer2/screens/library/recent_played/recentlyfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

List<Audio> allsongs = [];

class _FavoriteScreenState extends State<FavoriteScreen> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  final dbsongs = SongBox.getInstance().values.toList();
  @override
  void initState() {
    final DBfavsongs = favouritesdb.values.toList();

    for (var item in DBfavsongs) {
      allsongs.add(Audio.file(item.songurl!,
          metas: Metas(title: item.songname, id: item.id.toString())));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colordark,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,title:  Text('Favourites',style: GoogleFonts.kanit()),
      ),
      body: ValueListenableBuilder<Box<favourites>>(
        valueListenable: favouritesdb.listenable(),
        builder: (context, Box<favourites> alldbfavsongs, child) {
          List<favourites> allfavsongs = alldbfavsongs.values.toList();

          if (favouritesdb.isEmpty) {
            return Center(
              child: Text(
                'No Songs Added',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  final rsongs = RecentlyPlayed(
                    index: index,
                      songname: allfavsongs[index].songname,
                      duration: allfavsongs[index].duration,
                      songurl: allfavsongs[index].songurl,
                      id: allfavsongs[index].id);
                  addRecentPlay(rsongs);
                  int songIndex = dbsongs.indexWhere((element) =>
                      element.songname == allfavsongs[index].songname);
                  MostPlayed msongs =
                      mostplayedsongs.values.toList()[songIndex];
                  updatePlayedSongsCount(msongs, index);

                  setState(() {
                    playerVisibility = true;
                    isPlaying = true;
                  });

                  audioPlayer.open(
                    Playlist(audios: allsongs, startIndex: index),
                    showNotification: true,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NowPlaying();
                      },
                    ),
                  );
                },
                leading: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(15),
                  artworkHeight: 90,
                  artworkWidth: 60,
                  id: allfavsongs[index].id!,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/music.jpg',
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  allfavsongs[index].songname!,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_rounded,color: Colors.white,),
                  onPressed: () {
                    
                              if (checkFavoriteStatus(index, BuildContext)) {
                                addToFavourites(index);
                              } else if (!checkFavoriteStatus(
                                  index, BuildContext)) {
                                removefavourite(index);
                              }
                    setState(
                      () {
                        addToFavourites(index);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     backgroundColor: Colors.indigo,
                        //     duration: const Duration(seconds: 1),
                        //     margin: const EdgeInsets.symmetric(
                        //         horizontal: 10, vertical: 10),
                        //     behavior: SnackBarBehavior.floating,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10)),
                        //     content: Text(
                        //         '${allfavsongs[index].songname} Removed from favourites'),
                        //   ),
                        // );
                      },
                    );
                  },
                  //color: ,
                ),
              );
            },
            itemCount: allfavsongs.length,
          );
        },
      ), 
    );
  }
}
