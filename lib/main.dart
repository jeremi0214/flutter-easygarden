import 'package:easygarden/auth/auth.dart';
import 'package:easygarden/auth/login_or_register.dart';
import 'package:easygarden/firebase_options.dart';
import 'package:easygarden/pages/home_page.dart';
import 'package:easygarden/pages/profile_page.dart';
import 'package:easygarden/pages/providers_page.dart';
import 'package:easygarden/pages/register_provider_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'theme/dark_mode.dart';
import 'theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_or_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/providers_page': (context) => ServiceProviderPage(),
        '/register_provider_page': (context) => RegisterGardenerPage(),
      }
    );
  }
}