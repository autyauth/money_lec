// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ButtonIsExpense extends StatefulWidget {
  const ButtonIsExpense({super.key, required this.onPressed});
  final Function(bool) onPressed;

  @override
  State<ButtonIsExpense> createState() => _ButtonIsExpenseState();
}

class _ButtonIsExpenseState extends State<ButtonIsExpense> {
  bool _isExpense = false;
  String _buttonText = 'รายรับ';
  int _buttonColor = 0XFFF0A9A9;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(_buttonColor),
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          _buttonText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          if (_isExpense) {
            setState(() {
              _isExpense = false;
              _buttonText = 'รายรับ';
              _buttonColor = 0XFFF0A9A9;
            });
          } else {
            setState(() {
              _isExpense = true;
              _buttonText = 'รายจ่าย';
              _buttonColor = 0XFFFF6666;
            });
          }
          widget.onPressed(_isExpense);
        },
      ),
    );
  }
}
