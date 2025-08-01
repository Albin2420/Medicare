// screens are use in this folder

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';
import 'package:medicare/src/presentation/screens/registration/otp.dart';
import 'package:medicare/src/presentation/widgets/gradientbutton.dart';

class UserRegistration extends StatelessWidget {
  const UserRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Registrationcontroller>();
    // Check if keyboard is visible
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Title Section
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                        height: isKeyboardVisible ? 120 : 180,
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 350),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: isKeyboardVisible ? 24 : 30,
                              color: const Color(0xff353459),
                            ),
                            child: const Text("User Registration"),
                          ),
                        ),
                      ),

                      // Form Section
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              // First Name
                              Text(
                                "First Name",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: const Color(0xff353459),
                                ),
                              ),
                              const SizedBox(height: 8),

                              TextField(
                                controller: ctrl.firstNamecontroller,
                                decoration: InputDecoration(
                                  hintText: "Enter First Name",
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffEBEBEF),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 36),

                              // Last Name
                              Text(
                                "Last Name",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: const Color(0xff353459),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: ctrl.secondNamecontroller,
                                decoration: InputDecoration(
                                  hintText: "Enter Last Name",
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffEBEBEF),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 36),

                              SizedBox(height: isKeyboardVisible ? 40 : 60),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: isKeyboardVisible
          ? const SizedBox.shrink()
          : BottomAppBar(
              color: Colors.white,
              elevation: 8,
              child: GradientBorderContainer(
                name: 'Submit',
                onTap: () {
                  ctrl.checkName();
                },
              ),
            ),
    );
  }
}

























//old ui;





// // screens are use in this folder

// import 'dart:developer';

// import 'package:app/src/presentation/widgets/gradientbutton.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UserRegistration extends StatelessWidget {
//   const UserRegistration({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         leading: Padding(
//           padding: EdgeInsetsGeometry.all(6),
//           child: SizedBox(
//             height: 50,
//             width: 40,
//             child: Image.asset("assets/icons/menu.png"),
//           ),
//         ),
//         title: Text(
//           "App Name",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20),
//         ),
//         flexibleSpace: Column(
//           children: [
//             const Spacer(), // This pushes the container to the bottom
//             Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(
//                       0.2,
//                     ), // Shadow color with opacity
//                     offset: const Offset(
//                       0,
//                       1,
//                     ), // Horizontal and Vertical offset
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   color: Colors.white,
//                   child: Center(
//                     child: Text(
//                       "User Registration",
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 30,
//                         color: Color(0xff353459),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsetsGeometry.only(left: 25),
//                         child: Row(
//                           children: [
//                             Text(
//                               "First Name",
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 20,
//                                 color: Color(0xff353459),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 25, right: 25),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText:
//                                 "Enter First Name", // Fixed typo from "Nmae"
//                             hintStyle: TextStyle(color: Colors.black54),
//                             filled: true,
//                             fillColor: Color(0xffEBEBEF),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 14,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: BorderSide.none, // No border line
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 36),
//                       Padding(
//                         padding: EdgeInsetsGeometry.only(left: 25),
//                         child: Row(
//                           children: [
//                             Text(
//                               "Last Name",
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 20,
//                                 color: Color(0xff353459),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 25, right: 25),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText:
//                                 "Enter Last Name", // Fixed typo from "Nmae"
//                             hintStyle: TextStyle(color: Colors.black54),
//                             filled: true,
//                             fillColor: Color(0xffEBEBEF),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 14,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: BorderSide.none, // No border line
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 36),
//                       Padding(
//                         padding: EdgeInsetsGeometry.only(left: 25),
//                         child: Row(
//                           children: [
//                             Text(
//                               "Phone Number",
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 20,
//                                 color: Color(0xff353459),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 25, right: 25),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText:
//                                 "Enter Phne Number", // Fixed typo from "Nmae"
//                             hintStyle: TextStyle(color: Colors.black54),
//                             filled: true,
//                             fillColor: Color(0xffEBEBEF),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 14,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: BorderSide.none, // No border line
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   color: Colors.white,
//                   child: Center(
//                     child: GradientBorderContainer(
//                       name: 'Submit',
//                       onTap: () {
//                         log("message");
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
