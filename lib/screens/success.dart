import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String? successMessage;
  const SuccessScreen({super.key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        child: Center(
          child: Text(
            successMessage!,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
