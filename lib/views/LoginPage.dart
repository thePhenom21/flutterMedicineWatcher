import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicineapp/views/HomePage.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<GoogleSignInAccount?> _handleSignIn() async {
  try {
    return await _googleSignIn.signIn();
  } catch (error) {
    print("error: $error");
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          id = await _handleSignIn().then((value) => value!.email);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomePage(userId: id!)));
        },
        child: Text("Google Sign in"),
      )),
    );
  }
}
