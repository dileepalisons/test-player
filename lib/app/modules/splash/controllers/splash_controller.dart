import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:player/app/routes/app_pages.dart';
import 'package:player/utils/preference.dart';

import '../../settings/controllers/settings_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    checkScreen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkScreen() async {
    try {
      SharedPreferencesDataProvider().getUserId().then((value) {
        if (value == null || value == 'user_id') {
          Get.offAllNamed(Routes.LOGIN);
        } else {
          Get.offAllNamed(
            Routes.HOME,
          );
        }
      });
    } catch (e) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
