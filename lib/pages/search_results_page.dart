import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchResultsPage extends StatelessWidget {
  final String title;
  final int serviceIndex; // 0 stays,1 car,2 taxi,3 attraction
  final List<Map<String, dynamic>> items;

  const SearchResultsPage({
    super.key,
    required this.title,
    required this.serviceIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderButton(
                  icon: Icons.swap_vert,
                  label: 'Sort',
                  onTap: () {},
                ),
                _HeaderButton(icon: Icons.tune, label: 'Filter', onTap: () {}),
                _HeaderButton(
                  icon: Icons.map_outlined,
                  label: 'Map',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/item-detail',
                      arguments: {'serviceIndex': serviceIndex, 'item': item},
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                    ),
                    padding: const EdgeInsets.all(AppTheme.spacingS),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryBorder),
                    ),
                    child: _buildResultCard(context, item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> item) {
    final imageUrl = item['imageUrl'] ?? item['image'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageUrl != null
              ? Image.network(
                  imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 110,
                  height: 110,
                  color: AppTheme.lightGrey,
                  child: Icon(
                    _iconForService(serviceIndex),
                    color: AppTheme.primaryBlue,
                  ),
                ),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _getTitle(item),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildBadge(item) ?? const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getSubtitle(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: -8, children: _buildChips(item)),
              const SizedBox(height: 6),
              _buildPriceRow(item),
            ],
          ),
        ),
      ],
    );
  }

  // _buildLeading was used by an older list tile layout. Card layout renders its own image.

  String _getTitle(Map<String, dynamic> item) {
    switch (serviceIndex) {
      case 0:
        return item['name'] ?? 'Stay';
      case 1:
        return '${item['brand'] ?? ''} ${item['model'] ?? ''}'.trim().isEmpty
            ? (item['name'] ?? 'Car')
            : '${item['brand'] ?? ''} ${item['model'] ?? ''}'.trim();
      case 2:
        return item['service_name'] ?? 'Taxi';
      case 3:
        return item['name'] ?? 'Attraction';
      default:
        return 'Result';
    }
  }

  String _getSubtitle(Map<String, dynamic> item) {
    switch (serviceIndex) {
      case 0:
        return '${item['location'] ?? ''}  •  ★${(item['rating'] ?? '').toString()}';
      case 1:
        return '${item['car_type'] ?? ''}  •  ${item['location'] ?? ''}';
      case 2:
        return '${item['route'] ?? ''}  •  ${item['vehicle_type'] ?? ''}';
      case 3:
        return '${item['category'] ?? ''}  •  ${item['location'] ?? ''}';
      default:
        return '';
    }
  }

  Widget? _buildBadge(Map<String, dynamic> item) {
    switch (serviceIndex) {
      case 0:
        final rating = item['rating'];
        return rating != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '★${rating.toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : null;
      case 1:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('PKR ${item['price_per_day'] ?? ''}'),
        );
      case 2:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('PKR ${item['price'] ?? ''}'),
        );
      case 3:
        return (item['price'] != null && item['price'] > 0)
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('PKR ${item['price']}'),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Free'),
              );
      default:
        return null;
    }
  }

  List<Widget> _buildChips(Map<String, dynamic> item) {
    switch (serviceIndex) {
      case 0:
        final List<Widget> chips = [];
        if (item['deal_type'] != null) {
          chips.add(_chip(item['deal_type']));
        }
        if (item['amenities'] is List) {
          final amenities = List<String>.from(item['amenities']);
          for (final a in amenities.take(2)) {
            chips.add(_chip(a));
          }
        }
        return chips;
      case 1:
        return [_chip(item['car_type'] ?? 'Car')];
      case 2:
        return [_chip(item['vehicle_type'] ?? 'Taxi')];
      case 3:
        return [_chip(item['category'] ?? 'Attraction')];
      default:
        return [];
    }
  }

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildPriceRow(Map<String, dynamic> item) {
    switch (serviceIndex) {
      case 0:
        final price = item['price'];
        final old = item['original_price'];
        return Row(
          children: [
            if (old != null)
              Text(
                'PKR $old',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(width: 6),
            if (price != null)
              Text(
                'PKR $price',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
          ],
        );
      case 1:
        return Text(
          'PKR ${item['price_per_day'] ?? ''}/day',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryBlue,
          ),
        );
      case 2:
        return Text(
          'PKR ${item['price'] ?? ''}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryBlue,
          ),
        );
      case 3:
        if (item['price'] != null && item['price'] > 0) {
          return Text(
            'PKR ${item['price']}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlue,
            ),
          );
        }
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  IconData _iconForService(int s) {
    switch (s) {
      case 0:
        return Icons.bed;
      case 1:
        return Icons.directions_car;
      case 2:
        return Icons.local_taxi;
      case 3:
        return Icons.attractions;
      default:
        return Icons.search;
    }
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: AppTheme.primaryText),
      label: Text(label, style: const TextStyle(color: AppTheme.primaryText)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
