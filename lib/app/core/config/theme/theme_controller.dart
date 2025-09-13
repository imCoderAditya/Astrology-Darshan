import 'package:get/get.dart';
import 'theme_service.dart';

class ThemeController extends GetxController {
  final ThemeService _themeService = ThemeService();
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    isDarkMode.value = _themeService.isDarkMode();
    super.onInit();
  }

  void toggleTheme() {
    _themeService.switchTheme();
    isDarkMode.value = _themeService.isDarkMode();
  }
}
