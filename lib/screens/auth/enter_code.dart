import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/utils/toast.dart';
import 'package:american_student_book/components/auth/text_field.dart';
import 'package:american_student_book/components/auth/submit_button.dart';
import 'package:american_student_book/components/auth/title_text.dart';
import 'package:american_student_book/components/auth/errors.dart';
import 'package:american_student_book/components/auth/text_link.dart';
import 'package:american_student_book/components/auth/resend_code_button.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});
  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeController = TextEditingController();

  bool isLoading = false;
  String errorText = "";

  void onSubmit() async {
    if (isLoading) return;

    setState(() {
      errorText = "";
      isLoading = true;
    });

    try {
      final code = _codeController.value.text;

      // Validation
      if (code.isEmpty) {
        updateState(isLoading: false, errorText: "Code is empty.");
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      final res =
          await ApiClient.confirmForgotPasswordCode(email.toString(), code);
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
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go('/change-password');
    }
  }

  void updateState({String errorText = "", bool? isLoading}) {
    setState(() {
      this.errorText = errorText;
      this.isLoading = isLoading ?? this.isLoading;
    });
  }

  void onResendForgotPasswordCode() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = "";
        isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      Response res =
          await ApiClient.sendForgotPasswordRequest(email.toString());

      setState(() {
        isLoading = false;
      });
      if (res.success != true) {
        setState(() {
          errorText = res.message!;
        });
      } else {
        await prefs.setString('access_token', res.data['token']);
        showToast("Resent verification code.", status: ToastStatus.success);
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
                    'We sent you an email with a verification code. Please check your email box.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Errors(errorText: errorText),
                  BuildTextField(
                    title: 'Verification Code',
                    hintText: "123456",
                    controller: _codeController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                  ResendCodeButton(onClick: onResendForgotPasswordCode),
                  SubmitButton(
                    isLoading: isLoading,
                    onPressed: onSubmit,
                    buttonText: 'Confirm code',
                  ),
                  const SizedBox(height: 20.0),
                  const TextLink(
                    text: "Change email",
                    link: '/forgot-password/send-request',
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
