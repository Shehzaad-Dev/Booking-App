import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String _activeTab = 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Navigation tabs
            _buildNavigationTabs(),

            // Main content
            Expanded(child: _buildContent()),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          const Text(
            'Trips',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Right side icons
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.help_outline,
                  color: AppTheme.white,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppTheme.white, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Row(
        children: [
          _buildTab(
            'Active',
            _activeTab == 'active',
            onTap: () {
              setState(() => _activeTab = 'active');
            },
          ),
          const SizedBox(width: AppTheme.spacingL),
          _buildTab(
            'Past',
            _activeTab == 'past',
            onTap: () {
              setState(() => _activeTab = 'past');
            },
          ),
          const SizedBox(width: AppTheme.spacingL),
          _buildTab(
            'Cancelled',
            _activeTab == 'cancelled',
            onTap: () {
              setState(() => _activeTab = 'cancelled');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected, {VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryBlue.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.primaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: ValueListenableBuilder(
        valueListenable: AppState.instance.bookings,
        builder: (context, value, _) {
          final bookings = value;
          final filtered = bookings
              .where((b) => b['status'] == _activeTab)
              .toList();
          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlobeIllustration(),
                  const SizedBox(height: AppTheme.spacingL),
                  Text(
                    _activeTab == 'active'
                        ? 'No active bookings'
                        : _activeTab == 'past'
                        ? 'No past bookings'
                        : 'No cancelled bookings',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    _activeTab == 'active'
                        ? 'When you book a place, it will appear here.'
                        : 'You will see your $_activeTab bookings here.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  // Test booking button for debugging
                  ElevatedButton(
                    onPressed: () {
                      // Create a test booking
                      final testItem = {
                        'name': 'Test Hotel Booking',
                        'location': 'Lahore',
                        'price': 5000,
                        'rating': 4.5,
                      };
                      AppState.instance.addBooking(
                        testItem,
                        0,
                        firstName: 'Test User',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Test booking added!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                    child: const Text(
                      'Add Test Booking',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final b = filtered[index];
              final item = Map<String, dynamic>.from(b['item'] as Map);
              final name =
                  item['name'] ??
                  item['service_name'] ??
                  '${item['brand'] ?? ''} ${item['model'] ?? ''}';
              final when = b['createdAt'] as String?;
              final location = item['location'] ?? item['route'] ?? '';
              final price = item['price'] ?? item['price_per_day'] ?? '';

              // Format date
              String formattedDate = '';
              if (when != null) {
                try {
                  final date = DateTime.parse(when);
                  formattedDate = '${date.day}/${date.month}/${date.year}';
                } catch (e) {
                  formattedDate = when;
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(
                    b['status'] == 'active'
                        ? Icons.check_circle
                        : b['status'] == 'past'
                        ? Icons.history
                        : Icons.cancel,
                    color: b['status'] == 'cancelled'
                        ? Colors.red
                        : b['status'] == 'past'
                        ? Colors.orange
                        : Colors.green,
                  ),
                  title: Text(
                    name.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (location.isNotEmpty)
                        Text(
                          location.toString(),
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: b['status'] == 'active'
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : b['status'] == 'past'
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              b['status'].toString().toUpperCase(),
                              style: TextStyle(
                                color: b['status'] == 'cancelled'
                                    ? Colors.red
                                    : b['status'] == 'past'
                                    ? Colors.orange
                                    : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                          if (price.toString().isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              'PKR ${price.toString()}',
                              style: TextStyle(
                                color: AppTheme.primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  trailing: _buildActions(b),
                  onTap: () {
                    // Navigate to item detail
                    Navigator.pushNamed(
                      context,
                      '/item-detail',
                      arguments: {
                        'serviceIndex': b['serviceIndex'],
                        'item': item,
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGlobeIllustration() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Stack(
        children: [
          // Globe base
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.borderGrey, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.public,
                  size: 60,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),

          // Stand
          Positioned(
            bottom: 0,
            left: 50,
            child: Container(
              width: 20,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Flags
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 12,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Positioned(
            top: 30,
            right: 25,
            child: Container(
              width: 12,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.warningOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(Map<String, dynamic> b) {
    final id = b['id'] as String?;
    final status = (b['status'] as String?) ?? 'active';
    if (id != null && status == 'active') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => AppState.instance.completeBooking(id),
            child: const Text('Complete'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () async {
              final yes = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cancel booking?'),
                  content: const Text(
                    'Are you sure you want to cancel this booking?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes, cancel'),
                    ),
                  ],
                ),
              );
              if (yes == true) {
                AppState.instance.cancelBooking(id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking cancelled')),
                  );
                }
              }
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
