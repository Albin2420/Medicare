import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';
import 'package:medicare/src/presentation/screens/registration/otp.dart';
import 'package:medicare/src/presentation/widgets/Datepicker.dart';
import 'package:medicare/src/presentation/widgets/bloodGroupselector.dart';

import 'package:medicare/src/presentation/widgets/gradientbutton.dart';
import 'package:medicare/src/presentation/widgets/yesNoselector.dart';

class BloodDonationform extends StatelessWidget {
  const BloodDonationform({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Registrationcontroller>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            height: 50,
            width: 40,
            child: Image.asset("assets/icons/menu.png"),
          ),
        ),
        title: Text(
          "MediCare",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                "Blood Donation",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: const Color(0xff353459),
                ),
              ),
            ),
            SizedBox(height: 38),

            Row(
              children: [
                Text(
                  "Date of Birth",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: const Color(0xff353459),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            DatePicker(
              onDateSelected: (String dobDate) {
                log("date:$dobDate");
                ctrl.dob.value = dobDate;
              },
              showPreviousDates: true,
            ),

            SizedBox(height: 32),
            Row(
              children: [
                Text(
                  "your blood type",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: const Color(0xff353459),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BloodGroupSelector(
              onChanged: (String? p1) {
                ctrl.bloodType.value = p1!;
              },
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Text(
                  "Are you willing to donate blood?",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: const Color(0xff353459),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                YesNoSelector(
                  onChanged: (bool? p2) {
                    ctrl.isReadytoDonate.value = p2!;
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: GradientBorderContainer(
          name: "submit",
          onTap: () {
            // ctrl.submitRegistration();
            ctrl.sendotp();
            Get.to(() => Otp());
          },
        ),
      ),
    );
  }
}
