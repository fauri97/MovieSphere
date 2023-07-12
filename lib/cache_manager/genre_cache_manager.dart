import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:movie_app/models/genre.dart';

class GenreCache {
  final Box _cacheBox;
  final String _cacheKey = 'genreCache';
  final Duration _cacheDuration = const Duration(days: 10);

  GenreCache(this._cacheBox);

  //Verifica se existe cache
  Future<bool> hasValidCache() async {
    if (_cacheBox.containsKey(_cacheKey)) {
      Map<String, dynamic> jsonData = jsonDecode(_cacheBox.get(_cacheKey));

      DateTime cacheTime = DateTime.parse(jsonData['cacheTime']);
      DateTime expiryTime = cacheTime.add(_cacheDuration);

      return DateTime.now().isBefore(expiryTime);
    }
    await _cacheBox.delete(_cacheKey);
    return false;
  }

  //Carrega os dados do cache
  List<Genres> loadFromCache() {
    if (_cacheBox.containsKey(_cacheKey)) {
      Map<String, dynamic> jsonData = json.decode(_cacheBox.get(_cacheKey));

      var genreListJson = jsonData['genres'] as List<dynamic>;
      return genreListJson
          .map((genreJson) => Genres.fromJson(genreJson))
          .toList();
    }
    return [];
  }

  //Sava os dados no cache
  void saveToCache(List<Genres> genreList) {
    Map<String, dynamic> jsonData = {
      'cacheTime': DateTime.now().toIso8601String(),
      'genres': genreList.map((genre) => genre.toJson()).toList(),
    };
    String cacheData = json.encode(jsonData);

    _cacheBox.put(_cacheKey, cacheData);
  }
}
