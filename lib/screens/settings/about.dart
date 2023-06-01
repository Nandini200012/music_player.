import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer2/colors/colors.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: iconcolor,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'About Us',
          style: GoogleFonts.kanit(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 10),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 15),
                    child: about(),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//about us
Widget about() {
  return Text(
    '''
About Us : 

We are a team of passionate music lovers who have come together to create a better music listening experience for you. Our app is designed to make it easy for you to discover new music, create personalized playlists, and enjoy your favorite tracks anytime, anywhere.

We believe in the power of music to bring people together, and we strive to create a welcoming and inclusive community for music fans of all kinds. We are constantly working to improve the app and add new features to enhance your listening experience.

Thank you for choosing Musify as your go-to music player. We hope you enjoy using it as much as we enjoyed creating it. If you have any feedback or suggestions, we would love to hear from you. Contact us at nandhininatarajan04@gmail.com.

''',
    style: GoogleFonts.raleway(
      textStyle: const TextStyle(
          letterSpacing: .5,
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: fontcolor),
    ),
  );
}
