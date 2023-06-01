import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer2/models/mostplayed.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/home/app.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final OnAudioQuery audioquery = OnAudioQuery();
final box = SongBox.getInstance();
List<SongModel> fetchsongs = [];
List<SongModel> allsongs = [];
final mostbox = MostplayedBox.getInstance();

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
        requestStoragePermission();

    _navigatetohome();
       super.initState();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/Play-Button-Transparent-PNG-300x300.png',
              height: 100,
              width: 100,
            )
          ],
        ),
      ),
    );
  }

//request permission
  void requestStoragePermission() async {
    //only if platform is not web
    if (!kIsWeb) {
      //check if not permission status

      bool status = await audioquery.permissionsStatus();
      //request it if not given
      if (!status) {
        await audioquery.permissionsRequest();

        fetchsongs = await audioquery.querySongs();
        for (var element in fetchsongs) {
          if (element.fileExtension == 'mp3') {
            allsongs.add(element);
          }
        }

        for (var element in allsongs) {
          await box.add(Songs(
              songname: element.title,
              duration: element.duration,
              id: element.id,
              songurl: element.uri));
        }
        for (var element in allsongs) {
          mostbox.add(
            MostPlayed(
                songname: element.title,
                songurl: element.uri!,
                duration: element.duration!,
                count: 0,
                id: element.id),
          );
        }
      }
      if (!mounted) return;
      //make sure set state method is called
      setState(() {});
    }
  }
}
