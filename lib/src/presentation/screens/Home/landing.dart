import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/homecontroller/Homecontroller.dart';
import 'package:medicare/src/presentation/screens/Home/home.dart';

class Landingscreen extends StatelessWidget {
  const Landingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homecontroller());
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

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
          "MediCare",
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
      body: Column(
        children: [
          SizedBox(height: height * 0.1),
          Center(
            child: Text(
              "Do you require\nMedical assistance?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: width * 0.07,
                color: const Color(0xff353459),
              ),
            ),
          ),
          SizedBox(height: height * 0.04),
          Text(
            "Tap the button to request an ambulance.",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: width * 0.04,
              color: const Color(0xff747474),
            ),
          ),
          SizedBox(height: height * 0.05),
          GestureDetector(
            onTap: () {
              // Get.to(() => Home());
              if (controller.lat.value != 0.0 && controller.long.value != 0.0) {
                if (!EasyLoading.isShow) {
                  controller.registerEmergency();
                }
              } else {
                controller.startListeningToLocation();
              }
            },
            child: SizedBox(
              height: width * 0.7,
              width: width * 0.7,
              child: Image.asset("assets/icons/Frame 109.png"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return controller.location.value != "initial"
            ? Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff353459), Color(0xff27264D)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: width * 0.06,
                            width: width * 0.06,
                            child: Image.asset("assets/icons/location.png"),
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            "Current Location",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    const Divider(color: Colors.white70, thickness: 0.5),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        width * 0.1,
                        height * 0.025,
                        width * 0.1,
                        height * 0.025,
                      ),
                      child: Text(
                        controller.location.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: width * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff353459), Color(0xff27264D)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: width * 0.06,
                            width: width * 0.06,
                            child: Image.asset("assets/icons/Location.png"),
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            "Current Location",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    const Divider(color: Colors.white70, thickness: 0.5),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        width * 0.1,
                        height * 0.025,
                        width * 0.1,
                        height * 0.025,
                      ),
                      child: Text(
                        "Please turn on location services to continue.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: width * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
