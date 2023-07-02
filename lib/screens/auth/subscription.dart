import 'package:flutter/foundation.dart';
import 'package:student_lifeline/components/auth/text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_lifeline/components/logo.dart';
import 'package:pay/pay.dart';
import 'package:student_lifeline/config/subscription.dart';
import 'package:student_lifeline/utils/toast.dart';
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
      amount: SUBSCRIPTION_PRICE,
      status: PaymentItemStatus.final_price,
    )
  ];

  void onApplePayResult(result) {
    if (kDebugMode) {
      print('result $result');
    }
    onSubScribeOneYear();
  }

  void onSubScribeOneYear() async {
    Response res = await ApiClient.subscribeForAYear();

    if (res.success == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isActivated', true);

      showToast("Payment done", status: ToastStatus.success);

      setState(() {
        pay = true;
      });
    } else {
      (res.message?.isNotEmpty == true)
          ? showToast(res.message!, status: ToastStatus.error)
          : null;
    }
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
                          '''Subscribe to one of America's most efficient. and reasonably priced Emergency Alert Systems that can save a loved one from the worry of being alone when in trouble, without a means to reach out to those who care most for their well being and safety, only \$$SUBSCRIPTION_PRICE $CURRENCY a year, instantly alerts up to three contacts simultaneously...subscribe below: ''',
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
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox(
                                width: 250,
                                height: 40,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.blue),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UsePaypal(
                                                sandboxMode: DEVELOPMENT_MODE,
                                                clientId: PAYPAL_CLIENT_ID,
                                                secretKey: PAYPAL_SECRET_KEY,
                                                returnURL: RETURN_RUL,
                                                cancelURL: CANCEL_URL,
                                                transactions: const [
                                                  {
                                                    "amount": {
                                                      "total":
                                                          SUBSCRIPTION_PRICE,
                                                      "currency": CURRENCY,
                                                      "details": {
                                                        "subtotal":
                                                            SUBSCRIPTION_PRICE,
                                                        "shipping": '0',
                                                        "shipping_discount": 0
                                                      }
                                                    },
                                                    "description":
                                                        "Payment for Student LifeLine Subscription.",
                                                    "item_list": {
                                                      "items": [
                                                        {
                                                          "name":
                                                              "Student LifeLine",
                                                          "quantity": 1,
                                                          "price":
                                                              SUBSCRIPTION_PRICE,
                                                          "currency": CURRENCY
                                                        }
                                                      ],
                                                    }
                                                  }
                                                ],
                                                note:
                                                    "Contact us for any questions on your order.",
                                                onSuccess: (Map params) async {
                                                  onSubScribeOneYear();
                                                },
                                                onError: (error) {
                                                  showToast(
                                                      "Something went wrong",
                                                      status:
                                                          ToastStatus.error);
                                                },
                                                onCancel: (params) {
                                                  showToast("Action cancelled",
                                                      status:
                                                          ToastStatus.warning);
                                                }),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Subscribe with PayPal',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                    type: ApplePayButtonType.subscribe,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult: onApplePayResult,
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    height: 40,
                                    width: 250, //
                                  )
                                : const SizedBox(height: 0.0)
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
                  pay == false
                      ? const TextLink(
                          text: "Go to Sign in.",
                          link: '/signin',
                        )
                      : const SizedBox(
                          height: 0,
                        )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
