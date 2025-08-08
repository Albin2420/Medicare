import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:medicare/src/presentation/widgets/donarCard.dart';

class Donateblood extends StatelessWidget {
  const Donateblood({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DonorCardWidget(),
        ),
      ),
    );
  }
}
