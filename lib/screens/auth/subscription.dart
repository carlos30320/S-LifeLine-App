import 'package:american_student_book/components/welcome_dialog.dart';
import 'package:flutter/material.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  Future<bool>onwilllpop ( )   async {

    return await showDialog(context: context, builder:(context) {


      return AlertDialog(

        title: Text('Exit App'),
        content: Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],











      );

    },);


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        onWillPop:onwilllpop,

        child: const WelcomeDialog());
  }
}
