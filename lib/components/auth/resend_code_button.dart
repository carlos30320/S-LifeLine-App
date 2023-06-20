import 'package:flutter/material.dart';

class ResendCodeButton extends StatelessWidget {
  final VoidCallback onClick;

  const ResendCodeButton({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Resend Code",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
