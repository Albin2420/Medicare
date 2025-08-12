import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloodInfo1 extends StatelessWidget {
  final String infonName;
  final int bloodUnit;
  final String infoLocation;
  final VoidCallback share;
  final VoidCallback contact;
  final String infobloodGroup;
  const BloodInfo1({
    super.key,
    required this.bloodUnit,
    required this.infonName,
    required this.infoLocation,
    required this.share,
    required this.contact,
    required this.infobloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infonName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        height: 1.3,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Can provide: $bloodUnit unit",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.4,
                        height: 1.3,
                        letterSpacing: 0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      infoLocation,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.4,
                        height: 1.3,
                        letterSpacing: 0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Text(
                  infobloodGroup,
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: 0,
                    color: Color(0xFFD32F2F),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: share,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 9,
                    right: 9,
                    top: 6,
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF51507F), Color(0xFF27264D)],
                      stops: [0.0209, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        "Share",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.4,
                          height: 1.3,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              GestureDetector(
                onTap: contact,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 9,
                    right: 9,
                    top: 6,
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1.0, -0.15),
                      end: Alignment(1.0, 0.15),
                      colors: [Color(0xFF138820), Color(0xFF53CF61)],
                      stops: [0.0683, 0.9972],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        "Contact",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.4,
                          height: 1.3,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
