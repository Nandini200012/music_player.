import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer2/colors/colors.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: iconcolor,
        ),
        backgroundColor: Colors.transparent,
         title:  Text('Terms And Conditions ',style: GoogleFonts.kanit(),),   
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder(
          future:
              rootBundle.loadString('assets/md_files/terms_and_conditions.md'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.data!,
                styleSheet: MarkdownStyleSheet.fromTheme(
                  ThemeData(
                    textTheme: const TextTheme(
                      bodyText2: TextStyle(fontSize: 18, color: fontcolor),
                    ),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
