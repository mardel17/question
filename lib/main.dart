import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

import 'package:question/provider/home_provider.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/globals.dart' as Globals;
import 'package:question/view/billing_page.dart';
import 'package:question/view/create_page.dart';
import 'package:question/view/detail_page.dart';
import 'package:question/view/home_page.dart';
import 'package:question/view/login_page.dart';
import 'package:question/view/payment_page.dart';
import 'package:question/view/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> _getToken() async {
    String token = await _firebaseMessaging.getToken();

    // assert(token != null);
    Globals.deviceToken = token;
  }

  @override
  Widget build(BuildContext context) {
    _getToken();
    _initFirebaseMessaging(context);
    FlutterStatusbarcolor.setStatusBarColor(COLOR.BLUE);

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: HomeProvider())],
      child: MaterialApp(
        title: 'Questionne Moi',
        theme: ThemeData(
          primaryColor: COLOR.BLUE,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: ROUTE.LOGIN,
        routes: {
          ROUTE.LOGIN: (context) => LoginPage(),
          ROUTE.SIGNUP: (context) => SignupPage(),
          ROUTE.HOME: (context) => HomePage(),
          ROUTE.CREATE: (context) =>
              CreatePage(isQCM: ModalRoute.of(context).settings.arguments),
          ROUTE.PAYMENT: (context) =>
              PaymentPage(data: ModalRoute.of(context).settings.arguments),
          ROUTE.BILLING: (context) =>
              BillingPage(data: ModalRoute.of(context).settings.arguments),
          ROUTE.DETAIL: (context) =>
              DetailPage(id: ModalRoute.of(context).settings.arguments),
        },
      ),
    );
  }

  void _initFirebaseMessaging(BuildContext context) {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    if (Theme.of(context).platform != TargetPlatform.android) return;

//Android Only
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher_round');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        int notificaitonID = 1 + Random().nextInt(10000);
        String title = message['notification']['title'];
        String body = message['notification']['body'];

        _showNotification(notificaitonID, title, body, "");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = 'question_relation_android_notification',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.High,
    Importance notificationImportance = Importance.Max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: true,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
