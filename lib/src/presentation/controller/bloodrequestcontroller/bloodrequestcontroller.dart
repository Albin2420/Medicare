import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bloodrequestcontroller extends GetxController {
  RxInt currentIndex = RxInt(0);
  final pageController = PageController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    log("Bloodrequestcontroller()");
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
