import 'package:american_student_book/components/logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Logo(),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              style: ListTileStyle.list,
              leading: const Icon(Icons.home, color: Colors.red),
              title: const Text('Home'),
              onTap: () {
                GoRouter.of(context).go('/home');
              },
            ),
            ListTile(
              style: ListTileStyle.list,
              leading: const Icon(
                Icons.phone,
                color: Colors.red,
              ),
              title: const Text('Phone Numbers'),
              onTap: () {
                GoRouter.of(context).go('/phonebook');
              },
            ),
            ListTile(
              style: ListTileStyle.list,
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('access_token');
                  prefs.remove('username');
                  GoRouter.of(context).go('/signin');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
