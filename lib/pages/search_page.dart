import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/mock_booking_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int selectedService = 0; // 0: Stays, 1: Car rental, 2: Taxi, 3: Attractions
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController carReturnController = TextEditingController();
  final TextEditingController driverAgeController = TextEditingController();
  final TextEditingController taxiTimeController = TextEditingController();
  final TextEditingController passengersController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // API data state
  List<Map<String, dynamic>> _hotels = [];
  List<Map<String, dynamic>> _carRentals = [];
  List<Map<String, dynamic>> _taxis = [];
  List<Map<String, dynamic>> _attractions = [];
  bool _isLoading = false;
  bool _lastSearchNoResults = false;
  // Placeholder for saved items (keys like hotel id, car id)
  // final Set<String> _savedKeys = <String>{};

  // Inline calendar state
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  // Guests state
  int _roomsCount = 1;
  int _adultsCount = 2;
  int _childrenCount = 0;

  // Taxi passengers state
  int _passengersCount = 2;
  bool _taxiRoundTrip = true;

  // Car rental: return to same location
  bool _returnToSameLocation = true;
  final TextEditingController dropoffLocationController =
      TextEditingController();
  // String? _lastPickupLocation; // reserved for future multi-step pickup UX
  String? _lastDropoffLocation;

  // Driver age options state
  final List<String> _driverAgeOptions = <String>[
    '25-30',
    '31-40',
    '41-50',
    '51-65',
  ];
  int _selectedDriverAgeIndex = 1; // default '31-40'

  @override
  void initState() {
    super.initState();
    // Set default values
    dateController.text = 'Sat 30 Aug - Sun 31 Aug';
    guestsController.text = '1 room · 2 adults · 0 children';
    carReturnController.text = '01 Sept, 10:00 am - 04 Sept, 10:00 am';
    driverAgeController.text = 'Driver\'s age: 30-65';
    taxiTimeController.text = 'Choose your pick-up time';
    passengersController.text = '2 passengers';

    _scrollController.addListener(_onScroll);

    // Load initial data for stays
    _loadDataForService(0);
  }

  @override
  void dispose() {
    destinationController.dispose();
    dateController.dispose();
    guestsController.dispose();
    pickupLocationController.dispose();
    dropoffLocationController.dispose();
    carReturnController.dispose();
    driverAgeController.dispose();
    taxiTimeController.dispose();
    passengersController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  void _onServiceChanged(int serviceIndex) {
    setState(() {
      selectedService = serviceIndex;
    });
    _loadDataForService(serviceIndex);
  }

  Future<void> _loadDataForService(int serviceIndex) async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (serviceIndex) {
        case 0: // Stays
          _hotels = await MockBookingService.searchHotels(
            destination: destinationController.text.isNotEmpty
                ? destinationController.text
                : 'Lahore',
            checkIn: '2024-09-01',
            checkOut: '2024-09-03',
            adults: _adultsCount,
            children: _childrenCount,
            rooms: _roomsCount,
          );
          // Client-side filter for mock data consistency
          if (destinationController.text.trim().isNotEmpty) {
            final query = destinationController.text.trim().toLowerCase();
            _hotels = _hotels
                .where(
                  (h) => (h['location'] ?? '')
                      .toString()
                      .toLowerCase()
                      .contains(query),
                )
                .toList();
          }
          break;
        case 1: // Car rental
          // Ensure drop-off mirrors pick-up when return toggle is on
          if (_returnToSameLocation) {
            dropoffLocationController.text = pickupLocationController.text;
          }
          _carRentals = await MockBookingService.searchCarRentals(
            pickUpLatitude: 31.5204,
            pickUpLongitude: 74.3587,
            dropOffLatitude: 31.5204,
            dropOffLongitude: 74.3587,
            pickUpTime: '10:00',
            dropOffTime: '10:00',
            driverAge: 30,
            currencyCode: 'USD',
            location: 'PK',
          );
          // Client-side filter using pick-up/drop-off location text for mocks
          final pickupQ = pickupLocationController.text.trim().toLowerCase();
          final dropoffQ = dropoffLocationController.text.trim().toLowerCase();
          if (pickupQ.isNotEmpty ||
              (!_returnToSameLocation && dropoffQ.isNotEmpty)) {
            _carRentals = _carRentals.where((c) {
              final loc = (c['location'] ?? '').toString().toLowerCase();
              final matchPickup = pickupQ.isEmpty || loc.contains(pickupQ);
              final matchDrop =
                  _returnToSameLocation ||
                  dropoffQ.isEmpty ||
                  loc.contains(dropoffQ);
              return matchPickup || matchDrop;
            }).toList();
          }
          break;
        case 2: // Taxi
          _taxis = await MockBookingService.searchTaxis(
            pickUpLocation: pickupLocationController.text.isNotEmpty
                ? pickupLocationController.text
                : 'Lahore Airport',
            destination:
                (_taxiRoundTrip
                        ? pickupLocationController.text
                        : destinationController.text)
                    .isNotEmpty
                ? (_taxiRoundTrip
                      ? pickupLocationController.text
                      : destinationController.text)
                : 'Lahore City',
            pickUpTime: taxiTimeController.text.isNotEmpty
                ? taxiTimeController.text
                : '10:00 AM',
            passengers: _passengersCount,
          );
          // Client-side filter for taxi mocks using route text
          final pickQ = pickupLocationController.text.trim().toLowerCase();
          final destQ =
              (_taxiRoundTrip
                      ? pickupLocationController.text
                      : destinationController.text)
                  .trim()
                  .toLowerCase();
          if (pickQ.isNotEmpty || destQ.isNotEmpty) {
            _taxis = _taxis.where((t) {
              final route = (t['route'] ?? '').toString().toLowerCase();
              return route.contains(pickQ) || route.contains(destQ);
            }).toList();
          }
          break;
        case 3: // Attractions
          _attractions = await MockBookingService.searchAttractions(
            destination: destinationController.text.isNotEmpty
                ? destinationController.text
                : 'Lahore',
            checkIn: '2024-09-01',
            checkOut: '2024-09-03',
          );
          if (destinationController.text.trim().isNotEmpty) {
            final q = destinationController.text.trim().toLowerCase();
            _attractions = _attractions
                .where(
                  (a) => (a['location'] ?? '')
                      .toString()
                      .toLowerCase()
                      .contains(q),
                )
                .toList();
          }
          break;
      }
    } catch (e) {
      // Handle error
      debugPrint('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search functionality with trending/best available options
  Future<void> _performSearch() async {
    final destination = destinationController.text.trim();

    if (destination.isEmpty) {
      // Load trending directly
      setState(() {
        _lastSearchNoResults = false;
      });
      await _loadTrendingData();
      return;
    }

    // Try to search for the specific location
    await _loadDataForService(selectedService);

    // Navigate to results page instead of staying inline
    final list = _getCurrentDataList();
    if (list.isNotEmpty) {
      final title = destination.isEmpty
          ? _serviceTitle(selectedService)
          : destination;
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/results',
          arguments: {
            'title': title,
            'serviceIndex': selectedService,
            'items': list,
          },
        );
      }
    }

    // If no results found, show trending/best available options
    if (_getCurrentDataList().isEmpty) {
      setState(() {
        _lastSearchNoResults = true;
      });
      await _loadTrendingData();
    } else {
      setState(() {
        _lastSearchNoResults = false;
      });
    }
  }

  String _serviceTitle(int s) {
    switch (s) {
      case 0:
        return 'Stays';
      case 1:
        return 'Car rental';
      case 2:
        return 'Taxi';
      case 3:
        return 'Attractions';
      default:
        return 'Results';
    }
  }

  List<Map<String, dynamic>> _getCurrentDataList() {
    switch (selectedService) {
      case 0:
        return _hotels;
      case 1:
        return _carRentals;
      case 2:
        return _taxis;
      case 3:
        return _attractions;
      default:
        return _hotels;
    }
  }

  // Deprecated dialog functions replaced with inline empty/trending UI
  // void _showTrendingDestinations() {}
  // void _showBestAvailableOptions() {}

  Future<void> _loadTrendingData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (selectedService) {
        case 0: // Stays - load trending hotels
          _hotels = await MockBookingService.searchHotels(
            destination: 'Lahore',
            checkIn: '2024-09-01',
            checkOut: '2024-09-03',
            adults: 2,
            children: 0,
            rooms: 1,
          );
          break;
        case 1: // Car rental - load trending locations
          _carRentals = await MockBookingService.searchCarRentals(
            pickUpLatitude: 31.5204,
            pickUpLongitude: 74.3587,
            dropOffLatitude: 31.5204,
            dropOffLongitude: 74.3587,
            pickUpTime: '10:00',
            dropOffTime: '10:00',
            driverAge: 30,
            currencyCode: 'USD',
            location: 'PK',
          );
          break;
        case 2: // Taxi - load popular routes
          _taxis = await MockBookingService.searchTaxis(
            pickUpLocation: 'Lahore Airport',
            destination: 'Lahore City',
            pickUpTime: '10:00 AM',
            passengers: 2,
          );
          break;
        case 3: // Attractions - load popular attractions
          _attractions = await MockBookingService.searchAttractions(
            destination: 'Lahore',
            checkIn: '2024-09-01',
            checkOut: '2024-09-03',
          );
          break;
      }
    } catch (e) {
      debugPrint('Error loading trending data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navigation to detail pages
  // Removed old bottom sheet implementation; navigation is handled via '/item-detail'

  // Removed old bottom sheet implementation; navigation is handled via '/item-detail'

  // Removed old bottom sheet implementation; navigation is handled via '/item-detail'

  // Removed old bottom sheet implementation; navigation is handled via '/item-detail'

  // Deprecated confirmation dialog removed in favor of full confirmation page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and icons
            _buildHeader(),

            // Service selection grid
            _buildServiceSelection(),

            // Main search form
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchForm(),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildPromotionalSection(),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildContentBasedOnService(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - empty for centering
          const SizedBox(width: 60),

          // Centered Logo
          const Expanded(
            child: Center(
              child: Text(
                'Booking.com',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  Widget _buildServiceSelection() {
    return Container(
      color: AppTheme.headerBackground,
      padding: const EdgeInsets.only(
        left: AppTheme.spacingM,
        right: AppTheme.spacingM,
        bottom: AppTheme.spacingM,
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 3.0, // Increased aspect ratio to prevent overflow
        mainAxisSpacing: AppTheme.spacingS,
        crossAxisSpacing: AppTheme.spacingS,
        children: [
          ServiceOptionCard(
            icon: Icons.bed,
            label: 'Stays',
            isSelected: selectedService == 0,
            onTap: () => _onServiceChanged(0),
            backgroundColor: _isScrolled
                ? AppTheme.white
                : AppTheme.primaryBlue,
            iconColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
            textColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
          ),
          ServiceOptionCard(
            icon: Icons.directions_car,
            label: 'Car rental',
            isSelected: selectedService == 1,
            onTap: () => _onServiceChanged(1),
            backgroundColor: _isScrolled
                ? AppTheme.white
                : AppTheme.primaryBlue,
            iconColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
            textColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
          ),
          ServiceOptionCard(
            icon: Icons.local_taxi,
            label: 'Taxi',
            isSelected: selectedService == 2,
            onTap: () => _onServiceChanged(2),
            backgroundColor: _isScrolled
                ? AppTheme.white
                : AppTheme.primaryBlue,
            iconColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
            textColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
          ),
          ServiceOptionCard(
            icon: Icons.attractions,
            label: 'Attractions',
            isSelected: selectedService == 3,
            onTap: () => _onServiceChanged(3),
            backgroundColor: _isScrolled
                ? AppTheme.white
                : AppTheme.primaryBlue,
            iconColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
            textColor: _isScrolled ? AppTheme.primaryBlue : AppTheme.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    switch (selectedService) {
      case 0: // Stays
        return _buildStaysForm();
      case 1: // Car rental
        return _buildCarRentalForm();
      case 2: // Taxi
        return _buildTaxiForm();
      case 3: // Attractions
        return _buildAttractionsForm();
      default:
        return _buildStaysForm();
    }
  }

  Widget _buildStaysForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.primaryBorder, width: 2),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Destination field
          SearchInputField(
            label: 'Enter your destination',
            prefixIcon: Icons.search,
            controller: destinationController,
            hintText: 'Where are you going?',
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Date field
          SearchInputField(
            label: 'Select dates',
            prefixIcon: Icons.calendar_today,
            controller: dateController,
            readOnly: true,
            onTap: () => _showDatePicker(),
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Guests field
          SearchInputField(
            label: 'Select guests',
            prefixIcon: Icons.person,
            controller: guestsController,
            readOnly: true,
            onTap: () => _showGuestPicker(),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Search button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _performSearch,
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarRentalForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.primaryBorder, width: 2),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Return to same location toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Return to same location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              Switch(
                value: _returnToSameLocation,
                onChanged: (value) {
                  setState(() {
                    _returnToSameLocation = value;
                    if (_returnToSameLocation) {
                      // Remember last drop-off and clear field
                      _lastDropoffLocation = dropoffLocationController.text;
                      dropoffLocationController.text =
                          pickupLocationController.text;
                    } else {
                      // Restore last entered drop-off if available
                      dropoffLocationController.text =
                          _lastDropoffLocation ?? pickupLocationController.text;
                    }
                    // no-op: pickup remembered via controllers
                  });
                },
                activeColor: AppTheme.primaryBlue,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Pick-up location field
          SearchInputField(
            label: 'Pick-up location',
            prefixIcon: Icons.directions_car,
            controller: pickupLocationController,
            hintText: 'Enter pick-up location',
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Drop-off location field (disabled if returning to same location)
          SearchInputField(
            label: 'Drop-off location',
            prefixIcon: Icons.location_on,
            controller: dropoffLocationController,
            hintText: 'Enter drop-off location',
            readOnly: _returnToSameLocation,
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Date and time field
          SearchInputField(
            label: 'Select dates and time',
            prefixIcon: Icons.calendar_today,
            controller: carReturnController,
            readOnly: true,
            onTap: () => _showDatePicker(),
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Driver's age field
          SearchInputField(
            label: 'Driver\'s age',
            prefixIcon: Icons.person,
            controller: driverAgeController,
            readOnly: true,
            onTap: () => _showDriverAgePicker(),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Search button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _performSearch,
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxiForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.primaryBorder, width: 2),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Trip type selection
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: _taxiRoundTrip,
                      onChanged: (value) {
                        setState(() {
                          _taxiRoundTrip = false;
                        });
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                    const Text(
                      'One-way',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _taxiRoundTrip,
                      onChanged: (value) {
                        setState(() {
                          _taxiRoundTrip = true;
                          // Round trip: destination equals pickup
                          destinationController.text =
                              pickupLocationController.text;
                        });
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                    const Text(
                      'Round-trip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Pick-up location field
          SearchInputField(
            label: 'Enter pick-up location',
            prefixIcon: Icons.location_on,
            controller: pickupLocationController,
            hintText: 'Enter pick-up location',
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Destination field (auto mirrors pickup when round-trip)
          SearchInputField(
            label: 'Enter destination',
            prefixIcon: Icons.location_on,
            controller: destinationController,
            hintText: 'Enter destination',
            readOnly: _taxiRoundTrip,
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Pick-up time field
          SearchInputField(
            label: 'Choose your pick-up time',
            prefixIcon: Icons.access_time,
            controller: taxiTimeController,
            readOnly: true,
            onTap: () => _showTimePicker(),
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Passengers field
          SearchInputField(
            label: 'Number of passengers',
            prefixIcon: Icons.person,
            controller: passengersController,
            readOnly: true,
            onTap: () => _showPassengerPicker(),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Check prices button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _performSearch,
              child: const Text(
                'Check prices',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionsForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.primaryBorder, width: 2),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Where are you going field
          SearchInputField(
            label: 'Where are you going?',
            prefixIcon: Icons.search,
            controller: destinationController,
            hintText: 'Enter destination',
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Any dates field
          SearchInputField(
            label: 'Any dates',
            prefixIcon: Icons.calendar_today,
            controller: dateController,
            readOnly: true,
            onTap: () => _showDatePicker(),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Search button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _performSearch,
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBasedOnService() {
    switch (selectedService) {
      case 0: // Stays
        return _buildStaysContent();
      case 1: // Car rental
        return _buildCarRentalContent();
      case 2: // Taxi
        return _buildTaxiContent();
      case 3: // Attractions
        return _buildAttractionsContent();
      default:
        return _buildStaysContent();
    }
  }

  Widget _buildStaysContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastSearchNoResults)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text('Discover trending stays below'),
                ],
              ),
            ),
          SectionHeader(
            title: 'Need ideas?',
            subtitle: 'Travellers from Pakistan often book',
          ),

          // Destination cards
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
              ),
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppTheme.spacingS),
              itemBuilder: (context, index) {
                final destinations = ['Lahore', 'Islamabad', 'Karachi'];
                return Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusMedium,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusMedium,
                          ),
                          child: Container(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.location_city,
                              size: 40,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: AppTheme.spacingS,
                        left: AppTheme.spacingS,
                        child: Text(
                          destinations[index],
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppTheme.spacingL),

          SectionHeader(
            title: _lastSearchNoResults
                ? 'Trending Stays'
                : 'Deals for the weekend',
            subtitle: _lastSearchNoResults
                ? 'Popular places and highly reviewed options'
                : 'Save on stays for 5 September - 7 September',
          ),

          // Hotel deals from API
          if (_hotels.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _hotels.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                ),
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppTheme.spacingS),
                itemBuilder: (context, index) {
                  final hotel = _hotels[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/item-detail',
                        arguments: {'serviceIndex': 0, 'item': hotel},
                      );
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusMedium,
                        ),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen,
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusSmall,
                              ),
                            ),
                            child: Text(
                              hotel['deal_type'] ?? 'Special Deal',
                              style: const TextStyle(
                                color: AppTheme.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            hotel['name'] ?? 'Hotel',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(hotel['location'] ?? 'Location'),
                          Text(
                            '★${hotel['rating']?.toStringAsFixed(1) ?? '0.0'} • ${hotel['review_count'] ?? 0} reviews',
                          ),
                          const Spacer(),
                          if (hotel['original_price'] != null &&
                              hotel['price'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '2 nights: PKR ${hotel['price']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                                Text(
                                  'PKR ${hotel['original_price']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme.secondaryText,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Price on request',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingL),
                child: Text('No hotels found'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarRentalContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastSearchNoResults)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text('Discover trending cars below'),
                ],
              ),
            ),
          SectionHeader(
            title: _lastSearchNoResults ? 'Trending Cars' : 'Available Cars',
            subtitle: _lastSearchNoResults
                ? 'Popular rentals and highly reviewed options'
                : 'Top car rental options',
          ),

          // Car rental options from API
          if (_carRentals.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _carRentals.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                ),
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppTheme.spacingS),
                itemBuilder: (context, index) {
                  final car = _carRentals[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/item-detail',
                        arguments: {'serviceIndex': 1, 'item': car},
                      );
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusMedium,
                        ),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusSmall,
                              ),
                            ),
                            child: Text(
                              car['car_type'] ?? 'Car',
                              style: const TextStyle(
                                color: AppTheme.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            '${car['brand'] ?? ''} ${car['model'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(car['location'] ?? 'Location'),
                          Text(
                            '★${car['rating']?.toStringAsFixed(1) ?? '0.0'} • ${car['review_count'] ?? 0} reviews',
                          ),
                          const Spacer(),
                          Text(
                            'PKR ${car['price_per_day'] ?? 0}/day',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingL),
                child: Text('No cars available'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaxiContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastSearchNoResults)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text('Discover trending taxi services below'),
                ],
              ),
            ),
          SectionHeader(
            title: _lastSearchNoResults
                ? 'Trending Taxi Services'
                : 'Available Taxi Services',
            subtitle: _lastSearchNoResults
                ? 'Popular routes and highly reviewed services'
                : 'Top taxi options for your route',
          ),

          // Taxi services from API
          if (_taxis.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _taxis.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                ),
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppTheme.spacingS),
                itemBuilder: (context, index) {
                  final taxi = _taxis[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/item-detail',
                        arguments: {'serviceIndex': 2, 'item': taxi},
                      );
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusMedium,
                        ),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warningOrange,
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusSmall,
                              ),
                            ),
                            child: Text(
                              taxi['vehicle_type'] ?? 'Taxi',
                              style: const TextStyle(
                                color: AppTheme.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            taxi['service_name'] ?? 'Taxi Service',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(taxi['route'] ?? 'Route'),
                          Text(
                            '★${taxi['rating']?.toStringAsFixed(1) ?? '0.0'} • ${taxi['review_count'] ?? 0} reviews',
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            '${taxi['estimated_time'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'PKR ${taxi['price'] ?? 0}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingL),
                child: Text('No taxi services available'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttractionsContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastSearchNoResults)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text('Discover trending attractions below'),
                ],
              ),
            ),
          SectionHeader(
            title: _lastSearchNoResults
                ? 'Trending Attractions'
                : 'Popular Attractions',
            subtitle: _lastSearchNoResults
                ? 'Popular spots and highly reviewed options'
                : 'Top destinations to visit',
          ),

          // Attractions from API
          if (_attractions.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _attractions.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                ),
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppTheme.spacingS),
                itemBuilder: (context, index) {
                  final attraction = _attractions[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/item-detail',
                        arguments: {'serviceIndex': 3, 'item': attraction},
                      );
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusMedium,
                        ),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen,
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusSmall,
                              ),
                            ),
                            child: Text(
                              attraction['category'] ?? 'Attraction',
                              style: const TextStyle(
                                color: AppTheme.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            attraction['name'] ?? 'Attraction',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(attraction['location'] ?? 'Location'),
                          Text(
                            '★${attraction['rating']?.toStringAsFixed(1) ?? '0.0'} • ${attraction['review_count'] ?? 0} reviews',
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          if (attraction['price'] != null &&
                              attraction['price'] > 0)
                            Text(
                              'PKR ${attraction['price']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlue,
                              ),
                            )
                          else
                            const Text(
                              'Free Entry',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successGreen,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingL),
                child: Text('No attractions found'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromotionalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Travel more, spend less'),

        // Promotional cards
        Row(
          children: [
            Expanded(
              child: PromoCard(
                title: 'Genius',
                subtitle: 'You\'re at Genius Level 1 in our loyalty programme',
                backgroundColor: AppTheme.primaryBlue,
                textColor: AppTheme.white,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: PromoCard(
                title: '10% discounts on stays',
                subtitle:
                    'Enjoy discounts at participating properties worldwide',
                backgroundColor: AppTheme.white,
                textColor: AppTheme.primaryText,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDatePicker() {
    // Show date picker modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDatePickerModal(),
    );
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String d = date.day.toString().padLeft(2, '0');
    final String m = months[date.month - 1];
    return '$d $m';
  }

  Widget _buildDatePickerModal() {
    final DateTime today = DateTime.now();
    _checkInDate ??= today;
    _checkOutDate ??= today.add(const Duration(days: 1));

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Title
          Text(
            'Select dates',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Inline Calendar (range by tapping two dates)
          Expanded(
            child: CalendarDatePicker(
              initialDate: _checkInDate!,
              firstDate: today,
              lastDate: today.add(const Duration(days: 365)),
              onDateChanged: (DateTime selected) {
                setState(() {
                  if (_checkInDate == null ||
                      (_checkInDate != null && _checkOutDate != null)) {
                    _checkInDate = selected;
                    _checkOutDate = null;
                  } else if (_checkOutDate == null) {
                    if (selected.isBefore(_checkInDate!)) {
                      _checkOutDate = _checkInDate;
                      _checkInDate = selected;
                    } else {
                      _checkOutDate = selected;
                    }
                  }
                });
              },
            ),
          ),

          // Selected range summary
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
            child: Text(
              _checkOutDate == null
                  ? 'Check-in: ${_formatDate(_checkInDate!)}'
                  : 'Check-in: ${_formatDate(_checkInDate!)}   •   Check-out: ${_formatDate(_checkOutDate!)}',
            ),
          ),

          // Select dates button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_checkInDate != null && _checkOutDate == null) {
                  // Auto set one night if only one date picked
                  _checkOutDate = _checkInDate!.add(const Duration(days: 1));
                }
                Navigator.pop(context);
                setState(() {
                  dateController.text =
                      '${_formatDate(_checkInDate!)} - ${_formatDate(_checkOutDate!)}';
                });
              },
              child: const Text('Select dates'),
            ),
          ),
        ],
      ),
    );
  }

  void _showGuestPicker() {
    // Show guest picker modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildGuestPickerModal(),
    );
  }

  Widget _buildGuestPickerModal() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Title
              Text(
                'Select guests',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Guest selection options
              Expanded(
                child: Column(
                  children: [
                    _buildGuestOption('Rooms', setModalState),
                    _buildGuestOption('Adults', setModalState),
                    _buildGuestOption('Children', setModalState),
                  ],
                ),
              ),

              // Done button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      guestsController.text =
                          '$_roomsCount room${_roomsCount == 1 ? '' : 's'} · $_adultsCount adult${_adultsCount == 1 ? '' : 's'} · $_childrenCount child${_childrenCount == 1 ? '' : 'ren'}';
                    });
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuestOption(
    String label,
    void Function(void Function()) setModalState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Decrease with floors
                  setModalState(() {
                    if (label == 'Rooms' && _roomsCount > 1) {
                      _roomsCount--;
                    } else if (label == 'Adults' && _adultsCount > 1) {
                      _adultsCount--;
                    } else if (label == 'Children' && _childrenCount > 0) {
                      _childrenCount--;
                    }
                  });
                },
                icon: const Icon(Icons.remove_circle_outline),
                color: AppTheme.primaryBlue,
              ),
              Text(
                label == 'Rooms'
                    ? '$_roomsCount'
                    : label == 'Adults'
                    ? '$_adultsCount'
                    : '$_childrenCount',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () {
                  setModalState(() {
                    if (label == 'Rooms' && _roomsCount < 10) {
                      _roomsCount++;
                    } else if (label == 'Adults' && _adultsCount < 10) {
                      _adultsCount++;
                    } else if (label == 'Children' && _childrenCount < 10) {
                      _childrenCount++;
                    }
                  });
                },
                icon: const Icon(Icons.add_circle_outline),
                color: AppTheme.primaryBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDriverAgePicker() {
    // Show driver age picker modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDriverAgePickerModal(),
    );
  }

  Widget _buildDriverAgePickerModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Title
          Text(
            'Select driver age',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Age options
          Expanded(
            child: ListView.separated(
              itemCount: _driverAgeOptions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final option = _driverAgeOptions[index];
                final selected = _selectedDriverAgeIndex == index;
                return ListTile(
                  title: Text('Driver\'s age: $option'),
                  trailing: selected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryBlue,
                        )
                      : const Icon(Icons.radio_button_unchecked),
                  onTap: () {
                    setState(() {
                      _selectedDriverAgeIndex = index;
                      driverAgeController.text = 'Driver\'s age: $option';
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker() {
    // Show time picker modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildTimePickerModal(),
    );
  }

  Widget _buildTimePickerModal() {
    final List<String> times = <String>[
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
    ];
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Select pick-up time',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: ListView.separated(
              itemCount: times.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final t = times[index];
                return ListTile(
                  title: Text(t),
                  onTap: () {
                    setState(() {
                      taxiTimeController.text = t;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPassengerPicker() {
    // Show passenger picker modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPassengerPickerModal(),
    );
  }

  Widget _buildPassengerPickerModal() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Title
              Text(
                'Select number of passengers',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Passenger selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Passengers',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setModalState(() {
                            if (_passengersCount > 1) _passengersCount--;
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppTheme.primaryBlue,
                      ),
                      Text(
                        '$_passengersCount',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () {
                          setModalState(() {
                            if (_passengersCount < 7) _passengersCount++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingL),

              // Done button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      passengersController.text =
                          '$_passengersCount passenger${_passengersCount == 1 ? '' : 's'}';
                    });
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
