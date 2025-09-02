import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloodGroupSelector extends StatefulWidget {
  final void Function(String?)? onChanged; // ✅ Callback for selected value

  const BloodGroupSelector({super.key, required this.onChanged});

  @override
  _BloodGroupSelectorState createState() => _BloodGroupSelectorState();
}

class _BloodGroupSelectorState extends State<BloodGroupSelector> {
  String? _selectedGroup;

  final List<String> bloodGroups = [
    'O+',
    'A+',
    'B+',
    'AB+',
    'O-',
    'A-',
    'B-',
    'AB-',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 5,
      children: bloodGroups.map((group) {
        return SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: group,
                groupValue: _selectedGroup,
                onChanged: (value) {
                  setState(() {
                    _selectedGroup = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(value); // ✅ Trigger the callback
                  }
                },
              ),
              Text(
                group,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
