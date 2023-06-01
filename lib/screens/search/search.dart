import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer2/colors/colors.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/nowPlaying/nowplaying.dart';
import 'package:musicplayer2/screens/slider.dart';
import 'package:musicplayer2/screens/home/widget/FullSOngWidget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

class _SearchState extends State<Search> {
  @override
  void initState() {
    dbsongs = box.values.toList();
    super.initState();
  }

  late List<Songs> dbsongs = [];
  List<Audio> allsongs = [];
  final TextEditingController searchcontroller = TextEditingController();

  late List<Songs> searchlist = List.from(dbsongs);
  bool istaped = true;

  final box = SongBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
          child: SafeArea(
        child: Container(
          height: 900,
          width: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
                         Colors.indigoAccent.shade400,
              const Color.fromARGB(255, 0, 5, 34),
              Colors.black,
              Colors.black,
              Colors.black,          
              Colors.black,
              Colors.black,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: searchcolor),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      controller: searchcontroller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: 'What do you want to listen to? ',
                      ),
                      onChanged: ((value) => updateSearch(value.trim())),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchlist.length,
                itemBuilder: ((context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 5),
                      child: ListTile(
                          onTap: () {
                            //NowSlider.enteredvalue.value = index;
                            player.open(
                                Audio.file(searchlist[index].songurl!,
                                    metas: Metas(
                                        title: searchlist[index].songname,
                                        id: searchlist[index].id.toString())),
                                showNotification: true);
                                Navigator.of(context).push(MaterialPageRoute(builder: (contex)=>NowPlaying()));
                          },
                          leading: QueryArtworkWidget(
                            keepOldArtwork: true,
                            artworkBorder: BorderRadius.circular(10),
                            id: searchlist[index].id!,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget:  ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/music.jpg',
                              width: 40,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          ),
                          title: Text(searchlist[index].songname!,
                              style: const TextStyle(color: fontcolor)),
                          trailing: IconButton(
                              onPressed: () {showOptions(context, index);},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ))),
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }

  updateSearch(String value) {
    setState(() {
      searchlist = dbsongs
          .where((element) =>
              element.songname!.toLowerCase().contains(value.toLowerCase()))
          .toList();

      allsongs.clear();
      for (var item in searchlist) {
        allsongs.add(Audio.file(item.songurl.toString(),
            metas: Metas(title: item.songname, id: item.id.toString())));
      }
    });
  }
}
