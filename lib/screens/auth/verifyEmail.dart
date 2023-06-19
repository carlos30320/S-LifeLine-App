import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _verificationCodeController = TextEditingController();
  bool isLoading = false;

  String? errorText;
  void submit() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = null;
        isLoading = true;
      });

      Response res =
          await ApiClient.verifyEmail(_verificationCodeController.value.text);
      if (res.success != true) {
        setState(() {
          errorText = res.message;
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isVerified', true);
        GoRouter.of(context).go('/signin');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        errorText = "Something went wrong";
      });
    }
  }

  void resendCode() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = null;
        isLoading = true;
      });

      Response res = await ApiClient.resendVerificationCode();
      setState(() {
        isLoading = false;
      });
      if (res.success != true) {
        setState(() {
          errorText = res.message;
        });
      }
    } catch (e) {
      print(e);
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
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.white,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Verify your email address',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'We have sent you an email with a verification code. Please enter it below to verify your email address.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            errorText != null
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      errorText!,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 6,
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, top: 6, left: 10),
                                      child: Text(
                                        'Verification code',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, top: 6, right: 10),
                                      child: ElevatedButton(
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.white),
                                            elevation:
                                                MaterialStatePropertyAll(0)),
                                        onPressed: () =>
                                            GoRouter.of(context).go('/signup'),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6, bottom: 4),
                                          child: Text(
                                            "Change Email",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue.shade600,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextField(
                                      controller: _verificationCodeController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              Colors.blueGrey.withOpacity(0.1),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 12),
                                          hintText: 'Enter verification code',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
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
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red),
                            elevation: MaterialStatePropertyAll(0)),
                        onPressed: () => submit(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18, bottom: 18),
                          child: !isLoading
                              ? const Text(
                                  'Verify email',
                                  style: TextStyle(fontSize: 14),
                                )
                              : const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            elevation: MaterialStatePropertyAll(0)),
                        onPressed: () => resendCode(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18, bottom: 18),
                          child: Text(
                            "resend code",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
