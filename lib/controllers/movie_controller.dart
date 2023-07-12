import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/cache_manager/movie_cache_manager.dart';
import 'package:movie_app/controllers/genre_controller.dart';
import 'package:movie_app/global.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/models/movie.dart';
import 'package:http/http.dart' as http;

class MovieController extends GetxController {
  RxList<Movie> popularMovieList = RxList<Movie>([]);
  RxList<Movie> upcomingMoviesList = RxList<Movie>([]);
  RxList<Movie> onCinemaList = RxList<Movie>([]);
  RxList<Movie> myMovieList = RxList<Movie>([]);
  final MovieCache movieCache = MovieCache(Hive.box('movie_cache'));
  RxBool isLoading = false.obs;
  final genreController = Get.find<GenreController>();

  @override
  void onInit() {
    super.onInit();
    fetchData(false);
    fetchMyMovies();
  }

  //Fetch per genre
  Future<RxList<Movie>> fetchByGenreMovieList(Genres genre) async {
    RxList<Movie> movieList = RxList<Movie>([]);
    List<Uri> uriMovieList = [];
    if (await movieCache.hasValidCache(genre.name!)) {
      movieList.value = await movieCache.loadFromCache(genre.name!);
    } else {
      uriMovieList.add(
        Uri.parse(
            'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=pt-BR&page=1&region=BR&sort_by=popularity.desc&with_genres=${genre.id}'),
      );
      for (var uri in uriMovieList) {
        var response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Authorization': API_KEY,
        });

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var movieListJson = data['results'] as List<dynamic>;
          movieList.addAll(
            movieListJson.map((movieJson) => Movie.fromJson(movieJson)),
          );
          movieCache.saveToCacheWithPage(genre.name!, '1', movieList);
        } else {
          throw Exception('Failed to fetch data');
        }
      }
    }
    return movieList;
  }

  Future<RxList<Movie>> addMovieByGenreToList(
      Genres genre, RxList<Movie> targetList) async {
    RxList<Movie> newList = targetList;
    if (await movieCache.hasValidCache(genre.name!)) {
      newList.value = await movieCache.loadFromCache(genre.name!);
      int page =
          int.parse(await movieCache.getPageFromGenreMovie(genre.name!)) + 1;
      Uri uri = Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=pt-BR&page=$page&region=BR&sort_by=popularity.desc&with_genres=${genre.id}');
      var response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': API_KEY,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var movieListJson = data['results'] as List<dynamic>;
        newList.addAll(
          movieListJson.map((movieJson) => Movie.fromJson(movieJson)),
        );
        await movieCache.deleteCache(genre.name!);
        movieCache.saveToCacheWithPage(genre.name!, (page).toString(), newList);
      } else {
        throw Exception('Failed to fetch data');
      }
    }

    return newList;
  }

  //Favorites
  void addMyMovie(Movie newMovie) {
    bool isMovieAdded = myMovieList.any((movie) => movie.id == newMovie.id);

    if (!isMovieAdded) {
      myMovieList.add(newMovie);
      movieCache.saveToCache('my_movies', myMovieList);
    }
  }

  void removeMyMovie(Movie m) {
    bool isMovieAdded = myMovieList.any((movie) => movie.id == m.id);
    if (isMovieAdded) {
      myMovieList.remove(m);
      movieCache.deleteMovieFromCache('my_movies', m.id!);
    }
  }

  Future<void> fetchMyMovies() async {
    myMovieList.value = await movieCache.loadFromCache('my_movies');
  }

  //HomePage fetch
  Future<void> fetchData(bool ignorarCache) async {
    try {
      List<Uri> uriPopularMovieList = [
        Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?language=pt-BR&page=1&region=BR'),
        Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?language=pt-BR&page=2&region=BR'),
        Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?language=pt-BR&page=3&region=BR'),
      ];

      List<Uri> uriUpComingMovies = [
        Uri.parse(
            'https://api.themoviedb.org/3/movie/upcoming?language=pt-BR&page=1&region=BR'),
        Uri.parse(
            'https://api.themoviedb.org/3/movie/upcoming?language=pt-BR&page=2&region=BR'),
        Uri.parse(
            'https://api.themoviedb.org/3/movie/upcoming?language=pt-BR&page=3&region=BR'),
      ];

      List<Uri> uriOnCinema = [
        Uri.parse(
            'https://api.themoviedb.org/3/movie/now_playing?language=pt-BR&page=1&region=BR'),
        Uri.parse(
            'https://api.themoviedb.org/3/movie/now_playing?language=pt-BR&page=2&region=BR'),
        Uri.parse(
            'https://api.themoviedb.org/3/movie/now_playing?language=pt-BR&page=3&region=BR'),
      ];
      isLoading.value = true;
      await fetchMovies(uriPopularMovieList, popularMovieList, 'popular_movies',
          ignorarCache);
      await fetchMovies(uriUpComingMovies, upcomingMoviesList,
          'upcoming_movies', ignorarCache);
      await fetchMovies(
          uriOnCinema, onCinemaList, 'oncinema_movies', ignorarCache);

      isLoading.value = false;
    } catch (e) {
      Get.snackbar(
        'Erro'.tr,
        'Falha ao obter a lista de Filmes'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> fetchMovies(List<Uri> uris, RxList<Movie> targetList,
      String cacheName, bool ignoreCache) async {
    //Verifica se é para ignorar o cache
    if (!ignoreCache) {
      //Verifica se o cache é valido
      if (await movieCache.hasValidCache(cacheName)) {
        targetList.value = await movieCache.loadFromCache(cacheName);
        return;
      }
    }
    //deleta dados do cache
    else {
      movieCache.deleteCache(cacheName);
      targetList.clear();
    }
    for (var uri in uris) {
      var response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': API_KEY,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var movieListJson = data['results'] as List<dynamic>;
        targetList.addAll(
          movieListJson.map((movieJson) => Movie.fromJson(movieJson)),
        );
        movieCache.saveToCache(cacheName, targetList);
      } else {
        throw Exception('Failed to fetch data');
      }
    }
  }

  //fetch by query
  Future<List<Movie>> getMoviesByQuery(String query) async {
    List<Movie> movies = [];
    List<Uri> uris = [
      Uri.parse(
          'https://api.themoviedb.org/3/search/movie?query=$query&include_adult=false&language=pt-BR&page=1'),
      Uri.parse(
          'https://api.themoviedb.org/3/search/movie?query=$query&include_adult=false&language=pt-BR&page=2'),
    ];
    for (var uri in uris) {
      var response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': API_KEY,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var movieListJson = data['results'] as List<dynamic>;
        movies.addAll(
          movieListJson.map((movieJson) => Movie.fromJson(movieJson)),
        );
      } else {
        throw Exception('Failed to fetch data');
      }
    }
    return movies;
  }
}
