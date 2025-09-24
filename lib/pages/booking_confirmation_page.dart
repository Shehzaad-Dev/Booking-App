import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String itemName;
  final String? firstName;

  const BookingConfirmationPage({
    super.key,
    required this.itemName,
    this.firstName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back to room options or previous screen
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Booking Confirmed',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          margin: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 72),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'Booking confirmed!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                '${firstName != null && firstName!.isNotEmpty ? firstName : 'You'}, your reservation for "$itemName" is set. Check your email for details.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to main app and show message to guide user to bookings
                    Navigator.popUntil(context, (route) => route.isFirst);
                    // Show a message to guide user to bookings tab
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Your booking is confirmed! Go to Bookings tab to view details.',
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('View My Bookings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
