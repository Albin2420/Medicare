import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        return const Center(
          child: Text(
            'No active requests or donor responses found.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
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
                    // Add your contact logic here if needed
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
