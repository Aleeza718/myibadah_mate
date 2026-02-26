import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await Hive.openBox('namazBox');
  await Hive.openBox('daily_card');
  await Hive.openBox('tasbihbox');
  await Hive.openBox('hijriBox');
  await Hive.openBox('prayerBox');

  runApp(const MyApp());
}