import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/index_requestBlood/RequestbloodForm.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/index_requestBlood/ResponsebloodRequest.dart';

class Requestblood extends StatelessWidget {
  const Requestblood({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xffEBEBEF),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ctrl.onPagechange(index: 0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(48),
                                gradient: ctrl.currentIndex.value == 0
                                    ? LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF51507F),
                                          Color(0xFF27264D),
                                        ],
                                        stops: [0.0209, 1.044],
                                        transform: GradientRotation(
                                          90.83 * (3.14159265359 / 180),
                                        ),
                                      )
                                    : null,
                              ),
                              padding: EdgeInsets.only(
                                left: 22,
                                top: 10,
                                bottom: 10,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Request Blood",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: ctrl.currentIndex.value == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ctrl.onPagechange(index: 1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(48),
                                gradient: ctrl.currentIndex.value == 1
                                    ? LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF51507F),
                                          Color(0xFF27264D),
                                        ],
                                        stops: [0.0209, 1.044],
                                        transform: GradientRotation(
                                          90.83 * (3.14159265359 / 180),
                                        ),
                                      )
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Responses",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: ctrl.currentIndex.value == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              SizedBox(height: 20),

              Expanded(
                child: PageView(
                  controller: ctrl.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [RequestBloodForm(), ResponsebloodRequest()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
