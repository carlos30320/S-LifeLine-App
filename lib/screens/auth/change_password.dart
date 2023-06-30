import 'package:student_lifeline/components/logo.dart';
import 'package:student_lifeline/utils/api.dart';
import 'package:student_lifeline/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_lifeline/components/auth/text_field.dart';
import 'package:student_lifeline/components/auth/submit_button.dart';
import 'package:student_lifeline/components/auth/title_text.dart';
import 'package:student_lifeline/components/auth/errors.dart';
import 'package:student_lifeline/components/auth/text_link.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String errorText = '';
  bool isLoading = false;

  void onSubmit() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = "";
        isLoading = true;
      });

      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (password != confirmPassword) {
        setState(() {
          errorText = "Passwords do not match.";
          isLoading = false;
        });
        return;
      }

      Response res = await ApiClient.udpatePassword(password);

      if (res.success != true) {
        setState(() {
          errorText = res.message!;
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('email');
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/signin');
      }
      setState(() {
        isLoading = false;
      });
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
                  const TitleText(title: 'Change password'),
                  Errors(errorText: errorText),
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
                  const SizedBox(height: 20),
                  SubmitButton(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                    buttonText: 'Update',
                  ),
                  const SizedBox(height: 20.0),
                  const TextLink(
                    text: "Go to Sign in",
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
