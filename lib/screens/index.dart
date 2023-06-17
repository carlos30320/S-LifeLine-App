import 'dart:async';

import 'package:american_student_book/layout/commonScaffold.dart';
import 'package:american_student_book/store/store.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_sms/background_sms.dart';

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

  Future<void> requestSmsPermission() async {
    if (await Permission.sms.isDenied) {
      await Permission.sms.request();
    } else {
      setState(() {
        smsPermitted = true;
      });
    }
  }

  void _liveLocation() {
    LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position position) {
      setState(() {
        location =
            "Latutude: ${position.latitude}, Longitude: ${position.longitude}";
        ds.location
            .set(position.latitude.toString(), position.longitude.toString());
      });
    });
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

  void _sendSMS(String message, List<String> recipents) async {
    if (await Permission.sms.isGranted) {
      if (recipents.isEmpty) {
        Fluttertoast.showToast(
            msg: "You have no number registered".toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade900,
            textColor: Colors.white,
            fontSize: 14.0);
        return;
      }
      recipents.forEach((rec) async {
        SmsStatus result = await BackgroundSms.sendMessage(
            phoneNumber: rec, message: message, simSlot: 1);
        if (result == SmsStatus.sent) {
          Fluttertoast.showToast(
            msg: "Message sent to $rec",
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Failed to send message to $rec",
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
        }
      });

      Fluttertoast.showToast(
        msg: "Message sent successfully",
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } else {
      await requestSmsPermission();
      _sendSMS(message, recipents);
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
      await getCurrentLocation();
      _liveLocation();
    });
    super.initState();
  }

  Future showPic(String pic) => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Image.asset(pic),
          ));

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('username');
    GoRouter.of(context).go('/signin');
  }

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
          onPressed: () => _sendSMS(
              "${ds.getUsername()} is asking for help at ${location}",
              ds.phoneNumbers.map((e) => e.phonenumber).toList()),
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
                        "assets/001.png",
                        'assets/002.png',
                        'assets/003.png',
                        'assets/004.png',
                        'assets/005.png',
                        'assets/006.png',
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red.shade100.withOpacity(0.5),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Your membership will be ended at 25th July',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Colors.red.shade700),
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
