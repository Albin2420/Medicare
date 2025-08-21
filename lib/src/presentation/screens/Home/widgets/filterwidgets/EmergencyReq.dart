import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/widgets/BloodInfo2.dart';

class EmergencyReq extends StatelessWidget {
  const EmergencyReq({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<Bloodrequestcontroller>();
    return Expanded(
      flex: 3,
      child: Obx(() {
        if (ctr.bloodRequests.isEmpty) {
          return Center(
            child: Text(
              "No donors available right now.\nPlease check again later",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.5,
                letterSpacing: 0,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: BloodInfo2(
                infonName: "Alex",
                infobloodUnit: 3,
                infoLocation: 'GSM medical college kottayam',
                infoRequiredDate: "23-05-2025",
                oncontact: () {
                  log("contact:${ctr.bloodRequests[index].mobile}");
                },
                infobloodGroup: "AB-",
              ),
            );
          },
        );
      }),
    );
  }
}
