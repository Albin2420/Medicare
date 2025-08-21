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
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Active Request',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700, // 700 = bold
              fontStyle: FontStyle.normal, // 'Bold' in CSS = fontWeight
              height: 1.3, // 130% line height
              letterSpacing: 0, // 0% letter spacing
              color: Colors.red,
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            height: 70,

            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              height: 1.3,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "$reqCount units",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.3,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'You may end the request if your requirements were fulfilled.',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        bloodType,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.3,
                          letterSpacing: 0,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          GestureDetector(
            onTap: endRequest,
            child: Container(
              height: 41,
              width: 140,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
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
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    height: 1.3,
                    letterSpacing: 0,
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
