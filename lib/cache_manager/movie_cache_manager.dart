import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:movie_app/models/movie.dart';

class MovieCache {
  final Box<dynamic> _cacheBox;
  final String _cacheKeyPrefix = 'movieCache_';
  final Duration _cacheDuration = const Duration(days: 1);

  MovieCache(this._cacheBox);

  //Verify if has cache
  Future<bool> hasValidCache(String cacheKey) async {
    final String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    if (_cacheBox.containsKey(cacheKeyWithPrefix)) {
      final Map<String, dynamic> jsonData =
          jsonDecode(_cacheBox.get(cacheKeyWithPrefix));

      final DateTime cacheTime = DateTime.parse(jsonData['cacheTime']);
      final DateTime expiryTime = cacheTime.add(_cacheDuration);

      return DateTime.now().isBefore(expiryTime);
    }
    await _cacheBox.delete(cacheKeyWithPrefix);
    return false;
  }

  //Get cache
  Future<List<Movie>> loadFromCache(String cacheKey) async {
    final String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    if (_cacheBox.containsKey(cacheKeyWithPrefix)) {
      final Map<String, dynamic> jsonData =
          jsonDecode(_cacheBox.get(cacheKeyWithPrefix));

      final List<dynamic> movieListJson = jsonData['movies'];
      return movieListJson
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
    }
    return [];
  }

  //get page from cache
  Future<String> getPageFromGenreMovie(String cacheKey) async {
    String page = '';
    final String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    if (_cacheBox.containsKey(cacheKeyWithPrefix)) {
      final Map<String, dynamic> jsonData =
          jsonDecode(_cacheBox.get(cacheKeyWithPrefix));
      page = jsonData['page'];
    }
    return page;
  }

  //save cache
  void saveToCache(String cacheKey, List<Movie> movieList) {
    final String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    final Map<String, dynamic> jsonData = {
      'cacheTime': DateTime.now().toIso8601String(),
      'movies': movieList.map((movie) => movie.toJson()).toList(),
    };
    final String cacheData = jsonEncode(jsonData);

    _cacheBox.put(cacheKeyWithPrefix, cacheData);
  }

  void saveToCacheWithPage(
      String cacheKey, String page, List<Movie> movieList) {
    final String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    final Map<String, dynamic> jsonData = {
      'cacheTime': DateTime.now().toIso8601String(),
      'page': page,
      'movies': movieList.map((movie) => movie.toJson()).toList(),
    };
    final String cacheData = jsonEncode(jsonData);

    _cacheBox.put(cacheKeyWithPrefix, cacheData);
  }

  //Delete cache
  Future<void> deleteCache(String cacheKey) async {
    final String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    await _cacheBox.delete(cacheKeyWithPrefix);
  }

  Future<void> deleteMovieFromCache(String cacheKey, int movieId) async {
    String cacheKeyWithPrefix = _cacheKeyPrefix + cacheKey;
    String? cacheData = _cacheBox.get(cacheKeyWithPrefix);
    if (cacheData != null) {
      Map<String, dynamic> jsonData = jsonDecode(cacheData);
      List<Movie> movieList = (jsonData['movies'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();

      // 2. Encontrar o filme com o ID correspondente e removê-lo da lista
      movieList.removeWhere((movie) => movie.id! == movieId);

      // 3. Salvar a lista atualizada de volta no cache
      jsonData['movies'] = movieList.map((movie) => movie.toJson()).toList();
      String updatedCacheData = jsonEncode(jsonData);
      _cacheBox.put(cacheKeyWithPrefix, updatedCacheData);
    }
  }
}
