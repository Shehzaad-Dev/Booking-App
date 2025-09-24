import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class ItemDetailPage extends StatefulWidget {
  final int serviceIndex;
  final Map<String, dynamic> item;

  const ItemDetailPage({
    super.key,
    required this.serviceIndex,
    required this.item,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int guestCount = 1;
  int selectedRoomIndex = 0;
  bool showRoomOptions = false;
  bool showRoomDetails = false;

  // Mock room availability data - you can replace this with actual data
  List<Map<String, dynamic>> get availableRooms => [
    {
      'type': 'Standard Room',
      'price': widget.item['price'] ?? 5000,
      'available': 3,
      'amenities': ['WiFi', 'AC', 'TV', 'Bathroom'],
      'image':
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=300&h=200&fit=crop',
      'rating': 4.2,
      'hotelName': widget.item['name'] ?? 'Hotel Paradise',
    },
    {
      'type': 'Deluxe Room',
      'price': (widget.item['price'] ?? 5000) + 2000,
      'available': 2,
      'amenities': ['WiFi', 'AC', 'TV', 'Bathroom', 'Mini Bar', 'Balcony'],
      'image':
          'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=300&h=200&fit=crop',
      'rating': 4.5,
      'hotelName': widget.item['name'] ?? 'Hotel Paradise',
    },
    {
      'type': 'Suite',
      'price': (widget.item['price'] ?? 5000) + 5000,
      'available': 1,
      'amenities': [
        'WiFi',
        'AC',
        'TV',
        'Bathroom',
        'Mini Bar',
        'Balcony',
        'Living Room',
        'Kitchen',
      ],
      'image':
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=300&h=200&fit=crop',
      'rating': 4.8,
      'hotelName': widget.item['name'] ?? 'Hotel Paradise',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item['imageUrl'] ?? widget.item['image'];
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: Text(_title()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(_subtitle()),
                      const SizedBox(height: AppTheme.spacingM),
                      ..._detailRows(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Room availability and guest controls at the bottom
          _buildBottomControls(context),
        ],
      ),
    );
  }

  String _title() {
    switch (widget.serviceIndex) {
      case 0:
        return widget.item['name'] ?? 'Stay';
      case 1:
        return '${widget.item['brand'] ?? ''} ${widget.item['model'] ?? ''}'
            .trim();
      case 2:
        return widget.item['service_name'] ?? 'Taxi';
      case 3:
        return widget.item['name'] ?? 'Attraction';
      default:
        return 'Detail';
    }
  }

  String _subtitle() {
    switch (widget.serviceIndex) {
      case 0:
        return '${widget.item['location'] ?? ''}  •  ★${(widget.item['rating'] ?? '').toString()}';
      case 1:
        return '${widget.item['car_type'] ?? ''}  •  ${widget.item['location'] ?? ''}';
      case 2:
        return '${widget.item['route'] ?? ''}  •  ${widget.item['vehicle_type'] ?? ''}';
      case 3:
        return '${widget.item['category'] ?? ''}  •  ${widget.item['location'] ?? ''}';
      default:
        return '';
    }
  }

  List<Widget> _detailRows(BuildContext context) {
    switch (widget.serviceIndex) {
      case 0:
        return [
          _kv(
            'Price',
            widget.item['price'] != null ? 'PKR ${widget.item['price']}' : '-',
          ),
          _kv('Reviews', (widget.item['review_count'] ?? '-').toString()),
        ];
      case 1:
        return [
          _kv('Price per day', 'PKR ${widget.item['price_per_day'] ?? '-'}'),
          _kv('Features', (widget.item['features'] ?? []).join(', ')),
        ];
      case 2:
        return [
          _kv('Estimated time', widget.item['estimated_time'] ?? '-'),
          _kv('Price', 'PKR ${widget.item['price'] ?? '-'}'),
        ];
      case 3:
        return [
          _kv(
            'Price',
            widget.item['price'] != null && widget.item['price'] > 0
                ? 'PKR ${widget.item['price']}'
                : 'Free',
          ),
          _kv('Rating', '★${(widget.item['rating'] ?? '').toString()}'),
        ];
      default:
        return [];
    }
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(child: Text(v, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  String _primaryCtaLabel() {
    switch (widget.serviceIndex) {
      case 0:
        return 'Book service';
      case 1:
        return 'Rent this car';
      case 2:
        return 'Book this taxi';
      case 3:
        return 'Get tickets';
      default:
        return 'Continue';
    }
  }

  Widget _buildBottomControls(BuildContext context) {
    final app = AppState.instance;
    final selectedRoom = availableRooms[selectedRoomIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showRoomOptions) ...[
                  // Room options header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose Your Room',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showRoomOptions = false;
                            showRoomDetails = false;
                          });
                        },
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),

                  // Room boxes grid
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableRooms.length,
                      itemBuilder: (context, index) {
                        final room = availableRooms[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRoomIndex = index;
                              showRoomDetails = true;
                            });
                          },
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.only(
                              right: AppTheme.spacingS,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedRoomIndex == index
                                    ? AppTheme.primaryBlue
                                    : Colors.grey.shade300,
                                width: selectedRoomIndex == index ? 2 : 1,
                              ),
                              color: selectedRoomIndex == index
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                                  : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Room image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    room['image'],
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Room details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room['hotelName'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          room['type'],
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              room['rating'].toString(),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          'PKR ${room['price']}',
                                          style: TextStyle(
                                            color: selectedRoomIndex == index
                                                ? AppTheme.primaryBlue
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  // Default room selection (for non-hotel services)
                  Text(
                    'Available Rooms',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  ...availableRooms.asMap().entries.map((entry) {
                    final index = entry.key;
                    final room = entry.value;
                    final isSelected = index == selectedRoomIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRoomIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: AppTheme.spacingS,
                        ),
                        padding: const EdgeInsets.all(AppTheme.spacingS),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                              : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room['type'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppTheme.primaryBlue
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'PKR ${room['price']}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppTheme.primaryBlue
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${room['available']} available',
                                    style: TextStyle(
                                      color: room['available'] > 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryBlue,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                const SizedBox(height: AppTheme.spacingM),

                // Guest controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Guests',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: guestCount > 1
                              ? () {
                                  setState(() {
                                    guestCount--;
                                  });
                                }
                              : null,
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: guestCount > 1
                                ? AppTheme.primaryBlue
                                : Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryBlue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            guestCount.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              guestCount++;
                            });
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Room details view (when a room is selected)
                if (showRoomDetails && showRoomOptions) ...[
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Selected Room Details',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showRoomDetails = false;
                                });
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingS),

                        // Room image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            availableRooms[selectedRoomIndex]['image'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingS),

                        // Room info
                        Text(
                          availableRooms[selectedRoomIndex]['type'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              availableRooms[selectedRoomIndex]['rating']
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.hotel,
                              color: Colors.grey.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              availableRooms[selectedRoomIndex]['hotelName'],
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingS),

                        // Amenities
                        Text(
                          'Amenities:',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children:
                              (availableRooms[selectedRoomIndex]['amenities']
                                      as List)
                                  .map(
                                    (amenity) => Chip(
                                      label: Text(
                                        amenity.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  )
                                  .toList(),
                        ),

                        const SizedBox(height: AppTheme.spacingS),

                        // Dynamic pricing based on guests
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'PKR ${(availableRooms[selectedRoomIndex]['price'] * guestCount)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'PKR ${availableRooms[selectedRoomIndex]['price']} × $guestCount guest${guestCount > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (widget.serviceIndex == 0 && !showRoomOptions) {
                            // Show room options for hotel bookings
                            setState(() {
                              showRoomOptions = true;
                            });
                          } else if (widget.serviceIndex == 0 &&
                              showRoomOptions &&
                              !showRoomDetails) {
                            // If room options are shown but no room is selected, show message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a room first'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            // Proceed to booking form
                            final name = _title();
                            Navigator.pushNamed(
                              context,
                              '/booking-form',
                              arguments: {
                                'itemName': name,
                                'item': widget.item,
                                'serviceIndex': widget.serviceIndex,
                                'selectedRoom': selectedRoom,
                                'guestCount': guestCount,
                              },
                            );
                          }
                        },
                        child: Text(
                          showRoomOptions && !showRoomDetails
                              ? 'Select Room First'
                              : _primaryCtaLabel(),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          app.toggleSave(widget.item, widget.serviceIndex);
                          final saved = app.isSaved(
                            widget.item,
                            widget.serviceIndex,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                saved ? 'Saved' : 'Removed from saved',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: ValueListenableBuilder(
                          valueListenable: app.savedKeys,
                          builder: (_, __, ___) {
                            final saved = app.isSaved(
                              widget.item,
                              widget.serviceIndex,
                            );
                            return Text(saved ? 'Saved' : 'Save');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
