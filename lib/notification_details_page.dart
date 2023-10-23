import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class NotificationDetailsPage extends StatefulWidget {
  final NotificationResponse notificationResponse;

  const NotificationDetailsPage(
      {super.key, required this.notificationResponse});

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уведомление'),
      ),
      body: Center(
              child: Column(
                children: [
                  Text(widget.notificationResponse.payload!.split(';')[0]),
                  SizedBox(height: 8,),
                  Text(widget.notificationResponse.payload!.split(';')[1])
                ],
              ),
            ),
    );
  }


}
