import 'dart:async';
import 'package:flutter/material.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    // Call the API here and wait for response
    await Future.delayed(const Duration(seconds: 1));

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

  void _playSound() async {
    // // const platform = MethodChannel(
    // //     'https://assets.mixkit.co/active_storage/sfx/1642/1642-preview.mp3');
    // try {
    //   await platform.invokeMethod('play');
    // } catch (e) {
    //   print(e);
    // }
  }

  void _stopSound() async {
    // const platform = MethodChannel(
    //     'https://assets.mixkit.co/active_storage/sfx/1642/1642-preview.mp3');
    // try {
    //   await platform.invokeMethod('stop');
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
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
                  child:
                      const Icon(Icons.pause, color: Colors.white, size: 30.0))
    ]);
  }
}
