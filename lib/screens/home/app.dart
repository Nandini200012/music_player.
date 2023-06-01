import 'package:flutter/material.dart';
import 'package:musicplayer2/screens/home/home.dart';
import 'package:musicplayer2/screens/library/library.dart';
import 'package:musicplayer2/screens/search/search.dart';
import 'package:musicplayer2/screens/settings/settings.dart';
import 'package:musicplayer2/screens/slider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tabs = const [];
  int currentTabIndex = 0;
 

  // Widget miniplayer(Music? music) {
  //   this.music = music;
  //   setState(() {});
  //   if (music == null) {
  //     return const SizedBox();
  //   }
  //   Size deviceSize = MediaQuery.of(context).size;
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 500),
  //     color: Colors.indigo.shade900,
  //     width: deviceSize.width,
  //     height: 50,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Image.asset(
  //           music.image,
  //           fit: BoxFit.cover,
  //         ),
  //         Text(
  //           music.name,
  //           style: GoogleFonts.cutive(
  //               color: Colors.white, fontSize: 5, fontWeight: FontWeight.w700),
  //         ),
  //         IconButton(
  //           onPressed: () {},
  //           icon: Icon(
  //             Icons.play_circle_fill,
  //             color: Colors.purpleAccent.shade700,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState(); //Home(miniplayer),
    tabs = [const Home(), const Search(), const Library(), const Settings()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      backgroundColor: Colors.black,
      
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // miniplayer(music),
          const NowSlider(),

          //const MiniPlayer2(),
          // _MyHomePageState(),
          BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (index) {
              setState(
                () {
                  currentTabIndex = index;
                },
              );
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black38,
            selectedItemColor: const Color.fromARGB(255, 10, 100, 236),
            unselectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    //color: Colors.white,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    //color: Colors.white,
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.view_week_rounded,
                    //color: Colors.white,
                  ),
                  label: 'Library'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    //color: Colors.white,
                  ),
                  label: 'Settings')
            ],
          ),
        ],
      ),
    );
  }
}
