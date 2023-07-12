import 'package:get/get.dart';
import 'package:movie_app/controllers/genre_controller.dart';
import 'package:movie_app/controllers/movie_controller.dart';

class Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenreController>(() => GenreController());
    Get.lazyPut<MovieController>(() => MovieController());
  }
}
