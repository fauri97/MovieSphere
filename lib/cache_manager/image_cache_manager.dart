import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import '../global.dart';

class ImageCacheManager {
  static const String _cacheDirectoryName = 'image_cache';

  Future<ImageProvider?> getImageProvider(String imageUrl) async {
    final cachePath = await _getCachePath();
    final fileName = path.basename(imageUrl);
    final filePath = '$cachePath/$fileName';

    // Verifica se a imagem está em cache
    final cacheFile = File(filePath);
    if (cacheFile.existsSync()) {
      return FileImage(cacheFile);
    }

    final imageBytes = await _downloadImageBytes(imageUrl);

    if (imageBytes != null) {
      // Salva a imagem no cache
      await cacheFile.create(recursive: true);
      await cacheFile.writeAsBytes(imageBytes);
      return FileImage(cacheFile);
    }

    return null;
  }

  Future<List<int>?> _downloadImageBytes(String imageUrl) async {
    final response = await http.get(
      Uri.parse(imageUrl),
      headers: {
        'Authorization': API_KEY,
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    return null;
  }

  Future<String> _getCachePath() async {
    final directory = await getTemporaryDirectory();
    final cachePath = path.join(directory.path, _cacheDirectoryName);

    // Cria o diretório de cache se não existir
    final cacheDirectory = Directory(cachePath);
    if (!cacheDirectory.existsSync()) {
      await cacheDirectory.create(recursive: true);
    }

    return cachePath;
  }
}
