import 'package:flutter/material.dart';
import 'package:studentlifeline/components/navbar.dart';

class PageWrapper extends StatelessWidget {
  final String? title;
  final Widget? body;
  final Widget? floatingActionButton;

  const PageWrapper({
    Key? key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red.shade700,
        title: Text(title!),
      ),
      body: body!,
      drawer: const NavBar(),
      floatingActionButton: floatingActionButton,
    );
  }
}
