import 'package:flutter/material.dart';

class DateTimeSelector extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(DateTime, TimeOfDay) onDateTimeChanged;

  const DateTimeSelector({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateTimeChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      onDateTimeChanged(picked, selectedTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedDate) {
      onDateTimeChanged(selectedDate, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today),
            label: Text(
                'Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectTime(context),
            icon: const Icon(Icons.access_time),
            label: Text('Time: ${selectedTime.format(context)}'),
          ),
        ),
      ],
    );
  }
}
