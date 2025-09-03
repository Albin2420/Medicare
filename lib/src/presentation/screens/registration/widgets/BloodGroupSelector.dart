import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';

class BloodGroupSelector extends StatelessWidget {
  final Registrationcontroller ctrl = Get.find<Registrationcontroller>();

  BloodGroupSelector({super.key});

  final List<String> bloodGroups = const [
    'O+',
    'A+',
    'B+',
    'AB+',
    'O-',
    'A-',
    'B-',
    'AB-',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 20,
        runSpacing: 5,
        children: bloodGroups.map((group) {
          return SizedBox(
            width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: group,
                  groupValue: ctrl.bloodType.value,
                  onChanged: (value) {
                    if (value != null) {
                      ctrl.bloodType.value = value;
                    }
                  },
                ),
                Text(
                  group,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
