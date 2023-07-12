import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.francoisOne().fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        iconTheme:
            const IconThemeData(size: 30, color: Colors.white, weight: 4),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: const Color.fromARGB(221, 49, 44, 44),
      body: Column(),
    );
  }
}
