import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicare/src/presentation/widgets/BloodInfo2.dart';

class Donateblood extends StatelessWidget {
  const Donateblood({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BloodInfo2(
            infonName: 'ALex pandiyan',
            infobloodUnit: 2,
            infoLocation: 'kochi,kerala',
            infoRequiredDate: '28 july 2025',
            oncontact: () {
              log("contact");
            },
            infobloodGroup: 'AB+',
          ),
        ),
      ),
    );
  }
}
