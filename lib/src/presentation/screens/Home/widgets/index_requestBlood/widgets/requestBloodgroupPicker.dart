import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';

class RequestBloodGroupPicker extends StatelessWidget {
  final List<String> items;

  const RequestBloodGroupPicker({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();

    return Obx(() => Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(45)),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEF),
              borderRadius: BorderRadius.circular(45),
            ),
            padding: const EdgeInsets.only(left: 22, right: 22),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: ctrl.bloodGroup.value.isEmpty ? null : ctrl.bloodGroup.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                hint: const Text('Select Blood Group'),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ctrl.bloodGroup.value = value;
                  }
                },
              ),
            ),
          ),
        ));
  }
}
