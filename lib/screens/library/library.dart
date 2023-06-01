import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer2/screens/home/home.dart';
import 'package:musicplayer2/screens/library/favourite/favourite.dart';
import 'package:musicplayer2/screens/library/recent_played/recently_played_screen.dart';
import 'package:musicplayer2/screens/library/mostlyplayed/mostly_played_screen.dart';
import 'package:musicplayer2/screens/library/playlist/Playlist/playlist.dart';
import 'package:musicplayer2/widgets/appbar.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        appBar: AppBar(elevation: 0.0,
        backgroundColor: Colors.indigoAccent.shade400,
        title:  Text('Library',style: GoogleFonts.kanit(),),    
         leading:  IconButton(onPressed: () =>  Navigator.of(context)
                .push(MaterialPageRoute(builder: (contex)=>const Home())),
           icon:const Icon(Icons.arrow_back))),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
            
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              const SizedBox(
                height: 15,
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 10.0),
              //       child: Text(
              //         'Your PLaylists',
              //         style: GoogleFonts.cuprum(
              //             color: Colors.white54,
              //             fontSize: 18,
              //             fontWeight: FontWeight.w700),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 3,
              ),
              libraryList(),
              ListTile(
                onTap: () {
                  //createshowbottomsheet(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>  const PlaylistScreen()));
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 40,
                    width: 50,
                    color: Colors.black,
                    child: const Icon(
                      Icons.playlist_add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                title: Text(
                  'Playlist',
                  style: GoogleFonts.cuprum(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Divider(
                height: 5,
                indent: 66.0,
                endIndent: 26.0,
                color: Colors.indigoAccent.shade700,
              )
              //createGrid(),
              //const Gridlist()
            ],
          ),
        ),
      ),
    );
  }
}

List<String> libraryTitle = [
  'Favorites',
  'Most Played',
  'Recently played',
  //'Playlist'
];
List<IconData> libraryIcon = const [
  (Icons.favorite),
  (Icons.sync),
  (Icons.create_new_folder),
  //(Icons.playlist_add)
];
List libtab = [
  const FavoriteScreen(),
  const MostlyPlayedScreen(),
  const RecentlyPlayedScreen(),
 // const Downloads()
];

Widget libraryList() {
  return SizedBox(
    height: 190,
    child: ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: libraryTitle.length+1 ,
      separatorBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => libtab[index]));
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 50,
              width: 50,
              //Colors.indigoAccent--old color theme
              color: Colors.black,
              child: Icon(
                libraryIcon[index],
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          title: Text(
            libraryTitle[index],
            style: GoogleFonts.cuprum(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return Divider(
          height: 5,
          indent: 66.0,
          endIndent: 26.0,
          color: Colors.indigoAccent.shade700,
        );
      },
    ),
  );
}
