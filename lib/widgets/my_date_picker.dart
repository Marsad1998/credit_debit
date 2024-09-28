import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  final DateTime initialDate;
  final Function(DateTime) onDateSelected; // Callback to pass the selected date

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late DateTime _selectedDate; // Internal state for selected date

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate; // Set initial date
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(
          _selectedDate); // Pass the selected date to the parent
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd - MMMM - yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      onPressed: () => _selectDate(context), // Open date picker
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Text(
            _formatDate(_selectedDate), // Show the selected date
            style: const TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
