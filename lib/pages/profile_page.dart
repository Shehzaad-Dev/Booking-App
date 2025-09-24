import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_auth_service.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onSignOut;

  const ProfilePage({super.key, this.onSignOut});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    setState(() {
      _isSigningOut = true;
    });

    try {
      await MockAuthService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed out.'),
            backgroundColor: AppTheme.primaryBlue,
          ),
        );
        widget.onSignOut?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with profile info
            _buildHeader(),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildGeniusRewardsSection(),
                    _buildCreditsSection(),
                    _buildPaymentSection(),
                    _buildManageAccountSection(),
                    _buildHelpSection(),
                    _buildLegalSection(),
                    _buildDiscoverSection(),
                    _buildSignOutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.headerBackground,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppTheme.accentGreen,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'B',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacingM),

          // Profile info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    Text(
                      'Genius ',
                      style: TextStyle(
                        color: AppTheme.accentYellow,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Level 1',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right side icons
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppTheme.white,
                  size: 24,
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.white,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppTheme.errorRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeniusRewardsSection() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Gift box icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppTheme.borderRadiusSmall,
                  ),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: AppTheme.primaryBlue,
                  size: 30,
                ),
              ),

              const SizedBox(width: AppTheme.spacingM),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You have 2 Genius rewards',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    const Text(
                      '10% discounts and so much more!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryText,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Progress text
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.lightGrey,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    'You\'re 5 bookings away from Genius Level 2',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Wallet icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.lightGrey,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppTheme.secondaryText,
              size: 30,
            ),
          ),

          const SizedBox(width: AppTheme.spacingM),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No Credits or vouchers yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                const Text(
                  'PKR 0',
                  style: TextStyle(fontSize: 14, color: AppTheme.secondaryText),
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.secondaryText,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return _buildSection('Payment information', [
      _buildMenuItem('Rewards & Wallet', Icons.account_balance_wallet, () {}),
      _buildMenuItem('Payment methods', Icons.credit_card, () {}),
    ]);
  }

  Widget _buildManageAccountSection() {
    return _buildSection('Manage account', [
      _buildMenuItem('Personal details', Icons.person, () {}),
      _buildMenuItem('Security settings', Icons.lock, () {}),
      _buildMenuItem('Other travellers', Icons.people, () {}),
    ]);
  }

  Widget _buildHelpSection() {
    return _buildSection('Help and support', [
      _buildMenuItem('Contact Customer service', Icons.help_outline, () {}),
      _buildMenuItem('Safety resource centre', Icons.security, () {}),
      _buildMenuItem('Dispute resolution', Icons.handshake, () {}),
    ]);
  }

  Widget _buildLegalSection() {
    return _buildSection('Legal and privacy', [
      _buildMenuItem('Privacy and data management', Icons.privacy_tip, () {}),
      _buildMenuItem('Content guidelines', Icons.description, () {}),
    ]);
  }

  Widget _buildDiscoverSection() {
    return _buildSection('Discover', [
      _buildMenuItem('Deals', Icons.local_offer, () {}),
    ]);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingL),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        ),
        child: Icon(icon, color: AppTheme.secondaryText, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryText,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.secondaryText,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isSigningOut
            ? null
            : () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleSignOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
                        ),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.errorRed,
          side: const BorderSide(color: AppTheme.errorRed),
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        ),
        child: _isSigningOut
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppTheme.errorRed,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Sign out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
