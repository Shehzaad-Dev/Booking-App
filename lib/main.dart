import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // Removed Firebase import
import 'pages/search_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_router.dart' as app_router;
import 'pages/saved_page.dart';
import 'pages/bookings_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp(); // Removed Firebase initialization
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int onboardingIndex = 0;
  bool onboardingComplete = false;
  bool signedIn = false;
  bool showSignup = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      theme: AppTheme.lightTheme,
      onGenerateRoute: app_router.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    // If onboarding is not complete, show the onboarding page.
    if (!onboardingComplete) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Onboarding Page',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    onboardingComplete = true;
                  });
                },
                child: Text('Skip Onboarding'),
              ),
            ],
          ),
        ),
      );
    }

    // If the user is not signed in, show the login or signup page.
    if (!signedIn) {
      if (showSignup) {
        return SignupPage(
          onLogin: () {
            setState(() {
              showSignup = false;
            });
          },
          onSignupSuccess: () {
            setState(() {
              signedIn = true;
              showSignup = false;
            });
          },
        );
      } else {
        return LoginPage(
          onSignup: () {
            setState(() {
              showSignup = true;
            });
          },
          onLoginSuccess: () {
            setState(() {
              signedIn = true;
              showSignup = false;
            });
          },
        );
      }
    }

    // If onboarding is complete and the user is signed in, show the main app.
    return MainNavigation(
      onSignOut: () {
        setState(() {
          signedIn = false;
        });
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final VoidCallback? onSignOut;

  const MainNavigation({super.key, this.onSignOut});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      SearchPage(),
      SavedPage(),
      BookingsPage(),
      ProfilePage(onSignOut: widget.onSignOut),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
