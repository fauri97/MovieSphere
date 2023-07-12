import 'package:get/get.dart';
import 'package:movie_app/routes/app_routes.dart';
import 'package:movie_app/views/about.dart';
import 'package:movie_app/views/genre.dart';
import 'package:movie_app/views/home.dart';
import 'package:movie_app/views/my_movies.dart';
import 'package:movie_app/views/search.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.INITIAL, page: () => const HomePage()),
    GetPage(name: Routes.MYMOVIES, page: () => const MyMoviesPage()),
    GetPage(name: Routes.GENRES, page: () => const GenrePage()),
    GetPage(name: Routes.SEARCH, page: () => const SearchPage()),
    GetPage(name: Routes.ABOUT, page: () => const AboutPage()),
  ];
}
