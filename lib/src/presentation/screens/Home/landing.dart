// Landingscreen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/controller/homecontroller/homecontroller.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/index/LandingHome.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/index/donateBlood.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/index/requestBlood.dart';

class Landingscreen extends StatelessWidget {
  const Landingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homecontroller());
    final ctrl = Get.put(Bloodrequestcontroller());
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    final filters = [LandingHome(), Requestblood(), Donateblood()];

    return Obx(() {
      if (!controller.isUiReady.value) {
        return const Scaffold(backgroundColor: Colors.white);
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(width * 0.015),
            child: SizedBox(
              height: height * 0.05,
              width: width * 0.1,
              child: Image.asset("assets/icons/menu.png"),
            ),
          ),
          title: Text(
            "Trahi",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: width * 0.05,
            ),
          ),
          flexibleSpace: Column(
            children: [
              const Spacer(),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Obx(() {
          return filters[controller.currentpageIndex.value];
        }),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff353459), Color(0xff27264D)],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SizedBox(
            height: height * 0.13,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.changePagelan(index: 0);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            scale: 4,
                            controller.currentpageIndex.value == 0
                                ? "assets/icons/home selected.png"
                                : "assets/icons/home unselected.png",
                          ),
                        ),
                        Text(
                          "Home Screen",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, // Regular = 400
                            fontStyle: FontStyle.normal,
                            fontSize: 11.2,
                            height: 1.3, // Line height (130%)
                            letterSpacing: 0, // 0% = 0px
                            color: controller.currentpageIndex.value == 0
                                ? Colors.white
                                : Color(0xff9493A7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.changePagelan(index: 1);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            scale: 4,
                            controller.currentpageIndex.value == 1
                                ? "assets/icons/requestBlood selected.png"
                                : "assets/icons/requestBlood unselected.png",
                          ),
                        ),
                        Text(
                          "Request Blood",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, // Regular = 400
                            fontStyle: FontStyle.normal,
                            fontSize: 11.2,
                            height: 1.3, // Line height (130%)
                            letterSpacing: 0, // 0% = 0px
                            color: controller.currentpageIndex.value == 1
                                ? Colors.white
                                : Color(0xff9493A7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (ctrl.initialized) {
                        ctrl.fetchDonar();
                      }
                      controller.changePagelan(index: 2);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            scale: 4,
                            controller.currentpageIndex.value == 2
                                ? "assets/icons/donateBlood selected.png"
                                : "assets/icons/donateBlood unselected.png",
                          ),
                        ),
                        Text(
                          "Donate Blood",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, // Regular = 400
                            fontStyle: FontStyle.normal,
                            fontSize: 11.2,
                            height: 1.3, // Line height (130%)
                            letterSpacing: 0, // 0% = 0px
                            color: controller.currentpageIndex.value == 2
                                ? Colors.white
                                : Color(0xff9493A7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
