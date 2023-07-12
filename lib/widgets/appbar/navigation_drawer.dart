import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/controllers/genre_controller.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/routes/app_routes.dart';

class CustomNavigationDrawer extends GetWidget<GenreController> {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Drawer(
        child: Container(
          color: const Color.fromARGB(255, 240, 214, 67),
          child: SafeArea(
            child: Column(
              children: [
                Text(
                  'Categorias',
                  style: TextStyle(
                    fontFamily: GoogleFonts.francoisOne().fontFamily,
                    fontSize: 36,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.genreList.length,
                    itemBuilder: (context, index) {
                      return buildMenuItem(context,
                          categoria: controller.genreList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black87,
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.ABOUT);
                  },
                  child: Text(
                    'Sobre',
                    style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildMenuItem(BuildContext context, {required Genres categoria}) {
    const color = Colors.black;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        selectedColor: const Color.fromARGB(129, 158, 158, 158),
        title: Text(
          categoria.name ?? 'Erro ao carregar',
          style: TextStyle(
            fontFamily: GoogleFonts.lato().fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.GENRES, arguments: categoria);
        },
      ),
    );
  }
}
