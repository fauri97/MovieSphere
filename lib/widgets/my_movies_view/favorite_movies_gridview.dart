import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/widgets/movie/movie_card.dart';

class FavoriteMoviesListView extends GetWidget<MovieController> {
  const FavoriteMoviesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.myMovieList.isEmpty) {
          return Center(
            child: Text(
              'Sem filmes favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: GoogleFonts.francoisOne().fontFamily,
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          );
        } else {
          return GridView.builder(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemCount: controller.myMovieList.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: controller.myMovieList[index]);
            },
          );
        }
      },
    );
  }
}
