import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/app/routes/app_pages.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../../../../utils/preference.dart';

class LoginController extends GetxController {
  final TextEditingController loginController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final codeController = TextEditingController();
  final user = Rxn<User>();
  final loading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  login() async {
    loading(true);
    if (loginController.text.isPhoneNumber) {
      FirebaseAuth auth = FirebaseAuth.instance;

      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(seconds: 30),
        phoneNumber: '+91' + loginController.text,
        forceResendingToken: 1,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          user(userCredential.user!);
          await SharedPreferencesDataProvider().saveUser(user.value!);
          Get.snackbar('Login complete', '');
          Get.offAllNamed(Routes.HOME);
          loading(false);
          // Get.toNamed(Routes.HOME);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar(
                'Login failed', 'The provided phone number is not valid.');
            loading(false);
          }
        },
        codeSent: (verificationId, forceResendingToken) async {
          SmsVerification.startListeningSms().then((sms) {
            if (sms != null) codeController.text = sms.substring(0, 6);
          });

          // Extract the OTP from the SMS message

          // show dialog to take input from the user
          Get.defaultDialog(
            barrierDismissible: false,
            content: Column(
              children: [
                Text("Enter SMS Code"),
                TextField(
                  controller: codeController,
                ),
                ElevatedButton(
                  child: Text("Done"),
                  // textColor: Colors.white,
                  // color: Colors.redAccent,
                  onPressed: () {
                    FirebaseAuth auth = FirebaseAuth.instance;

                    String smsCode = codeController.text;

                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsCode);
                    auth.signInWithCredential(_credential).then((result) async {
                      user(result.user!);
                      await SharedPreferencesDataProvider()
                          .saveUser(user.value!);
                      Get.offAllNamed(Routes.HOME);
                      loading(false);
                    }).catchError((e) {
                      Get.snackbar('Login failed', 'code not valid');
                      loading(false);
                    });
                  },
                )
              ],
            ),
          );
          // content: AlertDialog(
          //     title: Text("Enter SMS Code"),
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         TextField(
          //           controller: codeController,
          //         ),
          //       ],
          //     ),
          //     actions: ));
        },
        // codeSent: (String verificationId, int? resendToken) async {
        //   // Update the UI - wait for the user to enter the SMS code
        //   String smsCode = '616263';

        //   // Create a PhoneAuthCredential with the code
        //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //       verificationId: verificationId, smsCode: smsCode);

        //   // Sign the user in (or link) with the credential
        //   try {
        //     UserCredential userCredential =
        //         await auth.signInWithCredential(credential);
        //     user(userCredential.user!);
        //     await SharedPreferencesDataProvider().saveUser(user.value!);
        //     Get.offAllNamed(Routes.HOME);
        //     loading(false);
        //   } catch (e) {
        //     Get.snackbar('Login failed', 'code not valid');
        //     loading(false);
        //   }
        // },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      Get.snackbar(
          'Invalid Phone Number', 'The phone number you entered is invalid');
      loading(false);
    }
  }
}
