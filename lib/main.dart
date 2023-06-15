import 'package:american_student_book/screens/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:american_student_book/screens/auth/signin.dart';
import 'package:american_student_book/screens/auth/signup.dart';
import 'package:american_student_book/screens/auth/subscription.dart';
import 'package:american_student_book/screens/auth/verifyEmail.dart';
import 'package:american_student_book/screens/home.dart';
import 'package:american_student_book/screens/index.dart';
import 'package:american_student_book/screens/phonenumbers/index.dart';
import 'package:american_student_book/store/store.dart';
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

void handleDeepLink(Uri uri) {
  print('____________________ $uri');
  if (uri.pathSegments.isNotEmpty) {
    if (uri.path == '/payment-complete') {
      SharedPreferences.getInstance().then((value) {
        value.setBool('isActivated', true).then((_) {
          runApp(MyApp(paymentSuccess: true));
        });
      });
    } else if (uri.path == '/payment-failed') {
      SharedPreferences.getInstance().then((value) {
        value.setBool('isActivated', false).then((_) {
          runApp(MyApp(paymentSuccess: false));
        });
      });
    }
  }
}

void initUniLinks() async {
  try {
    Uri? initialUri = await getInitialUri();
    handleDeepLink(initialUri!);
    uriLinkStream.listen((uri) {
      handleDeepLink(uri!);
    });
  } on PlatformException {
    SystemNavigator.pop();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissionsAndRunApp();
  initUniLinks();
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
  bool? paymentSuccess;

  MyApp({Key? key, this.paymentSuccess}) : super(key: key);

  DataStore ds = DataStore.getInstance();

  @override
  Widget build(BuildContext context) {
    Widget initialScreen;
    if (paymentSuccess == true) {
      initialScreen = const SuccessScreen(
        successMessage: "Payment Successful",
      );
    } else {
      // Fluttertoast.showToast(
      //     msg: "Payment Failed",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     fontSize: 16.0);
      initialScreen = const Home();
    }

    return MaterialApp.router(
        // ...
        routerConfig: buildRouter(initialScreen),
        color: Colors.white);
  }
}
