import 'package:american_student_book/components/auth/text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/components/logo.dart';
import 'package:pay/pay.dart';
import 'package:american_student_book/config/subscription.dart';
import 'dart:io';

import '../../utils/api.dart';
import '../../utils/factories.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  bool? isNewUser;
  bool pay = false;

  @override
  void initState() {
    super.initState();
  }

  static const _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '12',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onApplePayResult(paymentResult) {
    // Send the resulting Apple Pay token to your server / PSP
    print("asdfasdf $paymentResult");
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
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text('\u00AE'),
                    )
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  pay == false
                      ? Text(
                          '''Subscribe to one of America's most efficient. and reasonably priced Emergency Alert Systems that can save a loved one from the worry of being alone when in trouble, without a means to reach out to those who care most for their well being and safety, only \$12.00USD a year, instantly alerts up to three contacts simultaneously...subscribe below: ''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7)),
                        )
                      : Text(
                          '''Thank you! Your subscription is now active for one year.''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                  pay == false
                      ? Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UsePaypal(
                                                sandboxMode: true,
                                                clientId:
                                                    "AbhLh92-1op95FIi4C3tyP7todnmnUVT8kcye9iQgO4e41GuKi96KFqcNrwrSdxJQmYgttdzZwG4XWac",
                                                secretKey:
                                                    "EAxtGFUyfSQytAyer_HegewiRHj6EPN8x2S6Hf-X46J6lgZsT66Trj0fr9Phdt20NdCw529_3CDp6dB6",
                                                returnURL:
                                                    "https://samplesite.com/return",
                                                cancelURL:
                                                    "https://samplesite.com/cancel",
                                                transactions: const [
                                                  {
                                                    "amount": {
                                                      "total": '12',
                                                      "currency": "USD",
                                                      "details": {
                                                        "subtotal": '12',
                                                        "shipping": '0',
                                                        "shipping_discount": 0
                                                      }
                                                    },
                                                    "Student LifeLine Subscription":
                                                        "Payment for Student LifeLine Subscription.",
                                                    "item_list": {
                                                      "items": [
                                                        {
                                                          "name":
                                                              "Student LifeLine",
                                                          "quantity": 1,
                                                          "price": '12',
                                                          "currency": "USD"
                                                        }
                                                      ],
                                                    }
                                                  }
                                                ],
                                                note:
                                                    "Contact us for any questions on your order.",
                                                onSuccess: (Map params) async {
                                                  Response res = await ApiClient
                                                      .subscribeForAYear();

                                                  if (res.success == true) {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setBool(
                                                        'isActivated', true);

                                                    Fluttertoast.showToast(
                                                        msg: "Payment done");

                                                    setState(() {
                                                      pay = true;
                                                    });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: res.message
                                                            .toString(),
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red.shade900,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0);
                                                  }
                                                },
                                                onError: (error) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Something went wrong"
                                                              .toString(),
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red.shade900,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                  print("onError: $error");
                                                },
                                                onCancel: (params) {
                                                  Fluttertoast.showToast(
                                                      msg: "Action cancelled"
                                                          .toString(),
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red.shade900,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                }),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, bottom: 18),
                                      child: Text(
                                        'Pay with paypal'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            ),
                            Platform.isIOS
                                ? ApplePayButton(
                                    paymentConfiguration:
                                        PaymentConfiguration.fromJsonString(
                                            defaultApplePay),
                                    paymentItems: _paymentItems,
                                    style: ApplePayButtonStyle.black,
                                    type: ApplePayButtonType.buy,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult: onApplePayResult,
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox(height: 20.0)
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red),
                                  elevation: MaterialStatePropertyAll(0)),
                              onPressed: () async {
                                GoRouter.of(context).go('/home');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18, bottom: 18),
                                  child: Text(
                                    'Go To Home'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  const TextLink(
                    text: "Go to Sign in.",
                    link: '/signin',
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
