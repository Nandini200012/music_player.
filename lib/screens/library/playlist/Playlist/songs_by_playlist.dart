import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer2/functions/addplaylist.dart';
import 'package:musicplayer2/models/playlistmodel.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/addtoplaylist.dart';
import 'package:musicplayer2/screens/slider.dart';
import 'package:musicplayer2/style/style.dart';
import 'package:on_audio_query/on_audio_query.dart';

bool playerVisibility = false;
bool isPlaying = false;
List<Songs>? songs = [];

// ignore: must_be_immutable
class SongsByPlaylistScreen extends StatefulWidget {
  SongsByPlaylistScreen(
      {super.key,
      required this.playlistname,
      required this.playlistindex,
      required this.allPlaylistSongs});

  String playlistname;
  int playlistindex;
  List<Songs> allPlaylistSongs = [];

  @override
  State<SongsByPlaylistScreen> createState() => _SongsByPlaylistScreenState();
}

class _SongsByPlaylistScreenState extends State<SongsByPlaylistScreen> {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

  List<Audio> plstsongs = [];

  @override
  void initState() {
    super.initState();
    for (var song in widget.allPlaylistSongs) {
      plstsongs.add(Audio.file(song.songurl!,
          metas: Metas(title: song.songname, id: song.id.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(
            widget.playlistname,
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              splashRadius: 25,
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: backGroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  context: context,
                  builder: (context) {
                    return AddToPlaylist(
                      playlistIndex: widget.playlistindex,
                    );
                  },
                );
              },
              icon: const Icon(Icons.add_rounded),
              splashRadius: 20,
            )),
        body: ValueListenableBuilder<Box<PlaylistSongs>>(
          valueListenable: playlistbox.listenable(),
          builder: (context, value, _) {
            List<PlaylistSongs> plsongs = playlistbox.values.toList();
            songs = plsongs[widget.playlistindex].playlistssongs;

            if (songs!.isEmpty) {
              return const Center(
                child: Text('No Songs Added !',
                    style: TextStyle(color: Colors.white)),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      audioPlayer.open(
                        Playlist(audios: plstsongs, startIndex: index),
                        showNotification: true,
                      );

                      setState(() {
                        playerVisibility = true;
                        isPlaying = true;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NowPlaying()));
                    },
                    leading: QueryArtworkWidget(
                      artworkBorder: BorderRadius.circular(15),
                      artworkHeight: 90,
                      artworkWidth: 60,
                      id: songs![index].id!,
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
                      songs![index].songname!,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 10),
                      child: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                songs!.removeAt(index);
                                playlistbox.putAt(
                                  widget.playlistindex,
                                  PlaylistSongs(
                                      playlistname: widget.playlistname,
                                      playlistssongs: songs),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.remove_outlined,
                            color: Colors.white,
                          )),
                    ),
                  ),
                );
              },
              itemCount: songs!.length,
            );
          },
        ));
  }
}

AppBar appBar(String title,
    [IconButton? backButton, IconButton? trailingButton]) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: backButton,
    title: Text(
      title,
      style: textWhite22,
    ),
    elevation: 0,
    centerTitle: true,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: trailingButton,
      )
    ],
  );
}
