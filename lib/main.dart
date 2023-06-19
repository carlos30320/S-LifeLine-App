import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/screens/auth/signin.dart';
import 'package:american_student_book/screens/auth/signup.dart';
import 'package:american_student_book/screens/auth/subscription.dart';
import 'package:american_student_book/screens/auth/verifyEmail.dart';
import 'package:american_student_book/screens/home/index.dart';
import 'package:american_student_book/screens/phonenumbers/index.dart';
import 'package:american_student_book/utils/permissionsHandler.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void requestPermissionsAndRunApp() async {
  // Request the necessary permissions
  bool permissionsGranted = await PermissionHandler.requestPermissions([
    Permission.location,
    Permission.sms,
  ]);

  if (permissionsGranted) {
    runApp(MyApp());
  } else {
    SystemNavigator.pop();
  }
}

// void handleDeepLink(Uri uri) {
//   if (uri.pathSegments.isNotEmpty) {
//     if (uri.path == '/payment-complete') {
//       SharedPreferences.getInstance().then((value) {
//         value.setBool('isActivated', true).then((_) {
//           runApp(MyApp(paymentSuccess: true));
//         });
//       });
//     } else if (uri.path == '/payment-failed') {
//       SharedPreferences.getInstance().then((value) {
//         value.setBool('isActivated', false).then((_) {
//           runApp(MyApp(paymentSuccess: false));
//         });
//       });
//     }
//   }
// }

// void initUniLinks() async {
//   try {
//     Uri? initialUri = await getInitialUri();
//     handleDeepLink(initialUri!);
//     uriLinkStream.listen((uri) {
//       handleDeepLink(uri!);
//     });
//   } on PlatformException {
//     SystemNavigator.pop();
//   }
// }

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
      path: '/welcome',
      builder: (context, state) => const SubscribePage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/phonebook',
      builder: (context, state) => const PhoneNumbers(),
    ),
    GoRoute(
      path: '/verifyEmail',
      builder: (context, state) => const VerifyEmailScreen(),
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
            : const SubscribePage()
        : const SignInScreen();

    return MaterialApp.router(
        routerConfig: buildRouter(initialScreen), color: Colors.white);
  }
}
