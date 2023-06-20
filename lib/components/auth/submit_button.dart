import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String buttonText;

  const SubmitButton(
      {Key? key,
      required this.isLoading,
      required this.onPressed,
      required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              elevation: MaterialStateProperty.all<double>(0)),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 18),
            child: !isLoading
                ? Text(
                    buttonText,
                    style: const TextStyle(fontSize: 14),
                  )
                : const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
