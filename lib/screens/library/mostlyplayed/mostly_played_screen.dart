import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer2/models/dbfunctions.dart';
import 'package:musicplayer2/models/mostplayed.dart';
import 'package:musicplayer2/models/recentlyplayed.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/songs_by_playlist.dart';
import 'package:musicplayer2/screens/library/recent_played/recentlyfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayedScreen extends StatefulWidget {
  const MostlyPlayedScreen({super.key});

  @override
  State<MostlyPlayedScreen> createState() => _MostlyPlayedScreenState();
}

class _MostlyPlayedScreenState extends State<MostlyPlayedScreen> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> songs = [];
  List<RecentlyPlayed> rsongs = recentplaybox.values.toList();

  @override
  void initState() {
    List<MostPlayed> songlist = mostplayedsongs.values.toList();
    int i = 0;
    for (var item in songlist) {
      if (item.count > 2) {
        finalmpsongs.insert(i, item);

        i = i + 1;
      }
    }
    for (var items in finalmpsongs) {
      songs.add(Audio.file(items.songurl,
          metas: Metas(title: items.songname, id: items.id.toString())));
    }
    super.initState();
  }

  List<MostPlayed> finalmpsongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),backgroundColor:Colors.transparent,title:  Text('Mostly Played',style: GoogleFonts.kanit()),),
          
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
        valueListenable: mostplayedsongs.listenable(),
        builder: (context, Box<MostPlayed> mpsongsbox, _) {
          if (finalmpsongs.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  MostPlayed msongs = mpsongsbox.values.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        updatePlayedSongsCount(msongs, index);
                        addRecentPlay(rsongs[index]);
                        audioPlayer.open(
                          Playlist(audios: songs, startIndex: index),
                          showNotification: true,
                        );

                        setState(() {
                          playerVisibility = true;
                          isPlaying = true;
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  NowPlaying()));
                      },
                      leading: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(15),
                        artworkHeight: 90,
                        artworkWidth: 60,
                        id: finalmpsongs[index].id,
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
                        finalmpsongs[index].songname,
                        style: const TextStyle(color: Colors.white),
                      ),
                      
                      
                    ),
                  );
                },
                itemCount:  finalmpsongs.length ,
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Mostly Played Songs',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
