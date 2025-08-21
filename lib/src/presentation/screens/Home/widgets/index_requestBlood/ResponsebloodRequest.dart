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
      return Column(
        children: [
          Bloodrequestwidget(
            endRequest: () {
              log("end Request");
            },
            name: 'Krishna',
            reqCount: 3,
            bloodType: 'AB+',
          ), // handleRequest scenarios
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(left: 12, right: 12),
              itemCount: ctrl.responseDonors.length,
              itemBuilder: (context, index) {
                return BloodInfo1(
                  bloodUnit: 1,
                  infonName: ctrl.responseDonors[index].name,
                  infoLocation: ctrl.responseDonors[index].landmark,
                  contact: () {},
                  infobloodGroup: ctrl.responseDonors[index].bloodType,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 12);
              },
            ),
          ),
        ],
      );
    });
  }
}
