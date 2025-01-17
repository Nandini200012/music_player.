import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer2/colors/colors.dart';
import 'package:musicplayer2/functions/addplaylist.dart';
import 'package:musicplayer2/models/playlistmodel.dart';
import 'package:musicplayer2/models/songmodel.dart';
import 'package:musicplayer2/style/style.dart';

bool textformVisibility = false;

class HomePlaylistButton extends StatelessWidget {
  int songindex;
  HomePlaylistButton({
    Key? key,
    required this.songindex,
  }) : super(key: key);
  TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        playlistBottomSheet(context);
      },
      icon: const Icon(Icons.playlist_add),
      color: Colors.white,
      // color: isDarkMode ? whiteClr : blackClr,
      splashRadius: 20,
    );
  }

  Future<dynamic> playlistBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(0)),
            ),
            child: ValueListenableBuilder<Box<PlaylistSongs>>(
              valueListenable: playlistbox.listenable(),
              builder: (context, Box<PlaylistSongs> playlistbox, _) {
                List<PlaylistSongs> playlist = playlistbox.values.toList();

                if (playlistbox.isEmpty) {
                  return const IfNoPlaylist();
                }
                return Column(
                  children: [
                    height10,
                    Text(
                      'Playlist',
                      style: TextStyle(fontSize: 22,color: whiteClr),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: playlist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.headphones_rounded,
                              color: whiteClr,
                            ),
                            title: Text(
                              playlist[index].playlistname!,
                              style: TextStyle(fontSize: 18,color: whiteClr),
                            ),
                            onTap: () {
                              PlaylistSongs? plsongs = playlistbox.getAt(index);
                              List<Songs>? plnewsongs = plsongs!.playlistssongs;
                              Box<Songs> box = Hive.box('Songs');
                              List<Songs> dbAllsongs = box.values.toList();
                              bool isAlreadyAdded = plnewsongs!.any((element) =>
                                  element.id == dbAllsongs[songindex].id);

                              if (!isAlreadyAdded) {
                                plnewsongs.add(
                                  Songs(
                                    songname: dbAllsongs[songindex].songname,                     
                                    duration: dbAllsongs[songindex].duration,
                                    songurl: dbAllsongs[songindex].songurl,
                                    id: dbAllsongs[songindex].id,
                                  ),
                                );

                                playlistbox.putAt(
                                    index,
                                    PlaylistSongs(
                                        playlistname:
                                            playlist[index].playlistname,
                                        playlistssongs: plnewsongs),);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: selectedItemColor,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                        '${dbAllsongs[songindex].songname}Added to ${playlist[index].playlistname}')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: selectedItemColor,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                        '${dbAllsongs[songindex].songname} is already added')));
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class IfNoPlaylist extends StatefulWidget {
  const IfNoPlaylist({
    Key? key,
  }) : super(key: key);

  @override
  State<IfNoPlaylist> createState() => _IfNoPlaylistState();
}

class _IfNoPlaylistState extends State<IfNoPlaylist> {

  TextEditingController textcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colordark,
      appBar:AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom+10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textformVisibility ? 'Create Playlist' : 'No Playlists',
                style: TextStyle(fontSize: 22,color: whiteClr),
              ),
              Visibility(
                visible: textformVisibility,
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    style: const TextStyle(color: colordark,fontSize: 18),
                    autofocus: true,
                    controller: textcontroller,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      hintText: 'Playlist name',
                      hintStyle: text18,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      fillColor: whiteClr,
                      filled: true,
                    ),
                    validator: (value) {
                      List<PlaylistSongs> values = playlistbox.values.toList();
                
                      bool isAlreadyAdded = values
                          .where((element) => element.playlistname == value!.trim())
                          .isNotEmpty;
                
                      if (value!.trim() == '') {
                        return 'Name Required';
                      }
                      if (isAlreadyAdded) {
                        return 'This Name Already Exist';
                      }
                      return null;
                      
                    },
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    elevation: 1,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(10)),
                onPressed: () {
                  textformVisibility == false
                      ? setState(() {
                          textformVisibility = true;
                        })
                      : addPlaylist();
                },
                icon: const Icon(Icons.add),
                label: Text(
                  'Create Playlist',
                  style: text18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addPlaylist() async{
    if(formkey.currentState!.validate()){
       playlistbox.add(
        PlaylistSongs(playlistname: textcontroller.text, playlistssongs: []));
        setState(() {
      textformVisibility = false;
    });
    } 
    // Navigator.pop(context); 
  }
}
