import 'package:student_lifeline/components/logo.dart';
import 'package:student_lifeline/utils/api.dart';
import 'package:student_lifeline/utils/factories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_lifeline/utils/toast.dart';
import 'package:student_lifeline/components/auth/text_field.dart';
import 'package:student_lifeline/components/auth/submit_button.dart';
import 'package:student_lifeline/components/auth/title_text.dart';
import 'package:student_lifeline/components/auth/errors.dart';
import 'package:student_lifeline/components/auth/text_link.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  bool isLoading = false;
  String errorText = "";

  void onSubmit() async {
    if (isLoading) return;

    setState(() {
      errorText = "";
      isLoading = true;
    });

    try {
      final email = _emailController.value.text;

      // Validation
      if (email.isEmpty) {
        updateState(isLoading: false, errorText: "Email is empty.");
        return;
      }

      final res = await ApiClient.sendForgotPasswordRequest(email);
      handleResponse(res);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      updateState(isLoading: false, errorText: 'Something went wrong');
    }
  }

  void handleResponse(Response res) async {
    if (res.success != true) {
      updateState(isLoading: false, errorText: res.message.toString());
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', res.data['token']);
      await prefs.setString('email', _emailController.value.text);
      showToast("Forgot password request sent.", status: ToastStatus.success);
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go('/forgot-password/enter-code');
    }
  }

  void updateState({String errorText = "", bool? isLoading}) {
    setState(() {
      this.errorText = errorText;
      this.isLoading = isLoading ?? this.isLoading;
    });
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
                  const TitleText(title: 'Forgot password'),
                  const Text(
                    'We will send you an email with a verification code. Please enter your email.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Errors(errorText: errorText),
                  BuildTextField(
                    title: 'Email',
                    hintText: "james@gmail.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SubmitButton(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                    buttonText: 'Send verificatin code',
                  ),
                  const SizedBox(height: 20.0),
                  const TextLink(
                    text: "Go to Sign in",
                    link: '/signin',
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
