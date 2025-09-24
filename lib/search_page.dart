import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int selectedType = 0; // 0: Stays, 1: Car Rental, 2: Taxi, 3: Attractions

  Widget get _searchBox {
    switch (selectedType) {
      case 1:
        return CarRentalSearchBox();
      case 2:
        return TaxiSearchBox();
      case 3:
        return AttractionSearchBox();
      case 0:
      default:
        return StaySearchBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003580),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // App Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'Booking.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white,
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
            ),

            // Service Selection Tabs (no overflow, color change on select)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceTab(
                    icon: Icons.bed,
                    label: 'Stays',
                    selected: selectedType == 0,
                    onTap: () => setState(() => selectedType = 0),
                  ),
                  ServiceTab(
                    icon: Icons.directions_car,
                    label: 'Car rental',
                    selected: selectedType == 1,
                    onTap: () => setState(() => selectedType = 1),
                  ),
                  ServiceTab(
                    icon: Icons.local_taxi,
                    label: 'Taxi',
                    selected: selectedType == 2,
                    onTap: () => setState(() => selectedType = 2),
                  ),
                  ServiceTab(
                    icon: Icons.attractions,
                    label: 'Attractions',
                    selected: selectedType == 3,
                    onTap: () => setState(() => selectedType = 3),
                  ),
                ],
              ),
            ),

            // Expanded search box and content to prevent overflow
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: _searchBox,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Update ServiceTab for color change and fixed height
class ServiceTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const ServiceTab({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFF003580),
          borderRadius: BorderRadius.circular(35),
          border: selected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: selected ? const Color(0xFF003580) : Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF003580) : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class StaySearchBox extends StatelessWidget {
  const StaySearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              icon: Icons.search,
              label: 'Enter your destination',
              onTap: () => _showDestinationModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.calendar_today,
              label: 'Sat 30 Aug - Sun 31 Aug',
              onTap: () => _showDateModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.person,
              label: '1 room · 2 adults · 0 children',
              onTap: () => _showGuestModal(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDestinationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DestinationModal(),
    );
  }

  void _showDateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DateModal(),
    );
  }

  void _showGuestModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GuestModal(),
    );
  }
}

class CarRentalSearchBox extends StatefulWidget {
  const CarRentalSearchBox({super.key});

  @override
  State<CarRentalSearchBox> createState() => _CarRentalSearchBoxState();
}

class _CarRentalSearchBoxState extends State<CarRentalSearchBox> {
  bool returnToSameLocation = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Return to same location',
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
                ),
                const Spacer(),
                Switch(
                  value: returnToSameLocation,
                  onChanged: (value) =>
                      setState(() => returnToSameLocation = value),
                  activeColor: const Color(0xFF003580),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.directions_car,
              label: 'Pick-up location',
              onTap: () => _showLocationModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.calendar_today,
              label: '31 Aug, 10:00 am - 03 Sept, 10:00 am',
              onTap: () => _showDateTimeModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.person,
              label: 'Driver\'s age: 30-65',
              onTap: () => _showAgeModal(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationModal(),
    );
  }

  void _showDateTimeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DateTimeModal(),
    );
  }

  void _showAgeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AgeModal(),
    );
  }
}

class TaxiSearchBox extends StatefulWidget {
  const TaxiSearchBox({super.key});

  @override
  State<TaxiSearchBox> createState() => _TaxiSearchBoxState();
}

class _TaxiSearchBoxState extends State<TaxiSearchBox> {
  bool isRoundTrip = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'One-way',
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: isRoundTrip,
                  onChanged: (value) => setState(() => isRoundTrip = value),
                  activeColor: const Color(0xFF003580),
                ),
                const Text(
                  'Round-trip',
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.location_on,
              label: 'Enter pick-up location',
              onTap: () => _showPickupModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.location_on,
              label: 'Enter destination',
              onTap: () => _showDestinationModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.access_time,
              label: 'Choose your pick-up time',
              onTap: () => _showTimeModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.person,
              label: '2 passengers',
              onTap: () => _showPassengerModal(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Check prices',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPickupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationModal(),
    );
  }

  void _showDestinationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationModal(),
    );
  }

  void _showTimeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TimeModal(),
    );
  }

  void _showPassengerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PassengerModal(),
    );
  }
}

class AttractionSearchBox extends StatelessWidget {
  const AttractionSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              icon: Icons.search,
              label: 'Where are you going?',
              onTap: () => _showDestinationModal(context),
            ),
            const SizedBox(height: 16),
            SearchField(
              icon: Icons.calendar_today,
              label: 'Any dates',
              onTap: () => _showDateModal(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDestinationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DestinationModal(),
    );
  }

  void _showDateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DateModal(),
    );
  }
}

