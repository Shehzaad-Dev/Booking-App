import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  final VoidCallback onLogin;
  const SignupPage({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Name')),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: Text('Sign Up')),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.email),
                  label: Text('Gmail'),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.facebook),
                  label: Text('Facebook'),
                ),
              ],
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: onLogin,
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
