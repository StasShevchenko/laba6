import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laba6/create_notification_dialog.dart';
import 'package:laba6/notification_item.dart';
import 'package:laba6/notification_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    NotificationManager.initialize(flutterLocalNotificationsPlugin);
    loadNotifications();
  }

  void loadNotifications() async {
    final notifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    setState(() {
      _pendingNotifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Уведомления'),
      ),
      body: Center(
          child: _pendingNotifications.isEmpty
              ? Text('Список уведомлений пуст')
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      loadNotifications();
                    },
                    child: ListView.builder(
                        itemCount: _pendingNotifications.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NotificationItem(
                                onDeletePressed: () async {
                                  await flutterLocalNotificationsPlugin
                                      .cancel(_pendingNotifications[index].id);
                                  loadNotifications();
                                },
                                notificationData: _pendingNotifications[index]),
                          );
                        }),
                  ),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNotificationDialog(
              context: context,
              onNotificationAdded: (title, body, dateTime) async {
                await NotificationManager.schedule(
                    title: title,
                    body: body,
                    dateTime: dateTime,
                    fln: flutterLocalNotificationsPlugin);
                final notifications = await flutterLocalNotificationsPlugin
                    .pendingNotificationRequests();
                setState(() {
                  _pendingNotifications = notifications;
                });
              });
        },
        child: Icon(Icons.add_alert),
      ),
    );
  }

  void _showAddNotificationDialog(
      {required BuildContext context,
      required Function(String title, String body, DateTime dateTime)
          onNotificationAdded}) {
    showDialog(
        context: context,
        builder: (context) {
          return NotificationDialog(
            onNotificationAdded: onNotificationAdded,
          );
        });
  }
}
