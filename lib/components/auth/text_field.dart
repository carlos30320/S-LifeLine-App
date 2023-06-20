import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const BuildTextField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 6, left: 10),
          child: Text(
            title,
            style:
                TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 14),
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextField(
              obscureText: obscureText,
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey.withOpacity(0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none)),
        ),
      ],
    );
  }
}
