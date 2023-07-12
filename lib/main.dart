import 'package:studentlifeline/screens/auth/change_password.dart';
import 'package:studentlifeline/screens/auth/enter_code.dart';
import 'package:studentlifeline/screens/auth/forgot_password.dart';
import 'package:studentlifeline/utils/api.dart';
import 'package:studentlifeline/utils/factories.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentlifeline/screens/auth/signin.dart';
import 'package:studentlifeline/screens/auth/signup.dart';
import 'package:studentlifeline/screens/auth/subscription.dart';
import 'package:studentlifeline/screens/auth/verify_email.dart';
import 'package:studentlifeline/screens/home/index.dart';
import 'package:studentlifeline/screens/phonenumbers/index.dart';
import 'package:studentlifeline/utils/permissionsHandler.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void requestPermissionsAndRunApp() async {
  // Request the necessary permissions
  bool permissionsGranted = await PermissionHandler.requestPermissions([
    Permission.location,
  ]);

  if (permissionsGranted) {
    runApp(MyApp());
  } else {
    SystemNavigator.pop();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissionsAndRunApp();
  // initUniLinks();

  // Initialize SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the user is logged in
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isSubscribed = false;

  if (isLoggedIn) {
    //  Check subscription status
    Response res = await ApiClient.getSubscriptionStatus();
    if (res.success == true) {
      isSubscribed = res.data['isAvailable'];
      prefs.setString('subscriptionEndDate', res.data['subscriptionEndDate']);
    } else {
      Fluttertoast.showToast(
          msg: "Aww! Something went wrong".toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade900,
          textColor: Colors.white,
          fontSize: 14.0);

      await prefs.setBool('isLoggedIn', false);
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, isSubscribed: isSubscribed));
}

// ignore: non_constant_identifier_names
GoRouter buildRouter(Widget InitialScreen) {
  return GoRouter(routes: [
    GoRoute(path: '/', builder: (context, state) => InitialScreen),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: '/forgot-password/send-request',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/forgot-password/enter-code',
      builder: (context, state) => const EnterCodeScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const Subscription(),
    ),
    GoRoute(
      path: '/phonebook',
      builder: (context, state) => const PhoneNumbers(),
    ),
  ]);
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool? isLoggedIn;
  bool? isSubscribed;

  MyApp({Key? key, this.isLoggedIn, this.isSubscribed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget initialScreen = isLoggedIn == true
        ? isSubscribed == true
            ? const HomeScreen()
            : const Subscription()
        : const SignInScreen();

    return MaterialApp.router(
        routerConfig: buildRouter(initialScreen), color: Colors.white);
  }
}
