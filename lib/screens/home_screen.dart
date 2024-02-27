import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String phoneNumber = "";
  
  @override
  void initState() {
    super.initState();
    fetchUserPhoneNumber();
  }

  void fetchUserPhoneNumber() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      phoneNumber = user.phoneNumber ?? "Phone number not available";
      setState(() {});
    }
  }

  void onPressed() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'User Phone Number: $phoneNumber',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
