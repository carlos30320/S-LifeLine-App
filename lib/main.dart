import 'package:american_student_book/components/welcomeDialog.dart';
import 'package:american_student_book/config/theme.dart';
import 'package:american_student_book/screens/auth/signin.dart';
import 'package:american_student_book/screens/auth/signup.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissionsAndRunApp();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  DataStore ds = DataStore.getInstance();
  GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state)  => const HomeScreen()
      //   bool? isUserNew;
      //   DataStore.isContactNew().then((value) {
      //     print(value);
      //     isUserNew = value;
      //   if (isUserNew == false) {
      //     return const WelcomeDialog();
      //   } else {
      //     return const HomeScreen();
      //   }
      //   });
      // },
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeDialog(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/phonebook',
      builder: (context, state) => const PhoneNumbers(),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: globalTheme,
      routerConfig: router,
      color: Colors.white,
    );
  }
}
