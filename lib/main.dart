import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_lec/firebase_options.dart';
import 'package:money_lec/screens/login_screen.dart';
import 'package:money_lec/theme/theme.dart';
import 'package:money_lec/theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeManager themeManager = ThemeManager();

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginScreen(),
      themeMode: themeManager.themeMode,
      theme: AppTheme.lightTheme,
    );
  }
}
