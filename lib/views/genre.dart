import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/widgets/genre_view/genre_gridview.dart';

class GenrePage extends StatelessWidget {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    Genres genre = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          genre.name ?? 'Erro de categoria',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.francoisOne().fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme:
            const IconThemeData(size: 30, color: Colors.white, weight: 4),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: const Color.fromARGB(221, 49, 44, 44),
      body: GenriMoviesGridView(
        genre: genre,
      ),
    );
  }
}
