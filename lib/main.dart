import 'package:flutter/material.dart';
import 'package:mapazimslupsk/Pages/Core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapazimslupsk/Pages/Home.dart';
import 'package:mapazimslupsk/Pages/Map.dart';
import 'package:mapazimslupsk/Pages/Weekdays/Stops.dart';
import 'package:mapazimslupsk/Pages/Saturdays/StopsSat.dart';
import 'package:mapazimslupsk/Pages/Sundays/StopsSun.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:mapazimslupsk/Pages/StopsList.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

FirebaseApp defaultApp = Firebase.app();
FirebaseMessaging messaging = FirebaseMessaging.instance;
FirebaseAnalytics analytics = FirebaseAnalytics();

String defaultNameExtractor(RouteSettings settings) => settings.name;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MobileAds.instance.initialize();

  runApp(
    Provider.value(
      builder: (context, child) => MaterialApp(
        routes: {
          '/': (context) => CorePage(),
          '/stops': (context) => StopsPage(),
          '/stopsSat': (context) => StopsSatPage(),
          '/stopsSun': (context) => StopsSunPage(),
          '/map': (context) => MapPage(),
          '/stopsList': (context) => StopsList(),
          '/home': (context) => HomePage(),
        },
      )
    )
  );
}

