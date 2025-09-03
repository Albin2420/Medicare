import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';

class DatePicker extends StatelessWidget {
  final bool showPreviousDates;

  DatePicker({super.key, this.showPreviousDates = false});

  final Registrationcontroller ctrl = Get.find<Registrationcontroller>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ctrl.dob.value.isEmpty
          ? now
          : DateTime.tryParse(ctrl.dob.value) ?? now,
      firstDate: showPreviousDates ? DateTime(1900) : now,
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
              style: TextButton.styleFrom(foregroundColor: Color(0xff27264D)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      ctrl.dob.value = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => _selectDate(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xffEBEBEF),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            ctrl.dob.value.isEmpty ? "DD/MM/YYYY" : ctrl.dob.value,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ),
      );
    });
  }
}
