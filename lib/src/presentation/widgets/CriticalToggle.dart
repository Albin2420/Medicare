import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';

class CriticalToggle extends StatelessWidget {
  const CriticalToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();

    return Obx(
      () => Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1, color: Colors.red),
        ),
        padding: const EdgeInsets.only(left: 20, right: 10, top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Critical",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                height: 1.3,
                letterSpacing: 0.0,
                color: Colors.red,
              ),
            ),
            Switch(
              value: ctrl.critical.value,
              onChanged: (val) => ctrl.critical.value = val,
              activeThumbColor: const Color(0xffE55555),
              thumbColor: WidgetStateProperty.all<Color>(Colors.red),
              inactiveThumbColor: const Color(0xffE55555),
              inactiveTrackColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
