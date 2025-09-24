import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(
                    AppTheme.borderRadiusLarge,
                  ),
                ),
                child: const Icon(
                  Icons.flight,
                  color: AppTheme.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXL),

              // Title
              Text(
                'Welcome to Booking App',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingM),

              // Description
              Text(
                'Discover amazing places to stay, rent cars, book taxis, and explore attractions around the world.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.secondaryText),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingXL),

              // Get started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onNext,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
