import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onSignup;
  const LoginPage({super.key, required this.onSignup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Username')),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: Text('Sign In')),
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
              onPressed: onSignup,
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
