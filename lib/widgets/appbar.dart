import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget createAppBar(String message) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    leading: const IconBtn(),
    // Padding(
    //     padding: EdgeInsets.only(right: 12.0), child: Icon(Icons.settings))

    title: Text(
      message,
      style: GoogleFonts.kanit(),
    ),
    // ignore: prefer_const_literals_to_create_immutables
  );
}

class IconBtn extends StatelessWidget {
  const IconBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const BackButtonIcon(),
    );
  }
}
