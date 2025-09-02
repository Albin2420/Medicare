import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/index_requestBlood/widgets/bloodRequestwidget.dart';
import 'package:medicare/src/presentation/widgets/BloodInfo1.dart';

class ResponsebloodRequest extends StatelessWidget {
  const ResponsebloodRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();

    return Obx(() {
      final isActiveReqEmpty = ctrl.activereq.isEmpty;
      final isResponseDonorsEmpty = ctrl.responseDonors.isEmpty;

      if (isActiveReqEmpty && isResponseDonorsEmpty) {
        return Center(
          child: Text(
            'No active requests or donor found.',
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

      return ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Active Requests Section
          ...List.generate(ctrl.activereq.length, (index) {
            return Column(
              children: [
                Bloodrequestwidget(
                  endRequest: () {
                    ctrl.endRequest(reqId: ctrl.activereq[index].id);
                  },
                  name: ctrl.activereq[index].patientName,
                  reqCount: ctrl.activereq[index].noOfUnits,
                  bloodType: ctrl.activereq[index].bloodType,
                ),
                const SizedBox(height: 10),
              ],
            );
          }),

          const SizedBox(height: 12),

          // Donor Responses Section
          ...List.generate(ctrl.responseDonors.length, (index) {
            final donor = ctrl.responseDonors[index];
            return Column(
              children: [
                BloodInfo1(
                  infonName: donor.name,
                  infoLocation: donor.landmark,
                  contact: () {
                    log("hey");
                    ctrl.makePhoneCall(phoneNumber: donor.mobile);
                  },
                  infobloodGroup: donor.bloodType,
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      );
    });
  }
}
