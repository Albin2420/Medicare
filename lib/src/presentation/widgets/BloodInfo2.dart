import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class BloodInfo2 extends StatelessWidget {
  final String infonName;
  final int infobloodUnit;
  final String infoLocation;
  final String infoRequiredDate;
  final VoidCallback oncontact;
  final String infobloodGroup;
  const BloodInfo2({
    super.key,
    required this.infonName,
    required this.infobloodUnit,
    required this.infoLocation,
    required this.infoRequiredDate,
    required this.oncontact,
    required this.infobloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 14, top: 16, bottom: 4),
          child: Container(
            padding: EdgeInsets.only(left: 64, top: 10, bottom: 10, right: 14),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xff28274f40), width: 0.9),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 8, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          infonName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("$infobloodUnit units"),
                        Text(infoLocation),
                        SizedBox(height: 4),
                        Text(
                          infoRequiredDate,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Image.asset(
                          scale: 3.5,
                          "assets/icons/warning.png",
                        ),
                      ),
                      SizedBox(height: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: oncontact,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-1.0, -0.15),
                                end: Alignment(1.0, 0.15),
                                colors: [Color(0xFF138820), Color(0xFF53CF61)],
                                stops: [0.0683, 0.9972],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.only(
                              left: 9,
                              right: 8,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              "Contact",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.66, -1.0), // approximate for 147.96deg
              end: Alignment(1.0, 1.0),
              colors: [
                Color(0xFFE55555), // #E55555 at 16.64%
                Color(0xFF8D0808), // #8D0808 at 92.32%
              ],
              stops: [0.1664, 0.9232],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              infobloodGroup,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 21,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
