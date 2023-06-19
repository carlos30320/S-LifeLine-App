import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  void submit() async {
    try {
      if (isLoading) return;
      setState(() {
        errorMessage = null;
        isLoading = true;
      });
      Response res = await ApiClient.signUp(
          _usernameController.value.text,
          _emailController.value.text,
          _passwordController.value.text,
          _confirmPasswordController.value.text);

      if (res.success != true) {
        setState(() {
          errorMessage = res.message;
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', res.data['token']);
        await prefs.setString('username', res.data['username']);
        await prefs.setBool('isActivated', res.data['isActivated']);
        GoRouter.of(context).go('/verifyEmail');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Something went wrong";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 56, left: 16, right: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Logo(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        errorMessage != null
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 6,
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4, top: 6, left: 10),
                              child: Text(
                                'Email address',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.blueGrey.withOpacity(0.1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                      hintText: 'john@doe.com',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4, top: 6, left: 10),
                              child: Text(
                                'Username',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextField(
                                  controller: _usernameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.blueGrey.withOpacity(0.1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                      hintText: 'john_doe',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4, top: 6, left: 10),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.blueGrey.withOpacity(0.1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                      hintText: '***********',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4, top: 6, left: 10),
                              child: Text(
                                'Confirm password',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextField(
                                  obscureText: true,
                                  controller: _confirmPasswordController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.blueGrey.withOpacity(0.1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                      hintText: '***********',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                        elevation: MaterialStatePropertyAll(0)),
                    onPressed: () => submit(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18, bottom: 18),
                      child: !isLoading
                          ? const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 14),
                            )
                          : const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  elevation: MaterialStatePropertyAll(0),
                ),
                onPressed: () => GoRouter.of(context).go('/signin'),
                child: const Text(
                  'I already have an account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
