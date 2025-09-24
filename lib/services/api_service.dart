import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class ApiService {
  final Logger _logger = Logger('ApiService');
  static final String _apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  static final String _apiHost =
      dotenv.env['BOOKING_API_HOST'] ?? 'booking-com15.p.rapidapi.com';

  Future<Map<String, dynamic>?> fetchCarRentals({
    required double pickUpLat,
    required double pickUpLng,
    required double dropOffLat,
    required double dropOffLng,
    required String pickUpTime,
    required String dropOffTime,
    required int driverAge,
    required String currencyCode,
    required String location,
  }) async {
    final url = Uri.parse(
      'https://booking-com15.p.rapidapi.com/api/v1/cars/searchCarRentals?'
      'pick_up_latitude=$pickUpLat&pick_up_longitude=$pickUpLng'
      '&drop_off_latitude=$dropOffLat&drop_off_longitude=$dropOffLng'
      '&pick_up_time=$pickUpTime&drop_off_time=$dropOffTime'
      '&driver_age=$driverAge&currency_code=$currencyCode&location=$location',
    );
    final response = await http.get(
      url,
      headers: {
        if (_apiKey.isNotEmpty) 'x-rapidapi-key': _apiKey,
        'x-rapidapi-host': _apiHost,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _logger.warning('Failed to fetch car rentals: ${response.statusCode}');
      return null;
    }
  }
}
