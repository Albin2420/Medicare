import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/widgets/BloodInfo1.dart';

class ResponsebloodRequest extends StatelessWidget {
  const ResponsebloodRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();
    return ListView.separated(
      padding: EdgeInsets.only(left: 12, right: 12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return BloodInfo1(
          bloodUnit: 1,
          infonName: "Alex",
          infoLocation: "kochi,kerala",
          share: () {},
          contact: () {},
          infobloodGroup: "A+",
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 12);
      },
    );
  }
}
