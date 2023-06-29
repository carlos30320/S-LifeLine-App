import 'package:flutter/material.dart';

class CopyRightsText extends StatelessWidget {
  const CopyRightsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Text(
          "Copyrighted 2023 Noble & Masters Marketing, Inc",
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500),
        ));
  }
}
