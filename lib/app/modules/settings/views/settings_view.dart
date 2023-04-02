import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Theme',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: Obx(() => Text(controller.isDarkModeEnabled.value
                  ? 'Dark Mode'
                  : 'Light Mode')),
              value: controller.isDarkModeEnabled.value,
              onChanged: (value) {
                controller.isDarkModeEnabled.value = value;
                if (controller.isDarkModeEnabled.value) {
                  // Enable Dark Mode
                  // You can use a package like flutter_bloc or provider to manage your app's theme
                  // Here, we are just using the built-in Theme class to switch between light and dark themes
                  Get.changeTheme(ThemeData.dark());
                } else {
                  // Enable Light Mode
                  Get.changeTheme(ThemeData.light());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
