import 'dart:async';

import 'package:american_student_book/layout/common_scaffold.dart';
import 'package:american_student_book/store/store.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:american_student_book/utils/toast.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:american_student_book/utils/formatDateTime.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = false;
  bool _isPlaying = false;
  final player = AudioPlayer();

  String location = "Detecting location...";
  String subscriptionEndDate = "";

  DataStore ds = DataStore.getInstance();
  // ignore: unused_field
  final Completer<GoogleMapController> _controller = Completer();
  bool locationPermitted = false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    _sendSMS();

    setState(() {
      _isLoading = false;
      _isPlaying = true;
      _animationController.forward();
      _playSound();
    });
  }

  void _stopPlaying() {
    setState(() {
      _isPlaying = false;
      _animationController.reverse();
      _stopSound();
    });
  }

  Future<bool> onwilllpop() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
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

    setState(() {
      subscriptionEndDate = prefs.getString('subscriptionEndDate') ?? "";
    });
  }

  void _sendSMS() async {
    try {
      Response res = await ApiClient.sendSOSSMS(location);
      if (res.success == true) {
        showToast(
          "Sent Alert.",
          status: ToastStatus.success,
        );
      } else {
        showToast(
          "Sending alert failed.",
          status: ToastStatus.error,
        );
      }
    } catch (e) {
      print(e);
      showToast(
        "Sending alert failed.",
        status: ToastStatus.error,
      );
    }
  }

  Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null) throw Exception("Not authenticated");
  }

  Future showPic(String pic) => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Image.asset(pic),
          ));

  void _playSound() async {
    await player.play(
      'https://assets.mixkit.co/active_storage/sfx/1642/1642-preview.mp3',
      isLocal: true,
    );

    player.onPlayerCompletion.listen((_) {
      // Call the same function again when the playback is complete
      _playSound();
    });
  }

  void _stopSound() async {
    player.stop();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    checkAuthStatus().then((value) async {
      await getSubscriptionStatus();
      await getCurrentLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onwilllpop,
      child: PageWrapper(
        title: 'Home',
        floatingActionButton: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
//           child: ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStatePropertyAll(Colors.red.shade700),
//                 elevation: const MaterialStatePropertyAll(0)),
//             onPressed: () {
//               // Show the alert modal
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) => AlertModal());
// // _sendSMS();
//             },
//             child: const Padding(
//               padding: EdgeInsets.only(top: 20, bottom: 20),
//               child: Text(
//                 'Send Alert',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
          child: Stack(alignment: Alignment.center, children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) {
                return Container(
                    width: 150.0 + _animationController.value * 100.0,
                    height: 150.0 + _animationController.value * 100.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red));
              },
            ),
            _isLoading && !_isPlaying
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : !_isPlaying
                    ? TextButton(
                        onPressed: _startLoading,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 25),
                        ),
                        child: const Text("SOS"))
                    : TextButton(
                        onPressed: _stopPlaying,
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 25)),
                        child: const Icon(Icons.pause,
                            color: Colors.white, size: 30.0))
          ]),
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
                        options: CarouselOptions(
                            height: 340, animateToClosest: true)),
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
      ),
    );
  }
}
