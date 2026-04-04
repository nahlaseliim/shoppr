import 'package:device_preview/device_preview.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/screens/startup_screen.dart';
import 'package:provider/provider.dart';
import 'state/auth_state.dart';
import 'state/cart_state.dart';

void main() {
  runApp(
    DevicePreview(
        enabled: !kReleaseMode,
      builder: (BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthState()),
          ChangeNotifierProvider(create: (_) => CartState()),
        ],
        child: const ShopprApp(),
      ),
    ),
  );
}

class ShopprApp extends StatelessWidget {
  const ShopprApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoppr',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF09A7E1)),
        useMaterial3: true,
      ),
      home: const StartupScreen(),
    );
  }
}

