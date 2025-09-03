import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';
import 'package:medicare/src/presentation/screens/registration/otp.dart';
import 'package:medicare/src/presentation/screens/registration/widgets/BloodGroupSelector.dart';
import 'package:medicare/src/presentation/screens/registration/widgets/datepicker(dob).dart';
import 'package:medicare/src/presentation/screens/registration/widgets/yesNoselector.dart';

import 'package:medicare/src/presentation/widgets/gradientbutton.dart';

class BloodDonationform extends StatelessWidget {
  const BloodDonationform({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Registrationcontroller>();
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isTablet ? 60 : 40),
                  Center(
                    child: Text(
                      "Blood Donation",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 36 : 30,
                        color: const Color(0xff353459),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 40 : 30),

                  // DOB Label
                  Text(
                    "Date of Birth",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 22 : 18,
                      color: const Color(0xff353459),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // DatePicker
                  DatePicker(showPreviousDates: true),

                  SizedBox(height: isTablet ? 36 : 28),

                  // Blood type label
                  Text(
                    "Your blood type",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 22 : 18,
                      color: const Color(0xff353459),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Blood type selector
                  BloodGroupSelector(),

                  SizedBox(height: isTablet ? 36 : 28),

                  // Donation willingness label
                  Text(
                    "Are you willing to donate blood?",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 22 : 18,
                      color: const Color(0xff353459),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Yes/No selector
                  YesNoSelector(),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: GradientBorderContainer(
          name: "submit",
          onTap: () {
            if (ctrl.dob.value.isEmpty || ctrl.bloodType.value.isEmpty) {
              Fluttertoast.showToast(
                msg: "please fill all the neccessary fields",
              );
              return;
            }

            ctrl.sendotp();
            Get.to(() => const Otp());
          },
        ),
      ),
    );
  }
}
