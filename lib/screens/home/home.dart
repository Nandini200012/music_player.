// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/screens/home/widget/FullSOngWidget.dart';
import 'package:musicplayer2/widgets/appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  // Function miniPlayerHome;
  final box = SongBox.getInstance();

  //const Home({super.key});
  @override
  Widget build(BuildContext context) {
    List<Songs> dbsongs = box.values.toList();
    double vheight=MediaQuery.of(context).size.height;
    double vwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height:vheight,
              width: vwidth,
                decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.indigoAccent.shade400,
              Color.fromARGB(255, 0, 5, 34),
              Colors.black,
              Colors.black,
              Colors.black,          
              Colors.black,
              Colors.black,
              Colors.black
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),               
                child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              createAppBar('Home'),
              SizedBox(
                height: 6,
              ),
              Row(children: [
                Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'All Songs',
                  style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.play_arrow,
              //   color: Colors.white,
              //   size: 35,)
              // )
              ],),
              AllSongsWidget()
              
            ],
                ),
              ),
          ),
        ));
  }
}

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 100, 100);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}

//final OnAudioQuery _audioQuery = OnAudioQuery();







