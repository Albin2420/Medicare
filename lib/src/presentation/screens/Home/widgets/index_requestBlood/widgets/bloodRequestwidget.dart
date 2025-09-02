import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bloodrequestwidget extends StatelessWidget {
  final VoidCallback endRequest;
  final String name;
  final int reqCount;
  final String bloodType;

  const Bloodrequestwidget({
    super.key,
    required this.endRequest,
    required this.name,
    required this.reqCount,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(8),
      width: screenWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            'Active Request',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.05, // ~20 on 400px screen
              fontWeight: FontWeight.w700,
              color: Colors.red,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 18),
          // Main Info Row
          SizedBox(
            height: 70,
            child: Row(
              children: [
                // Name & Units & Description
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Count
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.045,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "$reqCount units",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * 0.04,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          'You may end the request if your requirements were fulfilled.',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.032, // ~13 at 400px
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Blood Group Box
                Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1.5),
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          bloodType,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.05,
                            height: 1.3,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // End Request Button
          GestureDetector(
            onTap: endRequest,
            child: Container(
              height: 41,
              width: screenWidth * 0.4, // ~140 at 360px
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(147.96 * 3.1415926535 / 180),
                  colors: [Color(0xFFE55555), Color(0xFF8D0808)],
                  stops: [0.1664, 0.9232],
                ),
              ),
              child: Center(
                child: Text(
                  "End Request",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
