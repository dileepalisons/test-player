import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isDarkModeEnabled = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.theme.brightness != Brightness.light) {
      isDarkModeEnabled(true);
    } else {
      isDarkModeEnabled(false);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
