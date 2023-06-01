
import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/screens/library/favourite/addTofavorite.dart';
import 'package:musicplayer2/functions/addplaylist.dart';
import 'package:musicplayer2/models/dbfunctions.dart';
import 'package:musicplayer2/models/mostplayed.dart';
import 'package:musicplayer2/models/playlistmodel.dart';
import 'package:musicplayer2/models/recentlyplayed.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/homeplaylistbutton.dart';
import 'package:musicplayer2/screens/library/recent_played/recentlyfunction.dart';
import 'package:musicplayer2/screens/slider.dart';
import 'package:musicplayer2/screens/splash/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';

import '../../../style/style.dart';

class AllSongsWidget extends StatefulWidget {
  const AllSongsWidget({super.key});

  @override
  State<AllSongsWidget> createState() => _AllSongsWidgetState();
}

final AssetsAudioPlayer player = AssetsAudioPlayer(); //instance of audiplayer

class _AllSongsWidgetState extends State<AllSongsWidget> {
  final box = SongBox.getInstance(); //instance of SOngBox
     AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  bool istaped = true;
  bool isalready = true;
  List<Audio> convertaudio = []; //list with audio type
  List<MostPlayed> mostplayed = mostbox.values.toList();

  @override
  void initState() {
    List<Songs> dbsongs = box.values.toList();
    for (var item in dbsongs) {
      convertaudio.add(Audio.file(item.songurl!,
          metas: Metas(title: item.songname, id: item.id.toString())));
    }
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<Box<Songs>>(
              valueListenable: box.listenable(),
              builder: ((context, Box<Songs> allsongbox, child) {
                List<Songs> alldbsongs = allsongbox.values.toList();
                if (alldbsongs.isEmpty) {
                  return const Center(
                    child: Text('No songs in allsongs'),
                    //CircularProgressIndicator(),
                  );
                }
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      //physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: alldbsongs.length ,
                      itemBuilder: ((context, index) {
                        Songs songs = alldbsongs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 5),
                          child: ListTile(
                            onTap: () {
                              //---adding to recently played box
                              RecentlyPlayed rsongs = RecentlyPlayed(
                                  songname: songs.songname,
                                  duration: songs.duration,
                                  songurl: songs.songurl,
                                  id: songs.id,
                                  index: index);
                              addRecentPlay(rsongs);
                              log('recentlyb played added index $index ');
                                //----------
                              // audioPlayer.open(
                              //   Playlist(audios: convertaudio, startIndex: index),
                              //   //showNotification: notificationSwitch,
                              //   loopMode: LoopMode.playlist,
                              //   headPhoneStrategy:
                              //       HeadPhoneStrategy.pauseOnUnplugPlayOnPlug);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => NowPlaying())));
                              //NowPlaying.nowplayingindex.value = alldbsongs[index];
                              //----Mostlyplayed
                              MostPlayed mostsong = mostplayed[index];
                              log('mostplayed index: ${mostplayed[index]}');
                              updatePlayedSongsCount(mostsong, index);

                              //addRec̣ently(index);
                              log('nowplaying index $index');
                              log('alldbsongs --> index: ${alldbsongs[index]}');
                              //print("this song played  $count times");
                              //print(recentplaybox.values.toList()[index]);
                              //-----passing to slider

                              NowPlaying.nowplayingindex.value = index;
                              NowSlider.enteredvalue.value = index;
                              audioPlayer.open(
                                  Playlist(
                                      audios: convertaudio, startIndex: index),
                                  showNotification: true,
                                  headPhoneStrategy:
                                      HeadPhoneStrategy.pauseOnUnplug,
                                  loopMode: LoopMode.playlist);
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(
                              //         builder: (context) => NowPlaying()))
                              //     .then((value) => setState(() {}));
                              // print("this song played  $count times");
                              // print(recentlyplayedbox.values.toList()[index]);
                            },
                            leading: QueryArtworkWidget(
                              id: alldbsongs[index].id!,
                              type: ArtworkType.AUDIO,
                              keepOldArtwork: true,
                              artworkBorder: BorderRadius.circular(10),
                              nullArtworkWidget:  ClipRRect(
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
                              alldbsongs[index].songname!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showOptions(context, index);
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        );
                      })),
                );
              }))
        ],
      ),
    );
  }
}


showOptions(BuildContext context, int index) {
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (((context) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                backgroundColor: Colors.indigo.shade900,
                alignment: Alignment.bottomCenter,
                content: SizedBox(
                  height: 150,
                  width: vwidth,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              if (checkFavoriteStatus(index, BuildContext)) {
                                addToFavourites(index);
                              } else if (!checkFavoriteStatus(
                                  index, BuildContext)) {
                                removefavourite(index);
                              }
                              setState(
                                () {},
                              );
                              Navigator.pop(context);
                            },
                            icon: (checkFavoriteStatus(index, context)
                                ? const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  )),
                            label: (checkFavoriteStatus(index, context)
                                ? const Text('Add to favourites',
                                    style: TextStyle(color: Colors.white))
                                : const Text('Remove from favourites',
                                    style: TextStyle(color: Colors.white)))),
                        TextButton.icon(
                            onPressed: () {
                               log('showPlaylistOptions');
                             playlistBottomSheet(context, index);
                            },
                            icon: const Icon(
                              Icons.playlist_add,
                              color: Colors.white,
                            ),
                            label: const Text('Add to playlist',
                                style: TextStyle(color: Colors.white))),
                      
                        // ignore: prefer_const_constructors
                      ],
                    ),
                  ),
                ));
          }))));
}
  Future<dynamic> playlistBottomSheet(BuildContext context,songindex) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(0)),
            ),
            child: ValueListenableBuilder<Box<PlaylistSongs>>(
              valueListenable: playlistbox.listenable(),
              builder: (context, Box<PlaylistSongs> playlistbox, _) {
                List<PlaylistSongs> playlist = playlistbox.values.toList();

                if (playlistbox.isEmpty) {
                  return const IfNoPlaylist();
                }
                return Column(
                  children: [
                    height10,
                    Text(
                      'Playlist',
                      style: TextStyle(fontSize: 22,color: whiteClr),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: playlist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.headphones_rounded,
                              color: whiteClr,
                            ),
                            title: Text(
                              playlist[index].playlistname!,
                              style: TextStyle(fontSize: 18,color: whiteClr),
                            ),
                            onTap: () {
                              PlaylistSongs? plsongs = playlistbox.getAt(index);
                              List<Songs>? plnewsongs = plsongs!.playlistssongs;
                              Box<Songs> box = Hive.box('Songs');
                              List<Songs> dbAllsongs = box.values.toList();
                              bool isAlreadyAdded = plnewsongs!.any((element) =>
                                  element.id == dbAllsongs[songindex].id);

                              if (!isAlreadyAdded) {
                                plnewsongs.add(
                                  Songs(
                                    songname: dbAllsongs[songindex].songname,
                                   
                                    duration: dbAllsongs[songindex].duration,
                                    songurl: dbAllsongs[songindex].songurl,
                                    id: dbAllsongs[songindex].id,
                                  ),
                                );

                                playlistbox.putAt(
                                    index,
                                    PlaylistSongs(
                                        playlistname:
                                            playlist[index].playlistname,
                                        playlistssongs: plnewsongs),);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: selectedItemColor,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                        '${dbAllsongs[songindex].songname}Added to ${playlist[index].playlistname}')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: selectedItemColor,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                        '${dbAllsongs[songindex].songname} is already added')));
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }