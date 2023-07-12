import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/bindings.dart';
import 'package:movie_app/routes/app_pages.dart';
import 'package:movie_app/routes/app_routes.dart';
import 'package:movie_app/utils/hive_observer.dart';
import 'package:movie_app/views/home.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar Hive
  await path_provider
      .getApplicationDocumentsDirectory()
      .then((dir) => Hive.init(dir.path));

  // Abrir a caixa do Hive
  await Hive.openBox('genre_cache');
  await Hive.openBox('movie_cache');

  WidgetsFlutterBinding.ensureInitialized().addObserver(HiveObserver());

  runApp(OverlaySupport.global(
    child: GetMaterialApp(
      title: 'MovieSphere',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      home: const HomePage(),
      initialRoute: Routes.INITIAL,
      initialBinding: Binding(),
    ),
  ));
}
