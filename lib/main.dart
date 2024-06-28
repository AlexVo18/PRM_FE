import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_shop/Screens/Home/home.dart';
import 'package:smart_shop/Utils/Constants/app_constants.dart';
import 'package:smart_shop/Utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
      designSize: const Size(375, 812),
      // Example design size
      rebuildFactor: RebuildFactors.sizeAndViewInsets,
      // Example rebuild factor
      ensureScreenSize: true,
      // Ensure screen size asynchronously
      enableScaleWH: () => true,
      // Example scale enablement
      fontSizeResolver: FontSizeResolvers.width, // Example font size resolver
    ),
  );
}
