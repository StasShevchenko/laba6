import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDialog extends StatefulWidget {
  final Function(String title, String body, DateTime dateTime)
      onNotificationAdded;

  const NotificationDialog({super.key, required this.onNotificationAdded});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  String _title = "";
  String _body = "";
  bool _isError = false;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Новое уведомление')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Название уведомления"),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _body = value;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Содержание уведомления"),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                'Выбранное время: ${DateFormat("dd.MM.yyyy HH:mm").format(_selectedDate)}'),
            if (_isError) ...{
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Нельзя добавить уведомление на прошедшее время!',
                style: TextStyle(color: Colors.red),
              )
            },
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isError = false;
                  });
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025));
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: const Text('Выбрать день')),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isError = false;
                  });
                  final TimeOfDay? picked = (await showTimePicker(
                      context: context, initialTime: TimeOfDay.now()));
                  setState(() {
                    if (picked != null) {
                      _selectedDate = _selectedDate.copyWith(
                          hour: picked.hour, minute: picked.minute);
                    }
                  });
                },
                child: const Text('Выбрать время'))
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              try {
                if(!_isError && _body.isNotEmpty && _title.isNotEmpty) {
                  await widget.onNotificationAdded(_title, _body, _selectedDate);
                  if(context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              } catch (exception) {
                setState(() {
                  _isError = true;
                });
              }
            },
            child: Text('Добавить'))
      ],
    );
  }
}
