import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 160, child: Center(child: Image.asset('assets/logo.png')));
  }
}
