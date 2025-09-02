import 'dart:developer';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Makephonecall {
  Future<void> makePhoneCallservice({required String phoneNumber}) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      log("error:$e");
    }
  }
}
