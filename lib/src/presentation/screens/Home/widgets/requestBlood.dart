import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicare/src/presentation/widgets/BloodInfo1.dart';

class Requestblood extends StatelessWidget {
  const Requestblood({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BloodInfo1(
            bloodUnit: 1,
            infonName: 'Alex mathew',
            infoLocation: 'kochi,kerala',
            share: () {
              log("share called");
            },
            contact: () {
              log("contact called");
            },
            infobloodGroup: 'A+',
          ),
        ),
      ),
    );
  }
}
