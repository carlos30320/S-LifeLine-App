import 'package:american_student_book/store/store.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:american_student_book/components/logo.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({super.key});

  @override
  State<WelcomeDialog> createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  bool? isNewUser;

  @override
  void initState() {
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
                    '''Subscribe to one of America's most efficient. and reasonably priced Emergency Alert Systems that can save a loved one from the worry of being alone when in trouble, without a means to reach out to those who care most for their well being and safety, only 12.00USD a year, instantly alerts up to three contacts simultaneously...subscribe below: ''',
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
                        onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => UsePaypal(
                                  sandboxMode: true,
                                  clientId:
                                      "AQqdXPQ3rsswW2UJljkczMP7uoSUqrwVOK8cjLyf6LfFbF1iV1vcyTLQOiWidshC2tmSFcOUOCPyecof",
                                  secretKey:
                                      "EAi5rs88yS1W_1Jq1DBUYQakMWyFgxk3QIlBiHIaSgGcndYTv9FR84l_iiOyE_SSiESadJv8l9tQZjN9",
                                  returnURL: "https://samplesite.com/return",
                                  cancelURL: "https://samplesite.com/cancel",
                                  transactions: const [
                                    {
                                      "amount": {
                                        "total": '12.0',
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": '12.00',
                                          "shipping": '0',
                                          "shipping_discount": 0
                                        }
                                      },
                                      "description":
                                          "Subscription to Student Lifeline",
                                      // "payment_options": {
                                      //   "allowed_payment_method":
                                      //       "INSTANT_FUNDING_SOURCE"
                                      // },
                                    }
                                  ],
                                  note:
                                      "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    print("onSuccess: $params");
                                    Response res =
                                        await ApiClient.subscribeForAYear();
                                    if (res.success == true) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isActivated', true);
                                      GoRouter.of(context).go('/home');
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "You subsscribed for a year"
                                              .toString(),
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red.shade900,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    }
                                  },
                                  onError: (error) {
                                    Fluttertoast.showToast(
                                        msg: "Something went wrong".toString(),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red.shade900,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                    print("onError: $error");
                                  },
                                  onCancel: (params) {
                                    Fluttertoast.showToast(
                                        msg: "Action cancelled".toString(),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red.shade900,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                  }),
                            ),
                          )
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 18),
                            child: Text(
                              'Pay with paypal'.toUpperCase(),
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
                      onPressed: () => SystemNavigator.pop(),
                      child: const Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18),
                          child: Text(
                            'Close App ',
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
