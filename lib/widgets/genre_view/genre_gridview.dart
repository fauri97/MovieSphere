import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/movie/movie_card.dart';

class GenriMoviesGridView extends StatefulWidget {
  const GenriMoviesGridView({super.key, required this.genre});
  final Genres genre;

  @override
  State<GenriMoviesGridView> createState() => _GenriMoviesGridViewState();
}

class _GenriMoviesGridViewState extends State<GenriMoviesGridView> {
  MovieController movieController = Get.find<MovieController>();
  RxList<Movie> _movies = RxList([]);
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentAfter == 0) {
            updateList();
          }
        }
        return false;
      },
      child: FutureBuilder(
        future: movieController.fetchByGenreMovieList(widget.genre),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            _movies = snapshot.data!;
            return GridView.builder(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
              itemCount: _movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                return MovieCard(movie: _movies[index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> updateList() async {
    RxList<Movie> aux =
        await movieController.addMovieByGenreToList(widget.genre, _movies);
    setState(() {
      _movies = aux;
    });
  }
}
