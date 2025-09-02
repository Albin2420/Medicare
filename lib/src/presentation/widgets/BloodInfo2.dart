import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BloodInfo2 extends StatelessWidget {
  final String infonName;
  final int infobloodUnit;
  final String infoLocation;
  final String infoRequiredDate;
  final VoidCallback accept;
  final String infobloodGroup;

  const BloodInfo2({
    super.key,
    required this.infonName,
    required this.infobloodUnit,
    required this.infoLocation,
    required this.infoRequiredDate,
    required this.accept,
    required this.infobloodGroup,
  });

  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat("d MMMM yyyy").format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth / 390; // Based on iPhone 13 width

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 13, top: 16),
          child: Container(
            padding: const EdgeInsets.only(
              left: 60,
              top: 10,
              bottom: 10,
              right: 14,
            ),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xff28274f40), width: 0.9),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          infonName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16 * fontScale,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$infobloodUnit units",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.4 * fontScale,
                            height: 1.3,
                            color: const Color(0xBF28274F),
                          ),
                        ),
                        Text(
                          infoLocation,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.4 * fontScale,
                            height: 1.3,
                            color: const Color(0xBF28274F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(infoRequiredDate),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15 * fontScale,
                            height: 1.3,
                            color: const Color(0xFF28274F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Image.asset(
                          "assets/icons/warning.png",
                          scale: 3.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: accept,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(-1.0, -0.15),
                                end: Alignment(1.0, 0.15),
                                colors: [Color(0XFF51507F), Color(0xff27264D)],
                                stops: [0.0683, 0.9972],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              "Accept",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.4 * fontScale,
                                height: 1.3,
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
            gradient: const LinearGradient(
              begin: Alignment(-0.66, -1.0),
              end: Alignment(1.0, 1.0),
              colors: [Color(0xFFE55555), Color(0xFF8D0808)],
              stops: [0.1664, 0.9232],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              infobloodGroup,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 21.6 * fontScale,
                height: 1.3,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
