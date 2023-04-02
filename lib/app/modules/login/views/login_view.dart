import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final _controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.loginController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   child: TextFormField(
              //     controller: _controller.loginController,
              //     maxLength: 10,
              //     decoration: const InputDecoration(
              //       hintText: 'Enter Mobile Number',
              //       isDense: true,
              //       contentPadding: EdgeInsets.all(5),
              //       counterText: '',
              //     ),
              //     keyboardType: TextInputType.number,
              //   ),
              // ),
              SizedBox(
                height: 25,
              ),
              Obx(
                () => controller.loading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _controller.login();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 16.0,
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
              )
              // GestureDetector(
              //   onTap: () {
              //     _controller.login();
              //   },
              //   child: Container(
              //     height: 35,
              //     width: MediaQuery.of(context).size.width * 0.3,
              //     decoration: BoxDecoration(
              //       color: const Color.fromARGB(255, 44, 132, 47),
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(
              //           5,
              //         ),
              //       ),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Login',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 13,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
