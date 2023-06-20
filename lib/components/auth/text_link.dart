import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TextLink extends StatelessWidget {
  final String text;
  final String link;

  const TextLink({Key? key, required this.link, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go(link),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade600,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
