import 'package:chewie/chewie.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:player/app/modules/settings/controllers/settings_controller.dart';
import 'package:player/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final _controller = Get.find<HomeController>();
  final _settingsController = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          key: _controller.scaffoldKey,
          backgroundColor: _settingsController.isDarkModeEnabled.value
              ? Color.fromARGB(255, 36, 14, 11)
              : const Color.fromARGB(241, 255, 255, 255),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  // ignore: sort_child_properties_last
                  child: Stack(
                    children: [
                      Positioned(
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius(
                            cornerRadius: 10,
                            cornerSmoothing: 1,
                          ),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/person.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 60,
                        child: Obx(() => Text(_controller.userPhone.value)),
                      ),
                      Positioned(
                        top: 10,
                        left: 60,
                        child: Obx(() => Text(_controller.userName.value)),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                ),
                ListTile(
                  title: const Text('Profile'),
                  onTap: () => Get.toNamed(Routes.PROFILE),
                ),
                ListTile(
                  title: const Text('Settings'),
                  onTap: () => Get.toNamed(Routes.SETTINGS),
                ),
                ListTile(
                  title: const Text('Log out'),
                  onTap: controller.logOut,
                ),
              ],
            ),
          ),
          // drawer: Container(
          //   height: MediaQuery.of(context).size.height,
          //   width: 100,
          //   color: Colors.white,
          // ),
          body: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    child: Obx(
                      () => _controller.chewieController.value == null
                          ? const SizedBox()
                          : _controller.loading.value ||
                                  !_controller.chewieController.value!
                                      .videoPlayerController.value.isInitialized
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 30,
                                        height: 30,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3,
                                        )),
                                  ],
                                )
                              : Chewie(
                                  controller:
                                      _controller.chewieController.value!,
                                ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        _controller.openDrawer();
                        // _controller.logOut();
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          'assets/menu.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      child: ClipSmoothRect(
                        radius: SmoothBorderRadius(
                          cornerRadius: 10,
                          cornerSmoothing: 1,
                        ),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/person.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.black45,
                            Colors.black38,
                            Colors.black26,
                            Colors.black12,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _controller.chewieController.value!.isPlaying
                                  ? _controller.chewieController.value!
                                      .videoPlayerController
                                      .pause()
                                  : _controller.chewieController.value!
                                      .videoPlayerController
                                      .play(),
                          child: Obx(
                            () => Icon(
                              _controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 46,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.72,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 3.0,
                                      trackShape:
                                          const RectangularSliderTrackShape(),
                                      activeTrackColor: const Color(0xff57EE9D),
                                      inactiveTrackColor:
                                          const Color(0xff525252),
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6.0,
                                        pressedElevation: 3.0,
                                      ),
                                      thumbColor: const Color(0xff57EE9D),
                                      overlayColor: const Color.fromARGB(
                                          41, 87, 238, 157),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 0.0),
                                      showValueIndicator:
                                          ShowValueIndicator.never,
                                      activeTickMarkColor: Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      valueIndicatorColor: Colors.black,
                                    ),
                                    child: Obx(
                                      () => _controller
                                                  .chewieController.value ==
                                              null
                                          ? const SizedBox()
                                          : !_controller
                                                  .chewieController
                                                  .value!
                                                  .videoPlayerController
                                                  .value
                                                  .isInitialized
                                              ? const SizedBox()
                                              : Slider(
                                                  min: 0.0,
                                                  max: 1,
                                                  value: _controller.progress /
                                                      _controller
                                                          .chewieController
                                                          .value!
                                                          .videoPlayerController
                                                          .value
                                                          .duration
                                                          .inSeconds,
                                                  onChanged: (value) {
                                                    _controller
                                                        .chewieController
                                                        .value!
                                                        .videoPlayerController
                                                        .seekTo(Duration(
                                                            seconds:
                                                                value.toInt()));
                                                    // _value = value;
                                                  },
                                                ),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => _controller.progress != -1
                                      ? _controller.chewieController.value ==
                                              null
                                          ? const SizedBox()
                                          : !_controller
                                                  .chewieController
                                                  .value!
                                                  .videoPlayerController
                                                  .value
                                                  .isInitialized
                                              ? const SizedBox()
                                              : Text(
                                                  _controller
                                                          .chewieController
                                                          .value!
                                                          .videoPlayerController
                                                          .value
                                                          .position
                                                          .toString()
                                                          .substring(2, 7) +
                                                      '/' +
                                                      (_controller
                                                          .chewieController
                                                          .value!
                                                          .videoPlayerController
                                                          .value
                                                          .duration
                                                          .toString()
                                                          .substring(2, 7)),
                                                  style: GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                  )),
                                                )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _controller.chewieController.value!
                                        .videoPlayerController
                                        .seekTo(const Duration(seconds: 0));
                                  },
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    child: Image.asset(
                                      'assets/backward.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _controller.chewieController.value!
                                        .videoPlayerController
                                        .seekTo(Duration(
                                            seconds: _controller
                                                .chewieController
                                                .value!
                                                .videoPlayerController
                                                .value
                                                .duration
                                                .inSeconds));
                                  },
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    child: Image.asset(
                                      'assets/forward.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _controller.sound(
                                        _controller.sound.value == 0 ? 1 : 0);
                                    _controller.chewieController.value!
                                        .setVolume(
                                            _controller.sound.value.toDouble());
                                  },
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    child: Obx(
                                      () => Image.asset(
                                        _controller.sound.value == 0
                                            ? 'assets/mute.png'
                                            : 'assets/sound.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    child: Image.asset(
                                      'assets/settings.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _controller.chewieController.value!
                                        .enterFullScreen();
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
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: _controller.loading.value
                              ? null
                              : () {
                                  _controller.checkVideoExists(
                                      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4');
                                },
                          child: ClipSmoothRect(
                            radius: SmoothBorderRadius(
                              cornerRadius: 10,
                              cornerSmoothing: 1,
                            ),
                            child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/left_arrow.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => _controller.downloading.value
                            ? const CircularProgressIndicator()
                            : Obx(
                                () => GestureDetector(
                                  onTap: _controller.loading.value
                                      ? null
                                      : () {
                                          _controller.downloadFile(_controller
                                              .chewieController
                                              .value!
                                              .videoPlayerController
                                              .dataSource);
                                        },
                                  child: ClipSmoothRect(
                                    radius: SmoothBorderRadius(
                                      cornerRadius: 10,
                                      cornerSmoothing: 1,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 35,
                                      color: Colors.white,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'assets/download.png',
                                                fit: BoxFit.cover,
                                                // height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Obx(
                                              () => Text(
                                                'Download',
                                                style: GoogleFonts.poppins(
                                                  color: _settingsController
                                                          .isDarkModeEnabled
                                                          .value
                                                      ? Colors.black
                                                      : Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      Obx(
                        () => GestureDetector(
                          onTap: _controller.loading.value
                              ? null
                              : () {
                                  _controller.checkVideoExists(
                                      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4');
                                },
                          child: ClipSmoothRect(
                            radius: SmoothBorderRadius(
                              cornerRadius: 10,
                              cornerSmoothing: 1,
                            ),
                            child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/right_arrow.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
