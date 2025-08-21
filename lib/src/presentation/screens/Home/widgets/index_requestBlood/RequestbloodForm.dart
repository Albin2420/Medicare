import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/bloodrequestcontroller/bloodrequestcontroller.dart';
import 'package:medicare/src/presentation/widgets/CriticalToggle.dart';
import 'package:medicare/src/presentation/widgets/Datepicker.dart';
import 'package:medicare/src/presentation/widgets/Bloodgroupwidget.dart';
import 'package:medicare/src/presentation/widgets/gradientbutton.dart';

class BloodForm extends StatelessWidget {
  const BloodForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Bloodrequestcontroller>();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            CriticalToggle(
              oncontact: ({required bool value}) {
                ctrl.critical.value = value;
              },
            ),
            const SizedBox(height: 14),

            // Required Date
            _buildLabel("Required Date"),
            DatePicker(
              onDateSelected: (String value) {
                ctrl.requestDate.value = value;
              },
            ),
            const SizedBox(height: 14),

            // Blood Type
            _buildLabel("Blood Type"),
            BloodGroupPicker(
              onChanged: (String? value) {
                ctrl.bloodGroup.value = value ?? "";
              },
            ),
            const SizedBox(height: 14),

            // No. of Units
            _buildLabel("No. of Units"),
            TextFormField(
              controller: ctrl.noofUnits,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter number of units";
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return "Enter a valid number";
                }
                return null;
              },
              decoration: _inputDecoration("No. of Units needed"),
            ),
            const SizedBox(height: 12),

            // Contact
            _buildLabel("Your Contact"),
            TextFormField(
              maxLength: 10,
              controller: ctrl.contactNumber,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your contact number";
                }
                if (value.length < 10) {
                  return "Enter a valid phone number";
                }
                return null;
              },
              decoration: _inputDecoration("Enter Your Contact Number"),
            ),
            const SizedBox(height: 12),

            // Patient Name
            _buildLabel("Patient Name"),
            TextFormField(
              controller: ctrl.patienTName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter patient name";
                }
                return null;
              },
              decoration: _inputDecoration("Enter Patient Name"),
            ),
            const SizedBox(height: 12),

            // Hospital
            _buildLabel("Hospital"),
            TextFormField(
              controller: ctrl.hospitalName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter hospital name";
                }
                return null;
              },
              decoration: _inputDecoration("Hospital Name"),
            ),
            const SizedBox(height: 24),

            // Submit Button
            GradientBorderContainer(
              name: 'Request',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (ctrl.requestDate.value.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please select a required date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16.0, // slightly larger to simulate bold
                    );

                    return;
                  }
                  if (ctrl.bloodGroup.value.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please select a required BloodGroup",
                    );
                    return;
                  }

                  ctrl.requestBlood();
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Label Builder
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14.4,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF353459),
        ),
      ),
    );
  }

  // Common Input Decoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: const Color(0xffEBEBEF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
    );
  }
}
