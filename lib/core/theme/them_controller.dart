import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  bool _loadTheme() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _loadTheme();
  void saveTheme(bool isDarkMode) => _box.write(_key, isDarkMode);

  void toggelTheme() {
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
      saveTheme(!_loadTheme());
      update();
    });
  }
}
