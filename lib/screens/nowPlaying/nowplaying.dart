import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer2/colors/colors.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/slider.dart';
import 'package:musicplayer2/screens/home/widget/FullSOngWidget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

bool isRepeat = false;
bool isShuffle = false;
int valueoption = 0;

class NowPlaying extends StatefulWidget {
  NowPlaying({super.key});

  List<Songs>? songs;
  static int? indexvalue = 0;
  static ValueNotifier<int> nowplayingindex = ValueNotifier<int>(indexvalue!);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

final player = AssetsAudioPlayer.withId('0');

class _NowPlayingState extends State<NowPlaying> {
  final box = SongBox.getInstance();

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    return SafeArea(
        child: Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                      onPressed: () {
                        NowSlider.enteredvalue = NowPlaying.nowplayingindex;
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.expand_more,
                        color: iconcolor,
                        size: 35,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: vwidth * 0.17),
                child: const Text(
                  'Now Playing',
                  style: TextStyle(fontSize: 18, color: fontcolor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: IconButton(
                    onPressed: () {
                      optionsmorevert();
                    },
                    icon: const Icon(
                      Icons.more_vert_sharp,
                      color: iconcolor,
                      size: 28,
                    )),
              )
            ],
          ),
          const SizedBox(height: 30),
          ValueListenableBuilder(
              valueListenable: NowPlaying.nowplayingindex,
              builder: (BuildContext context, int value1, child) {
                return ValueListenableBuilder<Box<Songs>>(
                    valueListenable: box.listenable(),
                    builder: ((context, Box<Songs> allsongbox, child) {
                      List<Songs> allDbdongs = allsongbox.values.toList();
                      if (allDbdongs.isEmpty) {
                        print('No songs');
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      valueoption = value1;
                      return player.builderCurrent(
                          builder: ((context, playing) {
                        return Column(
                          children: [
                            QueryArtworkWidget(
                              artworkQuality: FilterQuality.high,
                              artworkHeight: vheight * 0.50,
                              artworkWidth: vheight * 0.44,
                              artworkBorder: BorderRadius.circular(10),
                              artworkFit: BoxFit.cover,
                              id: int.parse(playing.audio.audio.metas.id!),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/music.jpg',
                                  width: vwidth * 0.8,
                                  height: vheight * 0.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      // ignore: sized_box_for_whitespace
                                      child: Container(
                                        width: 300,
                                        child: Text(
                                          player.getCurrentAudioTitle,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18, color: fontcolor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                PlayerBuilder.realtimePlayingInfos(
                                  player: player,
                                  builder: (context, realtimePlayingInfos) {
                                    duration = realtimePlayingInfos
                                        .current!.audio.duration;
                                    position =
                                        realtimePlayingInfos.currentPosition;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: ProgressBar(
                                        baseBarColor:
                                            Colors.white.withOpacity(0.5),
                                        progressBarColor: const Color.fromARGB(
                                            255, 89, 4, 173),
                                        thumbColor: const Color.fromARGB(
                                            255, 24, 14, 14),
                                        thumbRadius: 5,
                                        timeLabelPadding: 5,
                                        progress: position,
                                        timeLabelTextStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        total: duration,
                                        onSeek: (duration) async {
                                          await player.seek(duration);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                PlayerBuilder.isPlaying(
                                  player: player,
                                  builder: ((context, isPlaying) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: isShuffle
                                                ? const Icon(
                                                    Icons.shuffle_rounded,
                                                    color: Colors.indigo,
                                                  )
                                                : const Icon(
                                                    Icons.shuffle_rounded),
                                            iconSize: 30,
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                if (isShuffle == true) {
                                                  isShuffle = false;
                                                  player.toggleShuffle();
                                                } else {
                                                  isShuffle = true;
                                                  player.toggleShuffle();
                                                }
                                              });
                                            },
                                            padding: EdgeInsets.zero,
                                            splashRadius: 30,
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: IconButton(
                                              onPressed: () {
                                                previousMusic(
                                                    player, value1, allDbdongs);
                                              },
                                              icon: const Icon(
                                                Icons.skip_previous,
                                                color: iconcolor,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: appbarcolor,
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                if (isPlaying) {
                                                  player.pause();
                                                } else {
                                                  player.play();
                                                }
                                                setState(
                                                  () {
                                                    isPlaying = !isPlaying;
                                                  },
                                                );
                                              },
                                              icon: (isPlaying)
                                                  ? const Icon(
                                                      Icons.pause,
                                                      color: iconcolor,
                                                      size: 35,
                                                    )
                                                  : const Icon(
                                                      Icons.play_arrow,
                                                      color: iconcolor,
                                                      size: 35,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: IconButton(
                                              onPressed: () {
                                                skipMusic(
                                                    player, value1, allDbdongs);
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.skip_next,
                                                color: iconcolor,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: isRepeat == true
                                                ? const Icon(
                                                    Icons.repeat_one_rounded,
                                                    color: Colors.indigo,
                                                  )
                                                : const Icon(
                                                    Icons.repeat_outlined),
                                            color: iconcolor,
                                            iconSize: 30,
                                            onPressed: () {
                                              setState(() {
                                                if (isRepeat == false) {
                                                  isRepeat = true;
                                                  player.setLoopMode(
                                                      LoopMode.single);
                                                } else {
                                                  isRepeat = false;
                                                  player.setLoopMode(
                                                      LoopMode.none);
                                                }
                                              });
                                            },
                                            padding: EdgeInsets.zero,
                                            splashRadius: 30,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            )
                          ],
                        );
                      }));
                    }));
              })
        ],
      ),
    ));
  }

  void skipMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.next();

    setState(() {
      NowSlider.enteredvalue.value++;
    });
    await player.stop();
  }

  void previousMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.previous();

    setState(() {
      NowSlider.enteredvalue.value--;
    });
    await player.stop();
  }

  void shuffleMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    setState(() {
      NowSlider.enteredvalue = NowPlaying.nowplayingindex;
    });
    await player.stop();
  }

  optionsmorevert() {
    showOptions(context, valueoption);
  }
}