class SearchField extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SearchField({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom Modal Components
class DestinationModal extends StatelessWidget {
  const DestinationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Where are you going?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search destinations',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Popular destinations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 12),
                _buildDestinationItem('New York, USA'),
                _buildDestinationItem('London, UK'),
                _buildDestinationItem('Paris, France'),
                _buildDestinationItem('Tokyo, Japan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationItem(String destination) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Color(0xFF003580)),
      title: Text(destination),
      onTap: () {},
    );
  }
}

class DateModal extends StatelessWidget {
  const DateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select dates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildDateTab('Calendar', true),
                    const SizedBox(width: 16),
                    _buildDateTab('I\'m flexible', false),
                  ],
                ),
                const SizedBox(height: 20),
                const CalendarWidget(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildFlexibilityButton('Exact dates', true),
                    const SizedBox(width: 8),
                    _buildFlexibilityButton('± 1 day', false),
                    const SizedBox(width: 8),
                    _buildFlexibilityButton('± 2 days', false),
                    const SizedBox(width: 8),
                    _buildFlexibilityButton('± 3 days', false),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '30 Aug - 31 Aug (1 night)',
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Select dates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildDateTab(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selected ? const Color(0xFF003580) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xFF003580) : Colors.grey[600],
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFlexibilityButton(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF003580) : Colors.transparent,
        border: Border.all(
          color: selected ? const Color(0xFF003580) : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        onDateChanged: (date) {},
      ),
    );
  }
}

class GuestModal extends StatelessWidget {
  const GuestModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                _buildGuestRow('Rooms', 1),
                _buildGuestRow('Adults', 2),
                _buildGuestRow('Children', 0),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildGuestRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, size: 16),
                ),
              ),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003580),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LocationModal extends StatelessWidget {
  const LocationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search locations',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recent locations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 12),
                _buildLocationItem('New York Airport'),
                _buildLocationItem('London Heathrow'),
                _buildLocationItem('Paris CDG'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String location) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Color(0xFF003580)),
      title: Text(location),
      onTap: () {},
    );
  }
}

class DateTimeModal extends StatelessWidget {
  const DateTimeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select date and time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                const CalendarWidget(),
                const SizedBox(height: 20),
                const Text(
                  'Pick-up time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTimeButton('10:00 AM'),
                    const SizedBox(width: 8),
                    _buildTimeButton('11:00 AM'),
                    const SizedBox(width: 8),
                    _buildTimeButton('12:00 PM'),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildTimeButton(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(time),
    );
  }
}

class AgeModal extends StatelessWidget {
  const AgeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Driver\'s age',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Age range: 30-65 years',
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}

class TimeModal extends StatelessWidget {
  const TimeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pick-up time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TimePickerSpinner(
                    time: TimeOfDay.now(),
                    is24HourMode: false,
                    normalTextStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                    highlightedTextStyle: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFF003580),
                    ),
                    spacing: 50,
                    itemHeight: 80,
                    isForce2Digits: true,
                    onTimeChange: (time) {},
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}

class PassengerModal extends StatelessWidget {
  const PassengerModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Number of passengers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 20),
                _buildPassengerRow('Adults', 2),
                _buildPassengerRow('Children', 0),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildPassengerRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, size: 16),
                ),
              ),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003580),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Simple time picker spinner widget
class TimePickerSpinner extends StatelessWidget {
  final TimeOfDay time;
  final bool is24HourMode;
  final TextStyle? normalTextStyle;
  final TextStyle? highlightedTextStyle;
  final double spacing;
  final double itemHeight;
  final bool isForce2Digits;
  final Function(TimeOfDay) onTimeChange;

  const TimePickerSpinner({
    super.key,
    required this.time,
    this.is24HourMode = false,
    this.normalTextStyle,
    this.highlightedTextStyle,
    this.spacing = 50,
    this.itemHeight = 80,
    this.isForce2Digits = true,
    required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeColumn(
          time.hour,
          is24HourMode ? 24 : 12,
          (hour) => onTimeChange(TimeOfDay(hour: hour, minute: time.minute)),
        ),
        SizedBox(width: spacing),
        const Text(
          ':',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: spacing),
        _buildTimeColumn(
          time.minute,
          60,
          (minute) => onTimeChange(TimeOfDay(hour: time.hour, minute: minute)),
        ),
      ],
    );
  }

  Widget _buildTimeColumn(int value, int max, Function(int) onChanged) {
    return SizedBox(
      height: itemHeight * 3,
      child: ListWheelScrollView(
        itemExtent: itemHeight,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) => onChanged(index),
        children: List.generate(max, (index) {
          final isSelected = index == value;
          return Center(
            child: Text(
              isForce2Digits
                  ? index.toString().padLeft(2, '0')
                  : index.toString(),
              style: isSelected ? highlightedTextStyle : normalTextStyle,
            ),
          );
        }),
      ),
    );
  }
}
