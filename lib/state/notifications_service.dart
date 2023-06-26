// import 'package:zense_timer/configs/constants.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationsService {
//   NotificationsService._internal();
//
//   static final _instance = NotificationsService._internal();
//
//   factory NotificationsService() => _instance;
//
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     const AndroidInitializationSettings androidSetting =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     final IOSInitializationSettings iosSetting = IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//
//     final InitializationSettings initSettings =
//         InitializationSettings(android: androidSetting, iOS: iosSetting);
//
//     await _localNotificationsPlugin.initialize(initSettings,
//         onSelectNotification: (payload) async {});
//   }
//
//   Future<dynamic> onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {}
//
//   Future<void> addNotification(
//       {required String title, required String body}) async {
//     const id = 1;
//     //= Random().nextInt(999999999);
//     final androidDetail = AndroidNotificationDetails(
//       id.toString(),
//       '$kAppName channel',
//       '$kAppName channel',
//       priority: Priority.max,
//       importance: Importance.max,
//       ongoing: true,
//       playSound: false,
//     );
//
//     const iosDetail = IOSNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: false,
//     );
//
//     final notificationDetails = NotificationDetails(
//       iOS: iosDetail,
//       android: androidDetail,
//     );
//
//     await _localNotificationsPlugin.show(id, title, body, notificationDetails);
//   }
//
//   Future<void> addScheduledNotification(
//       {required String title,
//       required String body,
//       required int millisecondsToPlay}) async {
//     const id = 1;
//     // = Random().nextInt(999999999);
//
//     final androidDetail = AndroidNotificationDetails(
//       id.toString(),
//       '$kAppName channel',
//       '$kAppName channel',
//       priority: Priority.max,
//       importance: Importance.max,
//       ongoing: true,
//       playSound: false,
//     );
//
//     const iosDetail = IOSNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: false,
//     );
//
//     final notificationDetails = NotificationDetails(
//       iOS: iosDetail,
//       android: androidDetail,
//     );
//
//     tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local)
//         .add(Duration(milliseconds: millisecondsToPlay));
//     _localNotificationsPlugin.zonedSchedule(
//         id, title, body, scheduledTime, notificationDetails,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         androidAllowWhileIdle: true,
//         payload: 'YES');
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await _localNotificationsPlugin.cancelAll();
//   }
// }
