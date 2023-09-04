import 'package:flutter/material.dart';

class ButtonConfirm extends StatelessWidget {
  const ButtonConfirm({super.key, required this.canConfirm});
  final Function(bool) canConfirm;

  @override
  Widget build(BuildContext context) {
    int buttonColor = 0XFFF0A9A9;
    return SizedBox(
      height: 45,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(buttonColor),
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.black,
        ),
        onPressed: () {
          canConfirm(true);
          Navigator.pop(context);
        },
      ),
    );
  }
}
