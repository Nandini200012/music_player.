import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer2/models/dbfunctions.dart';
import 'package:musicplayer2/models/mostplayed.dart';
import 'package:musicplayer2/models/recentlyplayed.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/homeplaylistbutton.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/songs_by_playlist.dart';
import 'package:musicplayer2/screens/library/recent_played/recentlyfunction.dart';
import 'package:musicplayer2/screens/home/widget/FullSOngWidget.dart';
import 'package:on_audio_query/on_audio_query.dart';


class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> resongs = [];
  List<Songs> dbSongs = SongBox.getInstance().values.toList();
  @override
  void initState() {
    List<RecentlyPlayed> rdbsongs =
        recentplaybox.values.toList().reversed.toList();

    for (var item in rdbsongs) {
      resongs.add(
        Audio.file(
          item.songurl!,
          metas: Metas(
            title: item.songname,
           
            id: item.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back)),backgroundColor:Colors.transparent,title:  Text('Recently Played',style: GoogleFonts.kanit()),),
          
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<Box<RecentlyPlayed>>(
        valueListenable: recentplaybox.listenable(),
        builder: (context, Box<RecentlyPlayed> recentsongs, _) {
          List<RecentlyPlayed> rsongs =
              recentsongs.values.toList().reversed.toList();
          if (rsongs.isEmpty) {
            return const Center(
              child: Text(
                'No Recently played',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                List<MostPlayed> allmostplayedsongs =
                        mostplayedsongs.values.toList();
                        MostPlayed msongs = allmostplayedsongs[index];
                return recentsongs.isEmpty
                    ? const Center(
                        child: Text(
                          'No Recent Played !',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          onTap: () {
                           final rsong = RecentlyPlayed(
                                  songname: rsongs[index].songname,
                                  index: index,
                                  duration: rsongs[index].duration,
                                  songurl: rsongs[index].songurl,
                                  id: rsongs[index].id);
                             addRecentPlay(rsong);
                            //  updatePlayedSongCount(msongs, index);
                            _audioPlayer.open(
                              Playlist(audios: resongs, startIndex: index),
                              showNotification:true,
                              loopMode: LoopMode.none,
                            );
                            setState(() {
                              playerVisibility=true;
                              isPlaying = true;
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                     NowPlaying(),
                              ),
                            );
                          },
                          leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(15),
                            artworkHeight: 90,
                            artworkWidth: 60,
                            id: rsongs[index].id!,
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
                            rsongs[index].songname!,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),

                           
                     // trailing: HomePlaylistButton(songindex: index)
                        ),
                    );
                      
              },
              itemCount: rsongs.length > 5 ? 5 : rsongs.length,
            ),
          );
        },
      ),
    );
  }
}
