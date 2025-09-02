import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/widgets/Bloodinfo3.dart';

class GeNeralReq extends StatelessWidget {
  const GeNeralReq({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<Bloodrequestcontroller>();
    return Expanded(
      flex: 3,
      child: Obx(() {
        if (ctr.general.isEmpty) {
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

        return ListView.separated(
          itemCount: ctr.general.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: Bloodinfo3(
                bloodGroup: ctr.general[index].bloodType,
                count: ctr.general[index].count,
                dist: ctr.general[index].location,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 4);
          },
        );
      }),
    );
  }
}
