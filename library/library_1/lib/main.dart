import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_1/firebase_options.dart';
import 'package:library_1/home.dart';
// import 'package:library_1/screen/loginscree.dart';
// import 'package:library_1/screen/phonenumber.dart';
import 'package:library_1/screen/spash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(), // Use HomeScreen class here
      },
    );
  }
}
