import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bloodinfo3 extends StatelessWidget {
  const Bloodinfo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xff28274f40)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red, width: 1.2),
              ),
              child: Center(
                child: Text(
                  "A+",
                  textAlign: TextAlign.center, // Center alignment
                  style: GoogleFonts.poppins(
                    fontSize: 21.6, // 21.6px
                    fontWeight: FontWeight.w700, // Bold (700)
                    height: 1.3, // Line height = 130%
                    letterSpacing: 0.0, // No letter spacing
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "32 lives in Kochi need B+.",
                      style: GoogleFonts.poppins(
                        fontSize: 16, // 16px
                        fontWeight: FontWeight.w500, // 500 weight
                        height: 1.3, // Line height = 130%
                        letterSpacing: 0.0, // 0%
                      ),
                    ),
                    Text(
                      "Help by sharing!",
                      style: GoogleFonts.poppins(
                        fontSize: 12, // 12px
                        fontWeight: FontWeight.w400, // Regular (400)
                        height: 1.3, // 130% line-height
                        letterSpacing: 0.0, // No extra letter spacing
                        color: Color(0xBF353459),
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 105,
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 10,
                      bottom: 10,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF51507F), // #51507F
                          Color(0xFF27264D), // #27264D
                        ],
                        stops: [0.0209, 1.044], // 2.09% and 104.4%
                        transform: GradientRotation(
                          90.83 * (3.1415926 / 180),
                        ), // convert degrees to radians
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 16,
                          width: 16,
                          child: Image.asset("assets/icons/share.png"),
                        ),

                        Text(
                          "Share",
                          style: GoogleFonts.poppins(
                            fontSize: 14.4,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
