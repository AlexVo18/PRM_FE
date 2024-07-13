import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/api/notifi_service.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/utils/preUtils.dart';
import 'package:shop_app/utils/utils.dart';

import 'routes.dart';
import 'theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Initialize Firebase asynchronously before creating the MaterialApp widget
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  await notificationService.requestExactAlarmPermission();

  PrefUtil.init();
  Stripe.publishableKey =
      "pk_test_51PbO7LRpGRSEJtbQNNaAI6fymKKfuVzN2d7xeqvEpkqf9UEgg3STuNYp1ttFOLLDoZdmDg5tpCTyo2sEfr0YviLp00XrtkKiAU";
  await Stripe.instance.applySettings();

  bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
  if (isSupported) {
    print("Device supports app badges.");
    FlutterAppBadger.updateBadgeCount(5);
  } else {
    print("Device does not support app badges.");
  }

  //runApp(MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider()..loadCart(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lego App',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      navigatorKey: navigatorKey,
      routes: routes,
    );
  }
}
