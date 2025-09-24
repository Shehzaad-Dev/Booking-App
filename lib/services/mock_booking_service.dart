import 'package:logging/logging.dart';

class MockBookingService {
  static final Logger _logger = Logger('MockBookingService');

  // Search for hotels/stays - returns mock data only
  static Future<List<Map<String, dynamic>>> searchHotels({
    required String destination,
    required String checkIn,
    required String checkOut,
    required int adults,
    required int children,
    required int rooms,
  }) async {
    _logger.info('Using mock hotel data for destination: $destination');
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _getMockHotels();
  }

  // Search for car rentals - returns mock data only
  static Future<List<Map<String, dynamic>>> searchCarRentals({
    required double pickUpLatitude,
    required double pickUpLongitude,
    required double dropOffLatitude,
    required double dropOffLongitude,
    required String pickUpTime,
    required String dropOffTime,
    required int driverAge,
    String currencyCode = 'USD',
    String location = 'US',
  }) async {
    _logger.info('Using mock car rental data');
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _getMockCarRentals();
  }

  // Search for taxi services - returns mock data only
  static Future<List<Map<String, dynamic>>> searchTaxis({
    required String pickUpLocation,
    required String destination,
    required String pickUpTime,
    required int passengers,
  }) async {
    _logger.info('Using mock taxi data');
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _getMockTaxis();
  }

  // Search for attractions - returns mock data only
  static Future<List<Map<String, dynamic>>> searchAttractions({
    required String destination,
    String? checkIn,
    String? checkOut,
  }) async {
    _logger.info('Using mock attractions data for destination: $destination');
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _getMockAttractions();
  }

  // Mock data for hotels
  static List<Map<String, dynamic>> _getMockHotels() {
    return [
      {
        'name': 'Dove Inn Hotel',
        'rating': 8.0,
        'review_count': 307,
        'location': 'Lahore',
        'price': 7603,
        'original_price': 10800,
        'image':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
        'amenities': ['WiFi', 'AC', 'Parking'],
        'deal_type': 'Getaway Deal',
      },
      {
        'name': 'Doves Inn Hotel Chowk',
        'rating': 8.7,
        'review_count': 239,
        'location': 'Lahore',
        'price': 12240,
        'original_price': 15000,
        'image':
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
        'amenities': ['WiFi', 'AC', 'Restaurant'],
        'deal_type': 'Getaway Deal',
      },
      {
        'name': 'Luxury Hotel & Spa',
        'rating': 9.2,
        'review_count': 456,
        'location': 'Islamabad',
        'price': 18900,
        'original_price': 25000,
        'image':
            'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
        'amenities': ['WiFi', 'AC', 'Spa', 'Pool'],
        'deal_type': 'Premium Deal',
      },
      {
        'name': 'Karachi Beach Resort',
        'rating': 8.5,
        'review_count': 189,
        'location': 'Karachi',
        'price': 15200,
        'original_price': 18000,
        'image':
            'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
        'amenities': ['WiFi', 'AC', 'Beach Access', 'Restaurant'],
        'deal_type': 'Beach Deal',
      },
    ];
  }

  // Mock data for car rentals
  static List<Map<String, dynamic>> _getMockCarRentals() {
    return [
      {
        'name': 'Economy Car Rental',
        'car_type': 'Economy',
        'brand': 'Toyota',
        'model': 'Corolla',
        'price_per_day': 45,
        'location': 'Lahore Airport',
        'rating': 4.5,
        'review_count': 128,
        'features': ['AC', 'Automatic', '4 Seats'],
        'image':
            'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
      },
      {
        'name': 'Premium Car Rental',
        'car_type': 'Premium',
        'brand': 'BMW',
        'model': '3 Series',
        'price_per_day': 89,
        'location': 'Islamabad Airport',
        'rating': 4.8,
        'review_count': 95,
        'features': ['AC', 'Automatic', '5 Seats', 'GPS'],
        'image':
            'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=400',
      },
      {
        'name': 'SUV Rental Service',
        'car_type': 'SUV',
        'brand': 'Honda',
        'model': 'CR-V',
        'price_per_day': 67,
        'location': 'Karachi Airport',
        'rating': 4.6,
        'review_count': 156,
        'features': ['AC', 'Automatic', '7 Seats', '4WD'],
        'image':
            'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=400',
      },
    ];
  }

  // Mock data for taxis
  static List<Map<String, dynamic>> _getMockTaxis() {
    return [
      {
        'service_name': 'Express Taxi',
        'route': 'Airport → City',
        'estimated_time': '25 min',
        'price': 1200,
        'vehicle_type': 'Sedan',
        'rating': 4.7,
        'review_count': 89,
        'features': ['AC', 'Professional Driver', '24/7'],
        'image':
            'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400',
      },
      {
        'service_name': 'Premium Taxi',
        'route': 'City → Airport',
        'estimated_time': '30 min',
        'price': 1500,
        'vehicle_type': 'Luxury Sedan',
        'rating': 4.9,
        'review_count': 67,
        'features': ['AC', 'Professional Driver', 'WiFi', 'Refreshments'],
        'image':
            'https://images.unsplash.com/photo-1549924231-f129b911e442?w=400',
      },
      {
        'service_name': 'Inter-City Taxi',
        'route': 'Lahore → Islamabad',
        'estimated_time': '4 hours',
        'price': 8000,
        'vehicle_type': 'SUV',
        'rating': 4.6,
        'review_count': 234,
        'features': [
          'AC',
          'Professional Driver',
          'Refreshments',
          'Comfortable Seats',
        ],
        'image':
            'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=400',
      },
    ];
  }

  // Mock data for attractions
  static List<Map<String, dynamic>> _getMockAttractions() {
    return [
      {
        'name': 'Lahore Fort',
        'location': 'Lahore',
        'rating': 4.8,
        'review_count': 1247,
        'price': 500,
        'category': 'Historical Site',
        'description':
            'A UNESCO World Heritage site featuring stunning Mughal architecture',
        'image':
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
        'highlights': [
          'Mughal Architecture',
          'Historical Significance',
          'Beautiful Gardens',
        ],
      },
      {
        'name': 'Faisal Mosque',
        'location': 'Islamabad',
        'rating': 4.9,
        'review_count': 892,
        'price': 0,
        'category': 'Religious Site',
        'description':
            'One of the largest mosques in the world with stunning modern architecture',
        'image':
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
        'highlights': [
          'Modern Architecture',
          'Religious Significance',
          'Beautiful Views',
        ],
      },
      {
        'name': 'Badshahi Mosque',
        'location': 'Lahore',
        'rating': 4.7,
        'review_count': 1567,
        'price': 300,
        'category': 'Religious Site',
        'description':
            'A magnificent example of Mughal architecture and one of the world\'s largest mosques',
        'image':
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
        'highlights': [
          'Mughal Architecture',
          'Religious Significance',
          'Historical Importance',
        ],
      },
      {
        'name': 'Mohenjo-daro',
        'location': 'Sindh',
        'rating': 4.6,
        'review_count': 423,
        'price': 200,
        'category': 'Archaeological Site',
        'description': 'Ancient Indus Valley Civilization archaeological site',
        'image':
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
        'highlights': [
          'Ancient Civilization',
          'Archaeological Significance',
          'Historical Importance',
        ],
      },
    ];
  }
}
