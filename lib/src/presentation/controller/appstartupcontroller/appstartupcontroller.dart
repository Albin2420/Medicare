import 'dart:developer';

import 'package:get/get.dart';
import 'package:medicare/src/data/repositories/token/tokenRepoImpl.dart';
import 'package:medicare/src/domain/repositories/token/tokenRepo.dart';
import 'package:medicare/src/presentation/screens/Home/landing.dart';
import 'package:medicare/src/presentation/screens/login/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Appstartupcontroller extends GetxController {
  final _secureStorage = const FlutterSecureStorage();
  final Tokenrepo tokenrepo = Tokenrepoimpl();

  @override
  void onInit() {
    log("appstartup controller");
    super.onInit();
    checktoken();
    getFcmToken();
  }

  Future<void> checktoken() async {
    final tk = await getAccessToken();

    if (tk == null) {
      Get.offAll(() => Login());
      return;
    }

    final res = await tokenrepo.checkToken(accesstoken: tk);
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

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  Future<void> saveId({required String id}) async {
    log("saveId() :$id");
    await _secureStorage.write(key: 'userId', value: id);
  }

  Future<int> getId() async {
    final userIdString = await _secureStorage.read(key: 'userId');
    return int.tryParse(userIdString ?? '0') ?? 0;
  }

  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: 'access_token');
    } catch (e) {
      log("Secure storage error (getAccessToken): $e");
      await _secureStorage.deleteAll(); // clear corrupted data
      return null;
    }
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: 'access_token');
  }

  Future<void> saveRideId({required String rideId}) async {
    await _secureStorage.write(key: 'rideId', value: rideId);
  }

  Future<int> getRideId() async {
    final rideId = await _secureStorage.read(key: 'rideId');
    return int.tryParse(rideId ?? '-1') ?? -1;
  }

  Future<void> clearRideId() async {
    await _secureStorage.delete(key: 'rideId');
  }

  void getFcmToken() async {
    try {
      log("🔄 Requesting permission...");
      await FirebaseMessaging.instance.requestPermission();

      log("🔄 Checking if FCM is supported...");
      final isSupported = await FirebaseMessaging.instance.isSupported();
      log("✅ FCM Supported: $isSupported");

      log("🔄 Getting FCM token...");
      String? token = await FirebaseMessaging.instance.getToken();
      log("✅ FCM Token: $token");
    } catch (e) {
      log("❌  error in getFcmToken():$e");
    }
  }
}
