import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';

class Filterchip extends StatelessWidget {
  final int selectedIndex;
  final String label;
  const Filterchip({
    super.key,
    required this.selectedIndex,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();
    return Obx(() {
      return Container(
        width: 46,
        height: 37,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff010029)),
          color: ctrl.bloodFilterIndex.value == selectedIndex
              ? Color(0xff27264D)
              : Color(0xffEBEBEF),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ctrl.bloodFilterIndex.value == selectedIndex
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}
