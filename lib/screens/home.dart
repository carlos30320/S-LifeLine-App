import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null) throw Exception("Not authenticated");
  }

  @override
  void initState() {
    super.initState();
    checkAuthStatus().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isActivated') == false ||
          prefs.getBool('isActivated') == null) {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).push('/welcome');
      } else {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).push('/home');
      }
    }).catchError((err) {
      GoRouter.of(context).push('/signin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
