// ignore: depend_on_referenced_packages
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player/app/modules/settings/controllers/settings_controller.dart';
import 'package:player/app/routes/app_pages.dart';
import 'package:player/utils/preference.dart';
import 'package:video_player/video_player.dart';

import 'package:chewie/chewie.dart';

import 'package:get/get.dart';

class HomeController extends GetxController {
  final loading = false.obs;
  final progress = 0.obs;
  final duration = 1.obs;
  final isPlaying = false.obs;
  final sound = 0.obs;
  final downloading = false.obs;
  final user = Rxn<User>().obs;
  final userName = "".obs;
  final userPhone = "".obs;
  final userEmail = "".obs;

  final videoPlayerController = VideoPlayerController.network(
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ).obs;

  final chewieController = Rxn<ChewieController>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();
    setUser();
    secureScreen();
    initialise();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  void setUser() async {
    var prefs = SharedPreferencesDataProvider();
    userName(await prefs.getuserName());
    userEmail(await prefs.getUserEmail());
    userPhone(await prefs.getUserPhone());
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userPhone(user.phoneNumber ?? '');
      userName(user.displayName ?? '');
      userEmail(user.email ?? "");
    }
  }

  void initialise() async {
    loading(true);
    var dir = await getApplicationDocumentsDirectory();

    if (await io.Directory("${dir.path}butterfly.mp4").exists()) {
      videoPlayerController(
        VideoPlayerController.asset(
          "${dir.path}/butterfly.mp4",
        ),
      );
    } else {
      videoPlayerController(VideoPlayerController.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ));
    }
    try {
      await videoPlayerController.value.initialize();
      chewieController(
        ChewieController(
          videoPlayerController: videoPlayerController.value
            ..addListener(() async {
              var a = await videoPlayerController.value.position ??
                  Duration(seconds: 0);
              progress(a!.inSeconds);
              isPlaying(chewieController.value!.isPlaying);
            }),
          autoPlay: true,
          looping: true,
          allowFullScreen: true,
          controlsSafeAreaMinimum: EdgeInsets.zero,
          aspectRatio: 16 / 9,
          showControls: true,
          customControls: Obx(
            () => !chewieController.value!.isFullScreen
                ? SizedBox()
                : Stack(
                    children: [
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => chewieController.value!.isPlaying
                              ? chewieController.value!.videoPlayerController
                                  .pause()
                              : chewieController.value!.videoPlayerController
                                  .play(),
                          child: Obx(
                            () => Icon(
                              isPlaying.value ? Icons.pause : Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            chewieController.value!.exitFullScreen();
                            chewieController.value!.pause();
                          },
                          child: Container(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/fullscreen.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          systemOverlaysOnEnterFullScreen: [
            SystemUiOverlay.bottom,
            SystemUiOverlay.top
          ],

          // overlay: Icon(
          //   Icons.arrow_back,
          //   color: Colors.white,
          // ),
        ),
      );
      sound(chewieController.value!.videoPlayerController.value.volume.toInt());
    } catch (e) {}
    loading(false);
  }

  Future downloadFile(String url) async {
    Dio dio = Dio();
    downloading(true);

    try {
      var dir = await getApplicationDocumentsDirectory();
      var name = url.substring(url.lastIndexOf('/'), url.length);
      if (io.File("${dir.path}${name}").existsSync()) {
        Get.snackbar('Failed', 'File is already downloaded');
      } else {
        await dio.download(url, "${dir.path}${name}",
            onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");
        });
        print("${dir.path}${name}");
        Get.snackbar('Success', 'File downloaded successfully');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Failed', 'failed to download file');
      downloading(false);
    }
    downloading(false);
  }

  checkVideoExists(String url) async {
    loading(true);
    var dir = await getApplicationDocumentsDirectory();
    var name = url.substring(url.lastIndexOf('/'), url.length);
    print("${dir.path}${name}");
    if (await io.File("${dir.path}${name}").existsSync()) {
      videoPlayerController(
        VideoPlayerController.asset(
          "${dir.path}${name}",
        ),
      );
    } else {
      videoPlayerController(
        VideoPlayerController.network(
          url,
        ),
      );
    }
    try {
      await videoPlayerController.value.initialize();
      chewieController(
        ChewieController(
          videoPlayerController: videoPlayerController.value
            ..addListener(() async {
              var a = await videoPlayerController.value.position;
              progress(a!.inSeconds);
              isPlaying(chewieController.value!.isPlaying);
            }),
          autoPlay: true,
          looping: true,
          allowFullScreen: true,
          controlsSafeAreaMinimum: EdgeInsets.zero,
          aspectRatio: 16 / 9,
          showControls: true,
          customControls: Obx(
            () => !chewieController.value!.isFullScreen
                ? SizedBox()
                : Stack(
                    children: [
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => chewieController.value!.isPlaying
                              ? chewieController.value!.videoPlayerController
                                  .pause()
                              : chewieController.value!.videoPlayerController
                                  .play(),
                          child: Obx(
                            () => Icon(
                              isPlaying.value ? Icons.pause : Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            chewieController.value!.exitFullScreen();
                            chewieController.value!.pause();
                          },
                          child: Container(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/fullscreen.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          systemOverlaysOnEnterFullScreen: [
            SystemUiOverlay.bottom,
            SystemUiOverlay.top
          ],

          // overlay: Icon(
          //   Icons.arrow_back,
          //   color: Colors.white,
          // ),
        ),
      );
      sound(chewieController.value!.videoPlayerController.value.volume.toInt());
    } catch (e) {
      videoPlayerController(VideoPlayerController.network(
        url,
      ));
      try {
        await videoPlayerController.value.initialize();
        chewieController(
          ChewieController(
            videoPlayerController: videoPlayerController.value
              ..addListener(() async {
                var a = await videoPlayerController.value.position;
                progress(a!.inSeconds);
                isPlaying(chewieController.value!.isPlaying);
              }),
            autoPlay: true,
            looping: true,
            allowFullScreen: true,
            controlsSafeAreaMinimum: EdgeInsets.zero,
            aspectRatio: 16 / 9,
            showControls: true,
            customControls: Obx(
              () => !chewieController.value!.isFullScreen
                  ? SizedBox()
                  : Stack(
                      children: [
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: () => chewieController.value!.isPlaying
                                ? chewieController.value!.videoPlayerController
                                    .pause()
                                : chewieController.value!.videoPlayerController
                                    .play(),
                            child: Obx(
                              () => Icon(
                                isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              chewieController.value!.exitFullScreen();
                              chewieController.value!.pause();
                            },
                            child: Container(
                              height: 15,
                              width: 15,
                              child: Image.asset(
                                'assets/fullscreen.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            systemOverlaysOnEnterFullScreen: [
              SystemUiOverlay.bottom,
              SystemUiOverlay.top
            ],

            // overlay: Icon(
            //   Icons.arrow_back,
            //   color: Colors.white,
            // ),
          ),
        );
        sound(
            chewieController.value!.videoPlayerController.value.volume.toInt());
      } catch (e) {}
    }
    loading(false);
  }

  void logOut() async {
    await SharedPreferencesDataProvider().clear();
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar('Logging out', '');
  }
}
