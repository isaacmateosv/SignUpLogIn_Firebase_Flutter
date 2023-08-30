import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    String email = "";
    String password = "";

    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'User'),
              onChanged: (value) {
                email = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginProvider.logIn(email, password);
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
