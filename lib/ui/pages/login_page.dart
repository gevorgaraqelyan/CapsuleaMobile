import 'dart:io';

import 'package:capsulea_mobile/core/services/auth_service.dart';
import 'package:capsulea_mobile/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}




class _LoginPageState extends State<LoginPage> {
final _authService = AuthService();

login() async {
    var user = Platform.isAndroid?await _authService.loginWithGoogle():await _authService.loginWithApple();
    if (user != null) {
       setState(() {
      imageUrl = user.photoURL;
    });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home',)),
      );

    }
    }
 

@override
  void initState() {
    super.initState();
   
  }

  String? imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imageUrl != null && imageUrl != '') CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imageUrl!),
            ),
            Icon(Icons.lock),
            SizedBox(height: 20),
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Handle login logic
              },
              child: Text('Login'),
            ),
            if(Platform.isAndroid)
            ElevatedButton(
              onPressed: ()async {
                await login();
              },
              child: Row(
                children: [
                  Text('Login with Google'),
                  FaIcon(FontAwesomeIcons.google),
                ],
              ),
            ),
            if(Platform.isIOS)
            ElevatedButton(
              onPressed: ()async {
                await login();
              },
              child: Row(
                children: [
                  Text('Login with Apple'),
                  FaIcon(FontAwesomeIcons.apple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}