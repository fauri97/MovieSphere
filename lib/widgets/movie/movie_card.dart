import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/widgets/movie/movie_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:movie_app/global.dart';
import 'package:movie_app/models/movie.dart';
import 'package:http/http.dart' as http;

class MovieCard extends StatelessWidget {
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _getImageFile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildProgressIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorWidget();
        } else if (snapshot.hasData) {
          final imageFile = snapshot.data!;
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MovieDialog(
                    movie: movie,
                    imageFile: imageFile,
                  );
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return _buildPlaceholderWidget(movie, context);
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: const Color.fromARGB(143, 0, 0, 0)),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: 160,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
      child: const Center(
        child: Icon(Icons.error),
      ),
    );
  }

  Widget _buildPlaceholderWidget(Movie m, BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return MovieDialog(
            movie: movie,
            imageFile: null,
          );
        },
      ),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: const Color.fromARGB(171, 37, 39, 38)),
        child: Center(
          child: Text(
            m.title ?? 'Sem Imagem',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(179, 255, 255, 255),
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Future<File?> _getImageFile() async {
    final cacheDirectory = await getTemporaryDirectory();
    final fileName = movie.posterPath?.split('/').last;

    final cacheImagePath = '${cacheDirectory.path}/$fileName';

    final cacheImageFile = File(cacheImagePath);
    final imageExists = await cacheImageFile.exists();

    if (imageExists) {
      final fileStat = await cacheImageFile.stat();
      final fileModified = fileStat.modified;

      final now = DateTime.now();
      final monthAgo = now.subtract(const Duration(days: 30));

      if (fileModified.isBefore(monthAgo)) {
        await cacheImageFile.delete();
      } else {
        return cacheImageFile;
      }
    }

    final url = 'https://image.tmdb.org/t/p/original${movie.posterPath}';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': API_KEY,
    });

    if (response.statusCode == 200) {
      await cacheImageFile.writeAsBytes(response.bodyBytes);
      return cacheImageFile;
    }

    return null;
  }
}
