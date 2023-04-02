import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final mailController = TextEditingController();
  final profilePic = "".obs;
  @override
  void onInit() {
    super.onInit();
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      phoneController.text = user.phoneNumber ?? '';
      nameController.text = user.displayName ?? '';
      mailController.text = user.email ?? "";
      profilePic(user.photoURL ?? "");
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

  updateUser() async {
    var user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updateDisplayName(nameController.text);
    } catch (e) {
      Get.snackbar('Username could not update', e.toString());
    }
    try {
      await user.updatePhotoURL("https://example.com/jane-q-user/profile.jpg");
    } catch (e) {
      Get.snackbar('Profile picture could not update', e.toString());
    }
    try {
      await user.updateEmail(mailController.text);
    } catch (e) {
      Get.snackbar('Mail could not update', e.toString());
    }
    try {
      if (user.phoneNumber != phoneController.text) {
        FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneController.text,
          timeout: const Duration(minutes: 2),
          verificationCompleted: (credential) async {
            await (user).updatePhoneNumber(credential);
            // either this occurs or the user needs to manually enter the SMS code
          },
          verificationFailed: (error) {},
          codeSent: (verificationId, [forceResendingToken]) async {
            String smsCode;
            // get the SMS code from the user somehow (probably using a text field)
            final PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: '616263');
            await (user).updatePhoneNumber(credential);
          },
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      }
    } catch (e) {
      Get.snackbar('Phone number could not update', e.toString());
    }

    Get.snackbar('User updated', '');
  }
}
