import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicare/src/presentation/controller/registrationcontroller/registrationcontroller.dart';

class YesNoSelector extends StatelessWidget {
  final Registrationcontroller ctrl = Get.find<Registrationcontroller>();

  YesNoSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: ['Yes', 'No'].map((option) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: option,
                groupValue: ctrl.yesNoSelection.value,
                onChanged: (value) {
                  if (value != null) {
                    ctrl.updateWillingness(value);
                  }
                },
              ),
              Text(option),
              const SizedBox(width: 24),
            ],
          );
        }).toList(),
      );
    });
  }
}
