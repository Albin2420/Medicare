import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:medicare/src/data/models/BRModel1.dart';
import 'package:medicare/src/data/models/BRModel2.dart';
import 'package:medicare/src/data/models/BRModel3.dart';
import 'package:medicare/src/data/models/BRModel4.dart';
import 'package:medicare/src/data/repositories/acceptdonors/acceptdonorsrepoimpl.dart';

import 'package:medicare/src/data/repositories/bloodDonateRepoImpl/bloodDonateRepoImpl.dart';
import 'package:medicare/src/data/repositories/bloodRequestRepoImpl/bloodRequestRepoImpl.dart';
import 'package:medicare/src/data/repositories/endmyreqrepo/endmyreqrepoimpl.dart';
import 'package:medicare/src/data/repositories/isthereanyreq/isthereanyreqrepoImpl.dart';
import 'package:medicare/src/data/services/makecall/makephonecall.dart';
import 'package:medicare/src/domain/repositories/acceptdonors/acceptdonorsrepo.dart';
import 'package:medicare/src/domain/repositories/bloodDonateRepo/bloodDonateRepo.dart';
import 'package:medicare/src/domain/repositories/bloodRequestRepo/bloodRequestRepo.dart';
import 'package:medicare/src/domain/repositories/endmyreq/endmyreqrepo.dart';
import 'package:medicare/src/domain/repositories/isthereanyreq/isthereanyreqrepo.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';

class Bloodrequestcontroller extends GetxController {
  final ctrlr = Get.find<Appstartupcontroller>();
  BloodRequestRepo br = BloodRequestrepoimpl();
  BloodDonateRepo brrepo = BloodDonateRepoImpl();
  RxString accessToken = RxString("");
  RxInt currentIndex = RxInt(0);
  RxInt donateBloodIndex = RxInt(0);
  final responseDonors = <BRModel1>[].obs;
  final activereq = <BRModel4>[].obs;
  final bloodRequests = <BRModel2>[].obs;
  var general = <BRModel3>[].obs;
  var criticalRequest = <BRModel2>[].obs;
  var matchingRequests = <BRModel2>[].obs;
  RxBool critical = RxBool(false);
  RxString requestDate = RxString('');
  RxString bloodGroup = RxString("");
  TextEditingController noofUnits = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController patienTName = TextEditingController();
  TextEditingController hospitalName = TextEditingController();
  RxString district = RxString("");
  RxString userGrp = RxString("");
  RxBool hasErrorinFetchDonor = RxBool(false);
  RxInt bloodFilterIndex = RxInt(0);
  RxBool isBloodRequested = RxBool(false);
  Isthereanyreqrepo isthereanyreq = Isthereanyrepoimpl();
  Endmyreqrepo endmyreq = Endmyreqrepoimpl();
  Acceptdonorsrepo accept = Acceptdonorsrepoimpl();
  var dist = <String>[].obs;
  var currentHospital = <String>[].obs;
  final callHelper = Makephonecall();

  @override
  void onInit() async {
    super.onInit();
    final token = await ctrlr.getAccessToken();
    accessToken.value = token!;
    dist.value = ctrlr.dist;
    hasAnyRequests();
    fetchDonar();
    log("initialize Bloodrequestcontroller()");
  }

  Future<void> hasAnyRequests() async {
    try {
      final res = await isthereanyreq.isthereAnyReq(
        accesstoken: accessToken.value,
      );
      res.fold((l) {}, (R) {
        // isBloodRequested set true if active req;
        activereq.value = R['active_blood_requests'];
        responseDonors.value = R['acceptedusers'];
      });
    } catch (e) {
      log("error in hasAnyRequests:$e");
    }
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    try {
      callHelper.makePhoneCallservice(phoneNumber: phoneNumber);
    } catch (e) {
      log("error:$e");
    }
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
          userGrp.value = R['user_blood_type'];
          criticalRequest.value = R['criticalRequest'];
          matchingRequests.value = R['matching_requests'];
          general.value = R['general'];
          hasErrorinFetchDonor.value = false;
        },
      );
    } catch (e) {
      log("error in fetchDonar():$e");
      hasErrorinFetchDonor.value = true;
    }
  }

  void filterHospital({required String district}) {
    try {
      hospitalName.clear();
      currentHospital.value = ctrlr.filterHospitals(district: district);
    } catch (e) {
      log("error in filterHospital():$e");
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
        district: district.value,
      );

      res.fold(
        (l) {
          log("failed");
          EasyLoading.dismiss();
        },
        (R) {
          isBloodRequested.value = true;
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
      if (index == 1) {
        hasAnyRequests();
      }
      currentIndex.value = index;
    } catch (e) {
      log("Error in onPagechange():$e");
    }
  }

  Future<void> acceptReqownGroup({required int id}) async {
    try {
      EasyLoading.show();
      final res = await accept.acceptReq(
        accesstoken: accessToken.value,
        id: id,
      );
      res.fold(
        (l) {
          if (l.message == "You already accepted this request") {
            Fluttertoast.showToast(msg: "You already accepted this request");
            clearAcceptedcasesownGroup(id: id);
          }
          EasyLoading.dismiss();
        },
        (R) {
          EasyLoading.dismiss();
          clearAcceptedcasesownGroup(id: id);
        },
      );
    } catch (e) {
      log("error in acceptReq():$e");
    }
  }

  Future<void> clearAcceptedcasesownGroup({required int id}) async {
    try {
      matchingRequests.removeWhere((request) => request.bloodRequestId == id);
    } catch (e) {
      log("error in clearAcceptedcases():$e");
    }
  }

  Future<void> acceptReqcriticalGroup({required int id}) async {
    try {
      EasyLoading.show();
      final res = await accept.acceptReq(
        accesstoken: accessToken.value,
        id: id,
      );
      res.fold(
        (l) {
          if (l.message == "You already accepted this request") {
            Fluttertoast.showToast(msg: "You already accepted this request");
            clearAcceptedcriticalGroup(id: id);
          }
          EasyLoading.dismiss();
        },
        (R) {
          EasyLoading.dismiss();
          clearAcceptedcriticalGroup(id: id);
        },
      );
    } catch (e) {
      log("error in acceptReq():$e");
    }
  }

  Future<void> clearAcceptedcriticalGroup({required int id}) async {
    try {
      criticalRequest.removeWhere((request) => request.bloodRequestId == id);
    } catch (e) {
      log("error in clearAcceptedcases():$e");
    }
  }

  Future<void> endRequest({required int reqId}) async {
    try {
      EasyLoading.show();
      final res = await endmyreq.endMyReq(
        accesstoken: accessToken.value,
        reqId: reqId,
      );
      res.fold(
        (l) {
          EasyLoading.dismiss();
        },
        (R) {
          hasAnyRequests();
          EasyLoading.dismiss();
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      log("❌ error in endRequest():$e");
    }
  }
}
