import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/components/welcomeDialog.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../store/store.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  String? errorText;
  void submit() async {
    try {
      if (isLoading) return;
      setState(() {
        errorText = null;
        isLoading = true;
      });

      Response res = await ApiClient.signIn(
          _emailController.value.text, _passwordController.value.text);
      if (res.success != true) {
        setState(() {
          errorText = res.message;
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', res.data['token']);
        prefs.setString('username', res.data['username']);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/home');
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

  showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          insetAnimationDuration: Duration(milliseconds: 300),
          insetPadding: EdgeInsets.all(4),
          elevation: 0,
          child: WelcomeDialog(),
        );
      },
    );
  }

  @override
  void initState() {
    DataStore.isContactNew().then((value) async {
      if (value == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showWelcomeDialog();
        });
      }
    });
    super.initState();
  }

  @override
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
                          child: Text(
                            'Sign in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        errorText != null
                            ? Padding(
                                padding: EdgeInsets.all(10.0),
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
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 4, top: 6, left: 10),
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
                                      hintStyle: TextStyle(color: Colors.grey),
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
                              'Sign in',
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        elevation: MaterialStatePropertyAll(0)),
                    onPressed: () => GoRouter.of(context).go('/signup'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18, bottom: 18),
                      child: Text(
                        "I don't have an account",
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
    );
  }
}
