import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Feche a caixa Hive quando o aplicativo estiver pausado
      Hive.close();
    }
  }
}
