import 'package:studentlifeline/components/logo.dart';
import 'package:studentlifeline/utils/api.dart';
import 'package:studentlifeline/utils/factories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentlifeline/utils/toast.dart';
import 'package:studentlifeline/components/auth/text_field.dart';
import 'package:studentlifeline/components/auth/submit_button.dart';
import 'package:studentlifeline/components/auth/title_text.dart';
import 'package:studentlifeline/components/auth/errors.dart';
import 'package:studentlifeline/components/auth/text_link.dart';
import 'package:studentlifeline/components/copy_rights_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Future<bool> onwilllpop() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  bool _rememberMe = false;
  String errorText = "";

  void onSubmit() async {
    if (isLoading) return;

    setState(() {
      errorText = "";
      isLoading = true;
    });

    try {
      final email = _emailController.value.text;
      final password = _passwordController.value.text;

      // Validation
      if (email.isEmpty) {
        updateState(isLoading: false, errorText: "Email is empty.");
        return;
      }
      if (password.isEmpty) {
        updateState(isLoading: false, errorText: "Password is empty.");
        return;
      }

      final res = await ApiClient.signIn(email, password);

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
      await prefs.setString('username', res.data['username']);
      await prefs.setBool('isActivate', res.data['isActivated']);
      await prefs.setBool('isVerified', res.data['isVerified']);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString(
          'subscriptionEndDate', res.data['subscriptionEndDate'] ?? '');

      if (_rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("email", _emailController.value.text);
        prefs.setString("password", _passwordController.value.text);
      }

      if (!res.data['isVerified']) {
        showToast("Email is not verified.", status: ToastStatus.warning);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/verify-email');
      } else if (!res.data['isActivated']) {
        showToast("You didn't subscribe yet.", status: ToastStatus.warning);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/welcome');
      } else {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/home');
      }
      updateState(isLoading: false);
    }
  }

  void updateState({String errorText = "", bool? isLoading}) {
    setState(() {
      this.errorText = errorText;
      this.isLoading = isLoading ?? this.isLoading;
    });
  }

  void onRememberMeChanged(bool? newValue) async {
    bool rememberMe = newValue ?? false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = rememberMe;
      prefs.setBool('rememberMe', rememberMe);
      if (!rememberMe) {
        prefs.remove('email');
        prefs.remove('password');
      }
    });
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Widget _buildForgotPasswordBtn() {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go('/forgot-password/send-request');
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.black54,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onwilllpop,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(top: 56, left: 16, right: 16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Logo(),
                    const TitleText(title: 'Sign in'),
                    Errors(errorText: errorText),
                    BuildTextField(
                      title: 'Email',
                      hintText: "james@gmail.com",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
                    BuildTextField(
                      title: 'Password',
                      hintText: "*********",
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: CheckboxListTile(
                            dense: true,
                            title: const Text('Remember me'),
                            value: _rememberMe,
                            checkColor: Colors.red,
                            activeColor: Colors.white,
                            onChanged: onRememberMeChanged,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: _buildForgotPasswordBtn(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    SubmitButton(
                      isLoading: isLoading,
                      onPressed: onSubmit,
                      buttonText: 'Sign in',
                    ),
                    const SizedBox(height: 20.0),
                    const TextLink(
                      text: "I don't have an account.",
                      link: '/signup',
                    ),
                    const CopyRightsText()
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
