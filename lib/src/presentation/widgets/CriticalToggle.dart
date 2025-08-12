import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CriticalToggle extends StatefulWidget {
  final Function({required bool value}) oncontact;
  const CriticalToggle({super.key, required this.oncontact});

  @override
  State<CriticalToggle> createState() => _CriticalToggleState();
}

class _CriticalToggleState extends State<CriticalToggle> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 1, color: Colors.red),
      ),
      padding: const EdgeInsets.only(left: 20, right: 10, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Critical",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 20,
              height: 1.3,
              letterSpacing: 0.0,
              color: Colors.red,
            ),
          ),
          Switch(
            value: isSwitched,
            onChanged: (x) {
              setState(() {
                isSwitched = x;
              });
              widget.oncontact(value: x); // fixed named parameter
            },
            activeColor: const Color(0xffE55555),
            thumbColor: WidgetStateProperty.all<Color>(Colors.red),
            inactiveThumbColor: const Color(0xffE55555),
            inactiveTrackColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
