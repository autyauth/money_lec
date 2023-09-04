import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ButtonDate extends StatefulWidget {
  const ButtonDate({super.key, required this.onPressed});
  final Function(DateTime) onPressed;
  @override
  State<ButtonDate> createState() => _ButtonDateState();
}

class _ButtonDateState extends State<ButtonDate> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 240, 169, 169),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          DateFormat.Md().format(_selectedDate),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0XFFFF69B4), // <-- SEE HERE
                      onPrimary: Colors.white, // <-- SEE HERE
                      onSurface: Colors.black, // <-- SEE HERE
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              });
          if (newDate == null) return;
          setState(() {
            _selectedDate = newDate;
          });
          widget.onPressed(_selectedDate);
        },
      ),
    );
  }
}
