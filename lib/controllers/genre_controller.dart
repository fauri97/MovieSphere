import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/global.dart';
import 'package:movie_app/models/genre.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/cache_manager/genre_cache_manager.dart';

class GenreController extends GetxController {
  RxList<Genres> genreList = RxList<Genres>([]);
  final GenreCache _genreCache = GenreCache(Hive.box('genre_cache'));

  @override
  void onInit() {
    super.onInit();
    fetchGenres();
  }

  void fetchGenres() async {
    // Verifica se há um cache válido dos gêneros
    bool hasValidCache = await _genreCache.hasValidCache();
    if (hasValidCache) {
      // Se houver um cache válido, carrega os gêneros do cache
      genreList.addAll(_genreCache.loadFromCache());

      return;
    }

    // Caso não haja um cache válido, faz a requisição à API para buscar os gêneros
    Uri uri =
        Uri.parse('https://api.themoviedb.org/3/genre/movie/list?language=pt');
    var response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': API_KEY
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      var genreListJson = jsonResponse['genres'] as List<dynamic>;

      // Adiciona os gêneros à lista genreList
      genreList
          .addAll(genreListJson.map((genreJson) => Genres.fromJson(genreJson)));

      // Salva os gêneros no cache
      _genreCache.saveToCache(genreList);
    } else {
      // Exibe uma mensagem de erro caso a requisição à API falhe
      Get.snackbar(
        'Erro',
        'Falha ao obter a lista de Categorias',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
