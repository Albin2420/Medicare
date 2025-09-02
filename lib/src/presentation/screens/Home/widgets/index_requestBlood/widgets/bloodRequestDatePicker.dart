import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';

class BloodRequestDatePicker extends StatelessWidget {
  final bool showPreviousDates;

  const BloodRequestDatePicker({super.key, this.showPreviousDates = false});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();

    return Obx(() {
      final displayDate = ctrl.requestDate.value.isEmpty
          ? "DD/MM/YYYY"
          : ctrl.requestDate.value;

      return GestureDetector(
        onTap: () async {
          final DateTime now = DateTime.now();
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: ctrl.requestDate.value.isEmpty
                ? now
                : DateTime.parse(ctrl.requestDate.value),
            firstDate: showPreviousDates
                ? DateTime(1900)
                : now, // previous dates?
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xff27264D),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xff27264D),
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
            ctrl.requestDate.value = formattedDate;
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xffEBEBEF),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            displayDate,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ),
      );
    });
  }
}
