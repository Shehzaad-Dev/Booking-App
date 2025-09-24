import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

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
            'Saved',
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
                icon: const Icon(Icons.search, color: AppTheme.white, size: 24),
              ),
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

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My next trip section
          _buildNextTripSection(),

          const SizedBox(height: AppTheme.spacingL),

          // Saved list
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: AppState.instance.savedItems,
              builder: (context, value, _) {
                final items = value;
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: AppTheme.lightGrey,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        const Text(
                          'No saved items yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = items[index];
                    final serviceIndex = entry['serviceIndex'] as int;
                    final item = Map<String, dynamic>.from(
                      entry['item'] as Map,
                    );
                    final title =
                        item['name'] ??
                        item['service_name'] ??
                        '${item['brand'] ?? ''} ${item['model'] ?? ''}';
                    final subtitle = item['location'] ?? item['route'] ?? '';
                    return ListTile(
                      title: Text(title.toString()),
                      subtitle: Text(subtitle.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            AppState.instance.toggleSave(item, serviceIndex),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/item-detail',
                          arguments: {
                            'serviceIndex': serviceIndex,
                            'item': item,
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextTripSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.borderGrey),
      ),
      child: Row(
        children: [
          // Heart icon
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: const Icon(
              Icons.favorite,
              color: AppTheme.errorRed,
              size: 24,
            ),
          ),

          const SizedBox(width: AppTheme.spacingM),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My next trip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                const Text(
                  '0 saved items',
                  style: TextStyle(fontSize: 14, color: AppTheme.secondaryText),
                ),
              ],
            ),
          ),

          // More options
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppTheme.secondaryText),
          ),
        ],
      ),
    );
  }
}
