import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';

class SuggestionTextField extends StatelessWidget {
  final List<String> suggestions;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const SuggestionTextField({
    super.key,
    required this.suggestions,
    this.hintText = 'Type here...',
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
  });

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45),
        borderSide: const BorderSide(width: 0.45),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45),
        borderSide: const BorderSide(color: Colors.grey, width: 0.45),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45),
        borderSide: const BorderSide(color: Color(0xFF27264D), width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();
    final filteredSuggestions = <String>[].obs;

    void onChanged(String value) {
      if (value.isEmpty) {
        filteredSuggestions.clear();
      } else {
        filteredSuggestions.value = suggestions
            .where((item) => item.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    }

    void selectSuggestion(String value) {
      ctrl.hospitalName.text = value;
      filteredSuggestions.clear();
    }

    return Column(
      children: [
        TextFormField(
          controller: ctrl.hospitalName,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          decoration: _inputDecoration(hintText),
        ),
        Obx(() {
          if (filteredSuggestions.isEmpty) return const SizedBox();
          return Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView(
              shrinkWrap: true,
              children: filteredSuggestions.map((item) {
                return ListTile(
                  title: Text(item),
                  onTap: () => selectSuggestion(item),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
