import 'package:american_student_book/components/nvabar.dart';
import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  String? title;
  Widget? body;
  Widget? floatingActionButton;
  PageWrapper({ super.key, required this.title, required this.body, this.floatingActionButton});

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
