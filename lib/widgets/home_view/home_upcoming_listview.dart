import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/widgets/movie/movie_card.dart';

class UpcomingListView extends GetWidget<MovieController> {
  const UpcomingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: controller.upcomingMoviesList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MovieCard(
                  movie: controller.upcomingMoviesList[index],
                ),
              );
            },
          );
        }
      },
    );
  }
}
