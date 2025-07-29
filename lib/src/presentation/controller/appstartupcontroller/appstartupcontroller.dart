import 'dart:developer';

import 'package:get/get.dart';
import 'package:medicare/src/data/repositories/token/tokenRepoImpl.dart';
import 'package:medicare/src/domain/repositories/token/tokenRepo.dart';
import 'package:medicare/src/presentation/screens/Home/landing.dart';
import 'package:medicare/src/presentation/screens/login/login.dart';

import 'package:medicare/src/presentation/screens/registration/userRegistration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Appstartupcontroller extends GetxController {
  final _secureStorage = FlutterSecureStorage();
  final Tokenrepo tokenrepo = Tokenrepoimpl();

  @override
  void onInit() {
    log("appstartup controller");
    super.onInit();
    checktoken();
  }

  Future<void> checktoken() async {
    var tk = await getAccessToken();
    if (tk == null) {
      Get.offAll(() => Login());
    } else {
      // Get.offAll(() => Landingscreen());
      final res = await tokenrepo.checkToken(accesstoken: tk ?? '');
      res.fold(
        (l) {
          Get.offAll(() => Login());
        },
        (r) {
          if (r['expired'] == false) {
            Get.offAll(() => Landingscreen());
          } else {
            Get.offAll(() => Login());
          }
        },
      );
    }
  }

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  Future<void> saveId({required String id}) async {
    log("saveId() :$id");
    await _secureStorage.write(key: 'userId', value: id);
  }

  Future<int> getId() async {
    final userIdString = await _secureStorage.read(key: 'userId');
    return int.parse(userIdString ?? '0');
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: 'access_token');
  }

  Future<void> saveRideId({required String rideId}) async {
    await _secureStorage.write(key: 'rideId', value: rideId);
  }

  Future<int> getRideId() async {
    final rideId = await _secureStorage.read(key: 'rideId');
    return int.parse(rideId ?? '-1');
  }

  Future<void> clearRideId() async {
    await _secureStorage.delete(key: 'rideId');
  }
}
