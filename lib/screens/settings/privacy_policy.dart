import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer2/colors/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
         title:  Text('Privacy Policy',style: GoogleFonts.kanit(),),   
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: rootBundle.loadString('assets/md_files/privacy _policy.md'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                  data: snapshot.data!,
                  styleSheet: MarkdownStyleSheet.fromTheme(
                    ThemeData(
                        textTheme: const TextTheme(
                      bodyText2: TextStyle(fontSize: 18, color: fontcolor),
                    )),
                  ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
