import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:profile_app/src/auth/screens/login.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Ensure flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    sqfliteFfiInit(); // Initialize the FFI
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      home: Login(),
    );
  }
}
