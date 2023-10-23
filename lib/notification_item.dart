import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final PendingNotificationRequest notificationData;
  final Function onDeletePressed;

  const NotificationItem(
      {super.key,
      required this.notificationData,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notificationData.title!),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(notificationData.body!),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                            "Время: ${DateFormat("dd.MM.yyyy HH:mm").format(DateTime.parse(notificationData!.payload!.split(';')[2]))}"),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      onDeletePressed();
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
