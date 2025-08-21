import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:medicare/src/data/models/BRModel1.dart';
import 'package:medicare/src/data/models/BRModel2.dart';

import 'package:medicare/src/data/repositories/bloodDonateRepoImpl/bloodDonateRepoImpl.dart';
import 'package:medicare/src/data/repositories/bloodRequestRepoImpl/bloodRequestRepoImpl.dart';
import 'package:medicare/src/domain/repositories/bloodDonateRepo/bloodDonateRepo.dart';
import 'package:medicare/src/domain/repositories/bloodRequestRepo/bloodRequestRepo.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';

class Bloodrequestcontroller extends GetxController {
  final ctrlr = Get.find<Appstartupcontroller>();
  BloodRequestRepo br = BloodRequestrepoimpl();
  BloodDonateRepo brrepo = BloodDonateRepoImpl();
  RxString accessToken = RxString("");
  RxInt currentIndex = RxInt(0);
  RxInt donateBloodIndex = RxInt(0);
  final responseDonors = <BRModel1>[].obs;

  final bloodRequests = <BRModel2>[].obs;
  //categorzedList
  final aPositive = <BRModel2>[].obs;
  final bPositive = <BRModel2>[].obs;
  final oPositive = <BRModel2>[].obs;
  final aNegative = <BRModel2>[].obs;
  final bNegative = <BRModel2>[].obs;
  final abNegative = <BRModel2>[].obs;
  final oNegative = <BRModel2>[].obs;
  final abPositive = <BRModel2>[].obs;

  RxBool critical = RxBool(false);
  RxString requestDate = RxString('');
  RxString bloodGroup = RxString("");

  TextEditingController noofUnits = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController patienTName = TextEditingController();
  TextEditingController hospitalName = TextEditingController();

  final pageController = PageController();
  RxBool hasErrorinFetchDonor = RxBool(false);
  RxInt bloodFilterIndex = RxInt(0);
  var filterList = ["All", "A+", "B+", "O+", "A-", "B-", "AB-", "O-", "AB+"];

  @override
  void onInit() async {
    super.onInit();
    final token = await ctrlr.getAccessToken();
    accessToken.value = token!;
    fetchDonar();
    log("Bloodrequestcontroller()");
  }

  Future<void> fetchDonar() async {
    try {
      final res = await brrepo.requestBLooddonarList(
        accesstoken: accessToken.value,
      );
      res.fold(
        (l) {
          hasErrorinFetchDonor.value = true;
        },
        (R) {
          aPositive.value = R['A+'];
          bPositive.value = R['B+'];
          abPositive.value = R['AB+'];
          oPositive.value = R['O+'];
          aNegative.value = R['A-'];
          bNegative.value = R['B-'];
          abNegative.value = R['AB-'];
          oNegative.value = R['O-'];
          bloodRequests.value = R['requests'];

          log(
            "A+: ${aPositive.length},B+: ${bPositive.length},AB+ :${abPositive.length},O+ :${oPositive.length},A- :${aNegative.length},B- :${bNegative.length},AB- :${abNegative.length},O- :${oNegative.length}",
          );
          log("total:${bloodRequests.length}");
        },
      );
    } catch (e) {
      log("error in fetchDonar()");
    }
  }

  Future<void> requestBlood() async {
    try {
      EasyLoading.show();
      final res = await br.requestBLood(
        accesstoken: accessToken.value,
        isCritical: critical.value,
        reqstedDate: requestDate.value,
        bloodType: bloodGroup.value,
        noOfunits: int.parse(noofUnits.text),
        contactNumber: contactNumber.text,
        patientName: patienTName.text,
        hospitalName: hospitalName.text,
      );

      res.fold(
        (l) {
          log("failed");
          EasyLoading.dismiss();
        },
        (R) {
          responseDonors.value = R['list_donors'];
          clear();
          Fluttertoast.showToast(
            msg: "Request submitted! We’ll notify you when a donor responds",
          );
          EasyLoading.dismiss();
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      log("error in requestBlood()");
    }
  }

  void clear() {
    try {
      noofUnits.clear();
      contactNumber.clear();
      patienTName.clear();
      hospitalName.clear();
    } catch (e) {
      log("error in clear()");
    }
  }

  void onPagechange({required int index}) {
    try {
      pageController.jumpToPage(index);
      currentIndex.value = index;
    } catch (e) {
      log("Error in onPagechange():$e");
    }
  }
}
