import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/widgets/my_movies_view/favorite_movies_gridview.dart';

class MyMoviesPage extends StatelessWidget {
  const MyMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritos',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.francoisOne().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
        backgroundColor: Colors.amber,
        iconTheme:
            const IconThemeData(size: 30, color: Colors.white, weight: 4),
      ),
      body: Container(
        color: const Color.fromARGB(221, 49, 44, 44),
        height: MediaQuery.of(context).size.height,
        child: const FavoriteMoviesListView(),
      ),
    );
  }
}
