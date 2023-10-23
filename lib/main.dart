
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laba6/create_notification_dialog.dart';
import 'package:laba6/notification_details_page.dart';
import 'package:laba6/notification_item.dart';
import 'package:laba6/notification_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  NotificationResponse? response =
      notificationAppLaunchDetails?.notificationResponse;
  runApp(MyApp(
    notificationResponse: response,
  ));
}

class MyApp extends StatelessWidget {
  NotificationResponse? notificationResponse;

  MyApp({super.key, required this.notificationResponse});

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
      home: MyHomePage(
        notificationResponse: notificationResponse,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  NotificationResponse? notificationResponse;

  MyHomePage({super.key, required this.notificationResponse});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    if (widget.notificationResponse != null) {
      Future(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotificationDetailsPage(
                notificationResponse: widget.notificationResponse!)));
      });
    }
    NotificationManager.initialize(flutterLocalNotificationsPlugin,
        (notification) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              NotificationDetailsPage(notificationResponse: notification)));
    });
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
              : RefreshIndicator(
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
               loadNotifications();
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
