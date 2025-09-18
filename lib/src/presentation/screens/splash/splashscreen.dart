import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Appstartupcontroller());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(scale: 5, "assets/logo/trahi logo (2).png"),
      ),
    );
  }
}
