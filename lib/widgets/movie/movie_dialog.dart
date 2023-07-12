import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/controllers/genre_controller.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/utils/language_utils.dart';
import 'movie_dialog_button.dart';

class MovieDialog extends StatefulWidget {
  final Movie movie;
  final File? imageFile;

  const MovieDialog({
    super.key,
    required this.movie,
    required this.imageFile,
  });

  @override
  State<MovieDialog> createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  final genreController = Get.find<GenreController>();
  String genres = '';
  @override
  void initState() {
    super.initState();
    genres = fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    try {
      final dateTime = DateTime.parse(widget.movie.releaseDate!);
      formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      formattedDate = 'Desconhecido';
    }
    return AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              widget.movie.title as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: GoogleFonts.francoisOne().fontFamily,
                  fontSize: 30,
                  color: Colors.amber,
                  fontWeight: FontWeight.w500),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Divider(
                color: Colors.black87,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 94, 90, 90),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.movie.originalTitle != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titulo original: ',
                        style: TextStyle(
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.amber),
                      ),
                      Text(
                        (widget.movie.originalTitle as String),
                        style: TextStyle(
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: const Color.fromARGB(240, 255, 255, 255)),
                      ),
                    ],
                  )
                : const SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Descrição do filme:'.tr,
                style: TextStyle(
                    fontFamily: GoogleFonts.francoisOne().fontFamily,
                    fontSize: 26,
                    color: Colors.amber,
                    fontWeight: FontWeight.w500),
              ),
            ),
            widget.movie.overview != null
                ? Text(
                    (widget.movie.overview as String),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )
                : Text(
                    'Sem Resumo!'.tr,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
            const SizedBox(
              height: 8,
            ),
            widget.imageFile != null
                ? Image.file(
                    widget.imageFile as File,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(
                    height: 1,
                  ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Idioma Original: '.tr,
                  style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                      fontSize: 18),
                ),
                Expanded(
                  child: Text(
                    LanguageUtils.getLanguageName(
                        widget.movie.originalLanguage!),
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Data de Lançamento: '.tr,
                  style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                      fontSize: 18),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 18),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Categorias:'.tr,
                style: TextStyle(
                    fontFamily: GoogleFonts.francoisOne().fontFamily,
                    fontSize: 26,
                    color: Colors.amber,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                genres,
                style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18),
              ),
            )
          ],
        ),
      ),
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FavoriteButton(movie: widget.movie),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Voltar',
                style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontSize: 22,
                    color: Colors.amber),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String fetchGenres() {
    List<int>? genresId = widget.movie.genreIds;
    List<Genres> genreList = genreController.genreList.toList();

    List<String> genreNames = [];

    for (int genreId in genresId ?? []) {
      Genres? genre = genreList.firstWhere((genre) => genre.id == genreId,
          orElse: () => Genres(id: -1, name: 'Desconhecido'));
      genreNames.add(genre.name!);
    }

    String genres = genreNames.join(', ');
    return genres;
  }
}
