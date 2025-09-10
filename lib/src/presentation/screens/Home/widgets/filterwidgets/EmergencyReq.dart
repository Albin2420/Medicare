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
        if (ctr.criticalRequest.isEmpty) {
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
          itemCount: ctr.criticalRequest.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: BloodInfo2(
                infonName: ctr.criticalRequest[index].patientName,
                infobloodUnit: ctr.criticalRequest[index].noOfUnits,
                infoLocation: ctr.criticalRequest[index].hospital,
                infoRequiredDate: ctr.criticalRequest[index].requiredDate
                    .toString(),
                accept: () {
                  ctr.acceptReqcriticalGroup(
                    id: ctr.criticalRequest[index].bloodRequestId,
                  );
                },
                infobloodGroup: ctr.criticalRequest[index].bloodType,
              ),
            );
          },
        );
      }),
    );
  }
}
