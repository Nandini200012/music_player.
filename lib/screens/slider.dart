import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowSlider extends StatefulWidget {
  const NowSlider({super.key});

  static int? index = 0;
  static ValueNotifier<int> enteredvalue = ValueNotifier<int>(index!);

  @override
  State<NowSlider> createState() => _NowSliderState();
}

   AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

class _NowSliderState extends State<NowSlider> {
  final box = SongBox.getInstance();
  List<Audio> convertaudio = [];

  @override
  void initState() {
    List<Songs> dbsongs = box.values.toList();
    for (var item in dbsongs) {
      convertaudio.add(Audio.file(item.songurl!,
          metas: Metas(title: item.songname, id: item.id.toString())));

      player.open(
        Playlist(audios: convertaudio),
        showNotification: true,
        autoStart: false,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
      );

      super.initState();
    }
  }

  @override
  // ignore: unused_element
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      valueListenable: NowSlider.enteredvalue,
      builder: (BuildContext context, int index1, _) {
        log('entered value index in slider is == $index1');

        return ValueListenableBuilder(
  
          valueListenable:  box.listenable(),
          builder: (context, Box<Songs> allsongbox, child) {
            List<Songs> alldbsongs = allsongbox.values.toList();
            if (alldbsongs.isEmpty) {
              log('no songs in slider db');
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            }
            return GestureDetector(
                onTap: () {
                  audioPlayer.open(
                      Playlist(audios: convertaudio, startIndex: index1),
                      showNotification: true,
                      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                      loopMode: LoopMode.playlist);

                  NowPlaying.nowplayingindex.value = index1;

                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => NowPlaying())));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade900,
                      borderRadius: BorderRadius.circular(5)),
                  width: vwidth,
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QueryArtworkWidget(
                        quality: 100,
                        artworkWidth: vwidth * 0.16,
                        artworkHeight: vheight * 0.16,
                        keepOldArtwork: true,
                        artworkBorder: BorderRadius.circular(10),
                        id:   alldbsongs[index1].id!,
                        //int.parse(
                              // player.id),
                        type: ArtworkType.AUDIO,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alldbsongs[index1].songname!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      PlayerBuilder.isPlaying(
                          player: player,
                          builder: ((context, isplaying) {
                            return Padding(
                                padding: EdgeInsets.only(right: vwidth * 0.00),
                                child: Wrap(
                                  spacing: 10,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        onPressed: () {
                                          if (isplaying) {
                                            player.stop();
                                          } else {
                                            playMusic(
                                                player, index1, alldbsongs);
                                          }
                                        },
                                        icon: AnimatedCrossFade(
                                            firstChild: const Icon(
                                              Icons.play_arrow,
                                              size: 40,
                                            ),
                                            // ignore: prefer_const_constructors
                                            secondChild: Icon(
                                              Icons.pause,
                                              size: 40,
                                            ),
                                            crossFadeState: isplaying
                                                ? CrossFadeState.showSecond
                                                : CrossFadeState.showFirst,
                                            duration: const Duration(
                                                milliseconds: 100)),
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        width: 5,
                                        //height: 50,
                                        child: IconButton(
                                            onPressed: () {
                                              skipMusic(
                                                  player, index1, alldbsongs);
                                            },
                                            icon: IconButton(
                                              icon: const Icon(
                                                Icons.skip_next,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {},
                                            )))
                                  ],
                                ));
                          }))
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  void skipMusic(
      AssetsAudioPlayer player, int index, List<Songs> dbsongs) async {
    if (index == dbsongs.length) {
      index == -1;
    }

    player.open(
      Audio.file(dbsongs[index + 1].songurl!),
    );
    setState(() {
      NowSlider.enteredvalue.value++;
    });
    await player.stop();
  }

  void playMusic(AssetsAudioPlayer player, int index, List<Songs> songs) async {
    player.open(
      Audio.file(songs[index].songurl!),
    );
    setState(() {
      NowSlider.enteredvalue.value;
    });
    await player.stop();
  }
}
