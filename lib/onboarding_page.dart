import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final int pageIndex;
  final VoidCallback onNext;
  const OnboardingPage({
    super.key,
    required this.pageIndex,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Welcome to Booking',
      'Find Your Perfect Stay',
      'Book Easily & Save More',
    ];
    final descriptions = [
      'Discover hotels, flights, cars, and attractions all in one app.',
      'Search, save, and book with exclusive deals and offers.',
      'Enjoy seamless booking and special discounts for your travels.',
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for image
            Container(
              height: 200,
              width: 200,
              color: Colors.grey[300],
              child: Center(child: Text('Image ${pageIndex + 1}')),
            ),
            SizedBox(height: 32),
            Text(
              titles[pageIndex],
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              descriptions[pageIndex],
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: onNext,
              child: Text(pageIndex < 2 ? 'Next' : 'Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
