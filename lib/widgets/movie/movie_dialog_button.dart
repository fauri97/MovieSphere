import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/models/movie.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.movie});
  final Movie movie;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final movieController = Get.find<MovieController>();
  bool isLiked = false;
  bool _isPressed =
      false; // Variável para controlar se o botão está pressionado
  double _iconSize = 22.0; // Tamanho inicial do ícone
  String _text = 'Favoritar';
  Color _iconColor = Colors.grey; // Cor inicial do ícone

  @override
  void initState() {
    super.initState();
    verifyIsLiked();
  }

  void _animateButton() {
    setState(
      () {
        _isPressed =
            !_isPressed; // Alterna o estado de pressionado/não pressionado

        if (_isPressed) {
          _iconSize = 26.0; // Novo tamanho do ícone quando pressionado
          _iconColor = Colors.red; // Nova cor do ícone quando pressionado
          movieController.addMyMovie(widget.movie);
          _text = 'Desfavoritar';
        } else {
          _iconSize = 22.0; // Tamanho original do ícone quando não pressionado
          _iconColor =
              Colors.grey; // Cor original do ícone quando não pressionado
          _text = 'Favoritar';
          movieController.removeMyMovie(widget.movie);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animateButton();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _iconSize,
              height: _iconSize,
              child: Icon(
                Icons.favorite,
                color: _iconColor,
              ),
            ),
            const SizedBox(width: 2.0),
            Text(
              _text,
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 22,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verifyIsLiked() {
    if (movieController.myMovieList
        .any((movie) => movie.id == widget.movie.id)) {
      setState(
        () {
          isLiked = true;
          _isPressed = true;
          _iconSize = 26.0; // Novo tamanho do ícone quando pressionado
          _iconColor = Colors.red; // Nova cor do ícone quando pressionado
          _text = "Desfavoritar";
        },
      );
    }
  }
}
