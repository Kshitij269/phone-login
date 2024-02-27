import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_otp/firebase_options.dart';
import 'package:mobile_otp/screens/home_screen.dart';
import 'package:mobile_otp/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flazetech',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // User is logged in
              return const HomeScreen();
            } else {
              // No authenticated user (user logged out)
              return const LoginScreen();
            }
          }
          // Loading or other states
          return Scaffold(
            body: Center(
              child: Container(
                child: Text("data"),
              ),
            ),
          );
        },
      ),
    );
  }
}
