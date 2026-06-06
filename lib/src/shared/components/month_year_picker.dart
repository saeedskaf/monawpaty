import 'package:flutter/material.dart';
import 'package:monawpaty/src/shared/styles/colors.dart';

class MonthYearPicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;

  const MonthYearPicker({Key? key, required this.onDateTimeChanged})
      : super(key: key);

  @override
  MonthYearPickerState createState() => MonthYearPickerState();
}

class MonthYearPickerState extends State<MonthYearPicker> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton<int>(
          underline: Container(height: 2, color: secondaryColor),
          value: _dateTime.month,
          onChanged: (int? month) {
            setState(() {
              _dateTime = DateTime(_dateTime.year, month!, _dateTime.day);
              widget.onDateTimeChanged(_dateTime);
            });
          },
          items: List.generate(12, (int index) {
            int month = index + 1;
            return DropdownMenuItem<int>(
              value: month,
              child: Text('$month'),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Container(height: 2, color: secondaryColor, width: 12),
        ),
        DropdownButton<int>(
          underline: Container(height: 2, color: secondaryColor),
          value: _dateTime.year,
          onChanged: (int? year) {
            setState(() {
              _dateTime = DateTime(year!, _dateTime.month, _dateTime.day);
              widget.onDateTimeChanged(_dateTime);
            });
          },
          items: List.generate(3, (int index) {
            int year = DateTime.now().year - 1 + index;
            return DropdownMenuItem<int>(
              value: year,
              child: Text('$year'),
            );
          }),
        ),
      ],
    );
  }
}
