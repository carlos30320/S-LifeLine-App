import 'dart:async';

import 'package:american_student_book/layout/common_scaffold.dart';
import 'package:american_student_book/store/store.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:american_student_book/utils/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_sms/background_sms.dart';
import 'package:american_student_book/utils/formatDateTime.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "Detecting location...";
  String log = "Your membership will end on 25th July";
  DataStore ds = DataStore.getInstance();
  // ignore: unused_field
  final Completer<GoogleMapController> _controller = Completer();
  bool smsPermitted = false;
  bool locationPermitted = false;
  String subscriptionEndDate = "";

  Future<void> requestSmsPermission() async {
    if (await Permission.sms.isDenied) {
      await Permission.sms.request();
    } else {
      setState(() {
        smsPermitted = true;
      });
    }
  }

  Future<void> getCurrentLocation() async {
    if (ds.location.isSet()) {
      setState(() {
        location =
            "Latutude: ${ds.location.latitude}, Longitude: ${ds.location.longitude}";
      });
    }
    await Geolocator.requestPermission();
    if (await Permission.location.isDenied) {
      await requestSmsPermission();
      await getCurrentLocation();
    } else {
      setState(() {
        locationPermitted = true;
      });
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        location =
            "Latutude: ${position.latitude}, Longitude: ${position.longitude}";
        ds.location
            .set(position.latitude.toString(), position.longitude.toString());
      });
    }
  }

  Future<void> getSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the user is logged in
    subscriptionEndDate = prefs.getString('subscriptionEndDate') ?? "";
  }

  void _sendSMS() async {
    if (await Permission.sms.isGranted) {
      final prefs = await SharedPreferences.getInstance();

      // Check if the user is logged in
      String username = prefs.getString('username') ?? "";
      String message = '$username is asking for help at $location';

      Response res = await ApiClient.getContacts();
      if (res.success == true) {
        var nums = res.data['contacts'];

        if (nums.length == 0) {
          showToast("You have no number registered",
              status: ToastStatus.warning);
        } else {
          nums.forEach((element) async {
            SmsStatus result = await BackgroundSms.sendMessage(
                phoneNumber: element['phoneNumber'],
                message: message,
                simSlot: 1);

            if (result == SmsStatus.sent) {
              showToast(
                "Message sent to ${element['name']}(${element['phoneNumber']}).",
                status: ToastStatus.success,
              );
            } else {
              showToast(
                "Failed to send message to ${element['name']}(${element['phoneNumber']}).",
                status: ToastStatus.error,
              );
            }
          });
        }
      } else {
        showToast(
          "Aww! Something went wrong while getting phone numbers",
          status: ToastStatus.error,
        );
      }
    } else {
      await requestSmsPermission();
      _sendSMS();
    }
  }

  Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null) throw Exception("Not authenticated");
  }

  @override
  void initState() {
    checkAuthStatus().then((value) async {
      await requestSmsPermission();
      await getSubscriptionStatus();
      await getCurrentLocation();
    });
    super.initState();
  }

  Future showPic(String pic) => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Image.asset(pic),
          ));

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Home',
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red.shade700),
              elevation: const MaterialStatePropertyAll(0)),
          onPressed: () => _sendSMS(),
          child: const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              'Send Alert',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: Material(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  CarouselSlider(
                      items: [
                        'assets/5.png',
                        'assets/6.png',
                        'assets/7.png',
                        "assets/1.png",
                        'assets/2.png',
                        'assets/3.png',
                        'assets/4.png',
                        'assets/logo.png',
                      ]
                          .map(
                            (e) => ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white)),
                              onPressed: () => showPic(e),
                              child: Expanded(
                                child: Image.asset(
                                  e,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      options:
                          CarouselOptions(height: 340, animateToClosest: true)),
                  const SizedBox(
                    height: 6,
                  ),
                  // Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       ds.location.isSet()
                  //           ? GoogleMap(
                  //               onMapCreated: (controller) => setState(() {
                  //                     _controller.complete(controller);
                  //                   }),
                  //               initialCameraPosition: CameraPosition(
                  //                   target: LatLng(
                  //                       double.parse(ds.location.latitude!),
                  //                       double.parse(ds.location.longitude!)),
                  //                   zoom: 15))
                  //           : const CircularProgressIndicator(),
                  //     ]),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on_rounded,
                                    color: Colors.black),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Location',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              location,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  if (subscriptionEndDate != "")
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red.shade100.withOpacity(0.5),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Your subscription is valid until the ${formatDate(subscriptionEndDate)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: Colors.red.shade700),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
