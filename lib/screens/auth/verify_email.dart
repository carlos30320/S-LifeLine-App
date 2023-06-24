import 'package:american_student_book/components/auth/text_link.dart';
import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:american_student_book/components/auth/errors.dart';
import 'package:american_student_book/components/auth/resend_code_button.dart';
import 'package:american_student_book/components/auth/submit_button.dart';
import 'package:american_student_book/components/auth/text_field.dart';
import 'package:american_student_book/components/auth/title_text.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _verificationCodeController = TextEditingController();

  bool isLoading = false;
  String errorText = "";

  void onSubmit() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = "";
        isLoading = true;
      });

      Response res =
          await ApiClient.verifyEmail(_verificationCodeController.value.text);
      if (res.success != true) {
        setState(() {
          errorText = res.message.toString();
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isVerified', true);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/signin');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isLoading = false;
        errorText = "Something went wrong";
      });
    }
  }

  void onResendCode() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = "";
        isLoading = true;
      });

      Response res = await ApiClient.resendVerificationCode();
      setState(() {
        isLoading = false;
      });
      if (res.success != true) {
        setState(() {
          errorText = res.message.toString();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
                  const TitleText(title: 'Verify Email'),
                  const Text(
                    'We have sent you an email with a verification code. Please enter it below to verify your email address.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Errors(errorText: errorText),
                  BuildTextField(
                    title: 'Verification Code',
                    hintText: "123456",
                    controller: _verificationCodeController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                  ResendCodeButton(onClick: onResendCode),
                  SubmitButton(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                    buttonText: 'Verify email',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextLink(
                    text: "Change email",
                    link: '/signup',
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
