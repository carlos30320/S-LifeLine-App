import 'package:american_student_book/store/store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/components/logo.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({super.key});

  @override
  State<WelcomeDialog> createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  bool? isNewUser;

  Future<void> _launchUrl() async {
    await launchUrl(Uri.parse(
        'https://studentlifeline.bigcartel.com/product/student-lifeline-alert-notification-app'));
    GoRouter.of(context).go('/');
    DataStore.setIsContactNew(false);
  }

  @override
  void initState() {
    print("Mounted Welcome Dialog in the Interface");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 50, height: 50, child: Logo()),
                    Text(
                      'Student Lifeline',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decorationStyle: TextDecorationStyle.solid),
                    ),
                  ],
                ),
              ),
              Image.asset('assets/bannerImg.png'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      'HELP SAVE YOUR KIDS FROM POSSIBLE DANGER BY PROVIDING THEM WITH THE APP THAT WILL REACH YOU 24/7',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '''Student Lifeline® now provides the app that your son or daughter may download and reach up to three (3) contacts in the event of any possible compromising situation 24/7 for only one dollar  a month /USD12 annually. The Student Lifeline® alert notification app can   bring peace of mind if the need to reach three personal contacts   arises. This app does not replace a need to report a possible crime,   fire, or medical emergency that is provided by direct contact or, if   available, the 911 hotline system in the US and Canada. This alert system  is available worldwide. Scan the app today for immediate usage. Student  Lifeline® has been in the business of providing emergency transportation to stranded youth since 1988, and is proud to offer this new alert system  to any individual who may require this service, regardless of age.''',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.7)),
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
                        onPressed: _launchUrl,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 18),
                            child: Text(
                              'Go to subscription'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent),
                          elevation: MaterialStatePropertyAll(0)),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18),
                          child: Text(
                            'Close ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
