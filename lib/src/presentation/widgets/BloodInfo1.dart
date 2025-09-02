import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloodInfo1 extends StatelessWidget {
  final String infonName;

  final String infoLocation;
  final VoidCallback contact;
  final String infobloodGroup;
  const BloodInfo1({
    super.key,

    required this.infonName,
    required this.infoLocation,

    required this.contact,
    required this.infobloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  infobloodGroup,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    height: 1.3,
                    letterSpacing: 0,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    infonName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      height: 1.3,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    infoLocation,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 14.4,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: 0.0,
                      color: Color(0xBF28274F),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 38,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 10,
                      bottom: 10,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 16,
                          width: 16,
                          child: Image.asset("assets/icons/phonewhite.png"),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Contact",
                          textAlign: TextAlign.center,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
