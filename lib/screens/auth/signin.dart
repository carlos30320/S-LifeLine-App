import 'package:american_student_book/components/logo.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/utils/toast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  bool _rememberMe = false;
  String? errorText;

  void submit() async {
    if (isLoading) return;

    setState(() {
      errorText = null;
      isLoading = true;
    });

    try {
      final email = _emailController.value.text;
      final password = _passwordController.value.text;

      // Validation
      if (email.isEmpty) {
        updateState(isLoading: false, errorText: "Email is required.");
        return;
      }
      if (password.isEmpty) {
        updateState(isLoading: false, errorText: "Email is required.");
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
      updateState(errorText: res.message);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', res.data['token']);
      await prefs.setString('username', res.data['username']);
      await prefs.setBool('isActivate', res.data['isActivated']);
      await prefs.setBool('isVerified', res.data['isVerified']);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString(
          'subscriptionEndDate', res.data['subscriptionEndDate'] ?? '');

      if (!res.data['isVerified']) {
        showToast("Your email is not verified.", status: ToastStatus.warning);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/verify-email');
      } else if (!res.data['isActivated']) {
        showToast("You didn't subscribe yet.", status: ToastStatus.warning);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/welcome');
      } else {
        if (_rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("email", _emailController.value.text);
          prefs.setString("password", _passwordController.value.text);
        }

        showToast("Login Success.", status: ToastStatus.success);
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go('/home');
      }
    }
    updateState(isLoading: false);
  }

  void updateState({String? errorText, bool? isLoading}) {
    setState(() {
      this.errorText = errorText;
      this.isLoading = isLoading ?? this.isLoading;
    });
  }

  void _onRememberMeChanged(bool? newValue) async {
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

  Widget _buildTitle() {
    return const Column(children: [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'Sign in',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }

  Widget _buildErrorText() {
    return Column(children: [
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
            )
    ]);
  }

  Widget _buildEmailTF() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 6, left: 10),
        child: Text(
          'Email address',
          style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 14),
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
                fillColor: Colors.blueGrey.withOpacity(0.1),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                hintText: 'john@doe.com',
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none)),
      ),
    ]);
  }

  Widget _bulidPasswordTF() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 6, left: 10),
        child: Text(
          'Password',
          style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 14),
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
                fillColor: Colors.blueGrey.withOpacity(0.1),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                hintText: '***********',
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none)),
      )
    ]);
  }

  Widget _buildForgotPasswordBtn() {
    return TextButton(
      onPressed: () {
        // Add your code here to handle what happens when the user clicks the forgot password button
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

  Widget _buildRememberMeCheckbox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data:
                ThemeData(unselectedWidgetColor: Colors.black.withOpacity(0.8)),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.red,
              activeColor: Colors.white,
              onChanged: _onRememberMeChanged,
            ),
          ),
          const Text(
            'Remember me',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return ClipRRect(
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/signup'),
      child: RichText(
        text: TextSpan(
          text: "I don't have an account",
          style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade600,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
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
                  _buildTitle(),
                  _buildErrorText(),
                  _buildEmailTF(),
                  _bulidPasswordTF(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRememberMeCheckbox(),
                      _buildForgotPasswordBtn(),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  _buildLoginBtn(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  _buildSignupBtn(),
                ],
              ),
            ),
          ),
        ]));
  }
}
