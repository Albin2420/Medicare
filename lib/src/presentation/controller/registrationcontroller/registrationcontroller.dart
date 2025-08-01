import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:medicare/src/data/repositories/login/loginrepoImpl.dart';
import 'package:medicare/src/data/repositories/registration/userRegistrationRepoImpl.dart';
import 'package:medicare/src/domain/repositories/login/loginrepo.dart';
import 'package:medicare/src/domain/repositories/registration/userRegistrationRepo.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';
import 'package:medicare/src/presentation/screens/Home/landing.dart';
import 'package:medicare/src/presentation/screens/registration/otp.dart';
import 'package:medicare/src/presentation/screens/registration/userRegistration.dart';

class Registrationcontroller extends GetxController {
  final ctrl = Get.find<Appstartupcontroller>();
  TextEditingController firstNamecontroller = TextEditingController();
  TextEditingController secondNamecontroller = TextEditingController();
  TextEditingController phoneNumbercontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();

  //login
  TextEditingController phncontrolller = TextEditingController();
  TextEditingController oTpcontrolller = TextEditingController();

  UserRegistrationRepo userRepo = UserRegistrationRepoImpl();
  Loginrepo loginrepo = Loginrepoimpl();

  void checkName() {
    if (firstNamecontroller.text.length >= 3) {
      Get.to(() => Otp());
    }
  }

  void sendotp() {
    Fluttertoast.showToast(
      msg: "We've sent an OTP to your number. Please check your messages",
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void submitRegistration() async {
    try {
      if (otpcontroller.text == "807456" && !EasyLoading.isShow) {
        EasyLoading.show();
        final resp = await userRepo.saveStudent(
          frstName: firstNamecontroller.text,
          secondName: secondNamecontroller.text,
          phoneNumber: phoneNumbercontroller.text,
        );

        resp.fold(
          (l) {
            EasyLoading.dismiss();
            Fluttertoast.showToast(msg: "unable to register");
          },
          (r) {
            ctrl.saveAccessToken(r['access_token']);
            ctrl.saveId(id: r['userId'].toString());
            EasyLoading.dismiss();
            Get.offAll(() => Landingscreen());
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      log("error in submitRegistration():$e");
    }
  }

  Future<void> login() async {
    try {
      if (oTpcontrolller.text == "807456" && !EasyLoading.isShow) {
        EasyLoading.show();
        final response = await loginrepo.login(
          phoneNumber: phncontrolller.text,
        );
        response.fold(
          (l) {
            Fluttertoast.showToast(
              msg:
                  "Looks like your account couldn’t be found. Try again or contact support.",
            );
            EasyLoading.dismiss();
            log("failed");
          },
          (R) {
            ctrl.saveAccessToken(R['access_token']);
            ctrl.saveId(id: R['userId'].toString());
            EasyLoading.dismiss();
            Get.offAll(() => Landingscreen());
          },
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "error in login():$e");
      EasyLoading.dismiss();
      log("error in login():$e");
    }
  }
}
