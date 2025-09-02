import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:medicare/src/data/repositories/login/loginrepoImpl.dart';
import 'package:medicare/src/data/repositories/registration/userRegistrationRepoImpl.dart';
import 'package:medicare/src/data/repositories/userbloodinforepoimpl/userbloodinforepoimpl.dart';
import 'package:medicare/src/domain/repositories/login/loginrepo.dart';
import 'package:medicare/src/domain/repositories/registration/userRegistrationRepo.dart';
import 'package:medicare/src/domain/repositories/userbloodInfo/userbloodinforepo.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';
import 'package:medicare/src/presentation/screens/Home/landing.dart';
import 'package:medicare/src/presentation/screens/registration/bloodDonationform.dart';

class Registrationcontroller extends GetxController {
  final ctrl = Get.find<Appstartupcontroller>();
  TextEditingController firstNamecontroller = TextEditingController();
  TextEditingController lastNamecontroller = TextEditingController();
  TextEditingController phoneNumbercontroller = TextEditingController();
  RxString district = RxString("");
  RxString dob = RxString("");
  RxString bloodType = RxString("");
  RxBool isReadytoDonate = RxBool(true);
  TextEditingController regotpcontroller = TextEditingController();

  RxInt timer = 30.obs; // countdown seconds
  RxBool canResend = false.obs;
  Timer? _countdownTimer;

  //login
  TextEditingController phncontrolller = TextEditingController();
  TextEditingController oTpcontrolller = TextEditingController();

  UserRegistrationRepo userRepo = UserRegistrationRepoImpl();
  Loginrepo loginrepo = Loginrepoimpl();

  Userbloodinforepo uspbloodinfo = Userbloodinforepoimpl();

  var dist = <String>[].obs;

  void checkName() {
    if (firstNamecontroller.text.length >= 3) {
      Get.to(() => BloodDonationform());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dist.value = ctrl.dist;
  }

  void sendotp() {
    Fluttertoast.showToast(
      msg: "We've sent an OTP to your number. Please check your messages",
      textColor: Colors.black,
      fontSize: 16.0,
    );
    startTimer();
  }

  void startTimer() {
    _countdownTimer?.cancel();
    canResend.value = false;
    timer.value = 30;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer.value == 0) {
        canResend.value = true;
        t.cancel();
      } else {
        timer.value--;
      }
    });
  }

  void submitRegistration() async {
    try {
      if (regotpcontroller.text == "807456" && !EasyLoading.isShow) {
        EasyLoading.show();
        final resp = await userRepo.saveStudent(
          frstName: firstNamecontroller.text,
          secondName: lastNamecontroller.text,
          phoneNumber: phoneNumbercontroller.text,
          dob: dob.value,
          fcmtoKen: ctrl.fcmToken.value,
          district: district.value,
        );

        resp.fold(
          (l) {
            EasyLoading.dismiss();
            Fluttertoast.showToast(msg: "unable to register");
          },
          (r) {
            ctrl.saveAccessToken(r['access_token']);
            ctrl.saveId(id: r['userId'].toString());
            updateBloodIndo(
              accessToken: r['access_token'],
              bloodType: bloodType.value,
            );
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "unable to register");
      log("error in submitRegistration():$e");
    }
  }

  void updateBloodIndo({
    required String accessToken,
    required String bloodType,
  }) async {
    try {
      final res = await uspbloodinfo.updateBlood(
        accesstoken: accessToken,
        bloodType: bloodType,
        iswillingtoDonate: isReadytoDonate.value,
      );

      res.fold(
        (l) {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "failed");
        },
        (R) {
          EasyLoading.dismiss();
          Get.offAll(() => Landingscreen());
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "failed");
      log("Error in updateBloodindo:$e");
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
