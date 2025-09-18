import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';
import 'package:pinput/pinput.dart';
import 'package:medicare/src/presentation/widgets/gradientbutton.dart';

class Otp extends StatelessWidget {
  const Otp({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Registrationcontroller>();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xff353459),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEBEBEF),
        borderRadius: BorderRadius.circular(12),
      ),
    );

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
          "Trahi",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Pinput(
                controller: ctrl.regotpcontroller,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                onCompleted: (pin) {
                  debugPrint('Entered OTP: $pin');
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter the 6-digit OTP sent to your mobile number. Make sure it’s correct.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return ctrl.canResend.value
                    ? TextButton(
                        onPressed: ctrl.sendotp,
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(color: Color(0xFF27264D)),
                        ),
                      )
                    : Text(
                        "Resend OTP in ${ctrl.timer.value} sec",
                        style: const TextStyle(color: Color(0xFF27264D)),
                      );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          BottomAppBar(
            color: Colors.white,
            elevation: 8,
            child: GradientBorderContainer(
              name: 'Submit',
              onTap: () {
                ctrl.submitRegistration();
              },
            ),
          ),
        ],
      ),
    );
  }
}
