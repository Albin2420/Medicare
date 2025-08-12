import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:medicare/src/presentation/widgets/BloodInfo2.dart';

class Donateblood extends StatelessWidget {
  const Donateblood({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 14),
            child: BloodInfo2(
              infonName: 'Alex Pandiyan',
              infobloodUnit: 2,
              infoLocation: 'Kochi, Kerala',
              infoRequiredDate: '28 July 2025',
              oncontact: () {
                log("contact");
              },
              infobloodGroup: 'AB+',
            ),
          ),
        ),
      ],
    );
  }
}




// ListView.separated(
//               itemBuilder: (context, index) {
//                 return BloodInfo2(
//                   infonName: 'Alex Pandiyan',
//                   infobloodUnit: 2,
//                   infoLocation: 'Kochi, Kerala',
//                   infoRequiredDate: '28 July 2025',
//                   oncontact: () {
//                     log("contact");
//                   },
//                   infobloodGroup: 'AB+',
//                 );
//               },
//               separatorBuilder: (context, index) => const SizedBox(height: 8),
//               itemCount: 8,
//             ),