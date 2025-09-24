import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class BookingApiService {
  static final String _baseUrl =
      dotenv.env['BOOKING_API_BASE_URL'] ??
      'https://booking-com15.p.rapidapi.com/api/v1';
  static final String _apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  static final String _apiHost =
      dotenv.env['BOOKING_API_HOST'] ?? 'booking-com15.p.rapidapi.com';

  static final Logger _logger = Logger('BookingApiService');

  // Headers for all API requests
  static Map<String, String> get _headers => {
    if (_apiKey.isNotEmpty) 'x-rapidapi-key': _apiKey,
    'x-rapidapi-host': _apiHost,
    'Content-Type': 'application/json',
  };

  // Search for hotels/stays
  static Future<List<Map<String, dynamic>>> searchHotels({
    required String destination,
    required String checkIn,
    required String checkOut,
    required int adults,
    required int children,
    required int rooms,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/hotels/searchHotels?location=$destination&checkin_date=$checkIn&checkout_date=$checkOut&adults=$adults&children=$children&rooms=$rooms&currency_code=USD',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']['hotels'] ?? []);
        }
      }

      _logger.warning('Failed to fetch hotels: ${response.statusCode}');
      return _getMockHotels();
    } catch (e) {
      _logger.severe('Error fetching hotels: $e');
      return _getMockHotels();
    }
  }

  // Search for car rentals
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
    try {
      final url = Uri.parse(
        '$_baseUrl/cars/searchCarRentals?pick_up_latitude=$pickUpLatitude&pick_up_longitude=$pickUpLongitude&drop_off_latitude=$dropOffLatitude&drop_off_longitude=$dropOffLongitude&pick_up_time=$pickUpTime&drop_off_time=$dropOffTime&driver_age=$driverAge&currency_code=$currencyCode&location=$location',
      );

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']['cars'] ?? []);
        }
      }

      _logger.warning('Failed to fetch car rentals: ${response.statusCode}');
      return _getMockCarRentals();
    } catch (e) {
      _logger.severe('Error fetching car rentals: $e');
      return _getMockCarRentals();
    }
  }

  // Search for taxi services
  static Future<List<Map<String, dynamic>>> searchTaxis({
    required String pickUpLocation,
    required String destination,
    required String pickUpTime,
    required int passengers,
  }) async {
    try {
      // Note: This endpoint might not exist in the actual API
      // Using a mock response for now
      _logger.info('Taxi search not implemented in API, using mock data');
      return _getMockTaxis();
    } catch (e) {
      _logger.severe('Error fetching taxis: $e');
      return _getMockTaxis();
    }
  }

  // Search for attractions
  static Future<List<Map<String, dynamic>>> searchAttractions({
    required String destination,
    String? checkIn,
    String? checkOut,
  }) async {
    try {
      // Note: This endpoint might not exist in the actual API
      // Using a mock response for now
      _logger.info(
        'Attractions search not implemented in API, using mock data',
      );
      return _getMockAttractions();
    } catch (e) {
      _logger.severe('Error fetching attractions: $e');
      return _getMockAttractions();
    }
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
    ];
  }
}
