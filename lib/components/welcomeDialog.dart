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
    Navigator.of(context).pop();
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 50, height: 50, child: Logo()),
                    SizedBox(width: 10),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Image.asset('assets/bannerImg.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      'HELP SAVE YOUR KIDS FROM POSSIBLE DANGER BY PROVIDING THEM WITH THE APP THAT WILL REACH YOU 24/7',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '''Subscribe to one of America's most efficient. and reasonably priced Emergency Alert Systems that can save a loved one from the worry of being alone when in trouble, without a means to reach out to those who care most for their well being and safety, only 12.00USD a year, instantly alerts up to three contacts simultaneously...subscribe below: ''',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.7)),
                  ),
                  const SizedBox(
                    height: 20,
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
