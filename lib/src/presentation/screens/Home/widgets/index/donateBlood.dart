import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/filterwidgets/EmergencyReq.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/filterwidgets/GeneralReq.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/filterwidgets/OwnGroup.dart';

class Donateblood extends StatelessWidget {
  const Donateblood({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();
    var filters = [OwnGroup(), EmergencyReq(), GeNeralReq()];
    return Obx(() {
      if (ctrl.hasErrorinFetchDonor.value == true || ctrl.userGrp.value == '') {
        return SizedBox();
      } else {
        return Column(
          children: [
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
              child: Container(
                height: 37,
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
                            ctrl.donateBloodIndex.value = 0;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              gradient: ctrl.donateBloodIndex.value == 0
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
                            alignment: Alignment.centerLeft,
                            child: Center(
                              child: Text(
                                ctrl.userGrp.value,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: ctrl.donateBloodIndex.value == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ctrl.donateBloodIndex.value = 1;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              gradient: ctrl.donateBloodIndex.value == 1
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
                              "Critical",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: ctrl.donateBloodIndex.value == 1
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
                            ctrl.donateBloodIndex.value = 2;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              gradient: ctrl.donateBloodIndex.value == 2
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
                              "General",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: ctrl.donateBloodIndex.value == 2
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

            const SizedBox(height: 20),
            Obx(() {
              return filters[ctrl.donateBloodIndex.value];
            }),
          ],
        );
      }
    });
  }
}
