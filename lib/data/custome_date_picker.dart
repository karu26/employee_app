import 'package:employee_managemnet/data/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final String comeFrom;
  final DateTime? fromDateCome;
  final DateTime? endDateCoem;
  final Function(DateTime?) onDateSelected;

  const CustomDatePickerDialog({
    Key? key,
    required this.onDateSelected,
    required this.comeFrom, this.fromDateCome, this.endDateCoem,
  }) : super(key: key);

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? _selectedDate;
  DateTime? _fromDate; // Store the "From Date"


  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fromDate=widget.fromDateCome;
  }

 /* void _selectDate(DateTime? date) {
    setState(() {
      _selectedDate = date != null ? _normalizeDate(date) : null;
    });
  }*/


  void _selectDate(DateTime? date) {
    print("Selected date: $date");

    // Ensure _fromDate is not null before checking its value
    if ((_fromDate != null && _fromDate!.isAtSameMomentAs(DateTime.now()))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("End Date cannot be selected if From Date is today."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _selectedDate = date;

      if (widget.comeFrom == "1") {
        _fromDate = date; // Store From Date
      }
    });
  }


  void _saveDate() {
    widget.onDateSelected(_selectedDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          // Quick Select Buttons
          widget.comeFrom == "1"
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _quickSelectButton("Today", DateTime.now()),
              const SizedBox(width: 10),
              _quickSelectButton("Next Monday", _nextWeekday(DateTime.monday)),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _quickSelectButtonForEnd("No Date",null),
              const SizedBox(width: 10),
              _quickSelectButtonForEnd("Today",DateTime.now()),
            ],
          ),

          const SizedBox(height: 10),

          widget.comeFrom == "1"
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _quickSelectButton("Next Tuesday", _nextWeekday(DateTime.tuesday)),
              const SizedBox(width: 10),
              _quickSelectButton("After 1 Week", DateTime.now().add(Duration(days: 7))),
            ],
          )
              : Container(),

          const SizedBox(height: 12),

          // Calendar Picker
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorManager.blutColor, // Changes selection color to blue
                onPrimary: Colors.white, // Text color on selected date
                onSurface: Colors.black, // Default text color
              ),
            ),



            child: CalendarDatePicker(
              key: ValueKey(_selectedDate), // Forces rebuild when date changes
              initialDate:  _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020), // Allow past selection for From Date

              lastDate: (widget.fromDateCome ?? DateTime.now()).isAtSameMomentAs(DateTime.now()) || widget.comeFrom=="2"
                  ? DateTime.now() // If fromDateCome is today, restrict End Date to today
                  : DateTime(2030),
              onDateChanged: _selectDate,
            ),
          ),


          const SizedBox(height: 12),

          // Selected Date Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Image.asset("assest/images/calender.png"),
                  const SizedBox(width: 5),
                  Text(
                    _selectedDate != null ? DateFormat("d MMM yyyy").format(_selectedDate!) : "No Date",
                    style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: ColorManager.dateCOlr),
                  ),
                ],
              ),
              Row(
                children: [
                  _bottomButton("Cancel", Colors.blue.shade100, Colors.blue, () => Navigator.pop(context)),
                  const SizedBox(width: 5),
                  _bottomButton("Save", Colors.blue, Colors.white, _saveDate),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // 🔹 Fix: Normalize Date to Midnight
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // 🔹 Updated Quick Select Button with Fix
  Widget _quickSelectButton(String label, DateTime date) {
    bool isSelected = _selectedDate != null && _selectedDate!.isAtSameMomentAs(_normalizeDate(date));

    return GestureDetector(
      onTap: () => _selectDate(date),
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        width: 150.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: isSelected ? ColorManager.blutColor : ColorManager.cancelButton,
        ),
        child: FittedBox(

          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.blue,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  // Quick Select Button for "No Date"
  Widget _quickSelectButtonForEnd(String label,DateTime? date) {
    //bool isSelected = _selectedDate == null;

    return GestureDetector(
      onTap: () => _selectDate(null),
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        width: 150.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: _selectedDate==date ||date==null ? ColorManager.blutColor:ColorManager.cancelButton,
        ),
        child: Text(
          label,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            color: _selectedDate==date ||date==null?Colors.white:ColorManager.blutColor,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  // Bottom Button (Cancel/Save)
  Widget _bottomButton(String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size(100, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          color: textColor,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  // Get Next Weekday
  DateTime _nextWeekday(int weekday) {
    DateTime now = DateTime.now();
    int daysToAdd = (weekday - now.weekday + 7) % 7;
    return _normalizeDate(now.add(Duration(days: daysToAdd == 0 ? 7 : daysToAdd)));
  }
}
