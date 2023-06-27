import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/components/auth/text_field.dart';
import 'package:american_student_book/components/auth/submit_button.dart';
import 'package:american_student_book/components/auth/title_text.dart';
import 'package:american_student_book/components/auth/errors.dart';
import 'package:american_student_book/components/auth/text_link.dart';

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

  String errorText = '';
  bool isLoading = false;

  void onSubmit() async {
    try {
      if (isLoading) return;

      String username = _usernameController.value.text;
      String email = _emailController.value.text;
      String password = _passwordController.value.text;
      String password2 = _confirmPasswordController.value.text;

      // Check Valudation
      if (email.isEmpty) {
        setState(() {
          errorText = "Email is required.";
          isLoading = false;
        });
        return;
      }
      if (username.isEmpty) {
        setState(() {
          errorText = "Username is required.";
          isLoading = false;
        });
        return;
      }
      if (password.isEmpty) {
        setState(() {
          errorText = "Password is required.";
          isLoading = false;
        });
        return;
      }
      if (password2.isEmpty) {
        setState(() {
          errorText = "Confirm Password is required.";
          isLoading = false;
        });
        return;
      }
      if (password2 != password) {
        setState(() {
          errorText = "Passwords do not match.";
          isLoading = false;
        });
        return;
      }

      // Set Loading
      setState(() {
        errorText = "";
        isLoading = true;
      });
      Response res =
          await ApiClient.signUp(username, email, password, password2);

      if (res.success != true) {
        setState(() {
          isLoading = false;
          errorText = res.message!;
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', res.data['token']);
        await prefs.setString('username', res.data['username']);
        await prefs.setBool('isActivated', res.data['isActivated']);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/verify-email');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorText = "Something went wrong";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 56, left: 16, right: 16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Logo(),
                  const TitleText(title: 'Sign up'),
                  Errors(errorText: errorText),
                  BuildTextField(
                    title: 'Email',
                    hintText: "james@gmail.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                  BuildTextField(
                    title: 'Username',
                    hintText: "James",
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                  BuildTextField(
                    title: 'Password',
                    hintText: "*********",
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                  BuildTextField(
                    title: 'Confirm password',
                    hintText: "*********",
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                    buttonText: 'Sign up',
                  ),
                  const SizedBox(height: 20.0),
                  const TextLink(
                    text: "I already have an account.",
                    link: '/signin',
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ]));
  }
}
