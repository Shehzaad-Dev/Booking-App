import 'package:flutter/foundation.dart';

class AppState {
  AppState._();
  static final AppState instance = AppState._();

  // Saved items (by key) and full objects for rendering
  final ValueNotifier<Set<String>> savedKeys = ValueNotifier<Set<String>>(
    <String>{},
  );
  final ValueNotifier<List<Map<String, dynamic>>> savedItems =
      ValueNotifier<List<Map<String, dynamic>>>(<Map<String, dynamic>>[]);

  // Bookings list
  final ValueNotifier<List<Map<String, dynamic>>> bookings =
      ValueNotifier<List<Map<String, dynamic>>>(<Map<String, dynamic>>[]);

  String computeKey(Map<String, dynamic> item, int serviceIndex) {
    switch (serviceIndex) {
      case 0:
        return 'stay:${(item['name'] ?? '').toString()}';
      case 1:
        return 'car:${(item['brand'] ?? '').toString()}_${(item['model'] ?? '').toString()}';
      case 2:
        return 'taxi:${(item['service_name'] ?? '').toString()}_${(item['route'] ?? '').toString()}';
      case 3:
        return 'attr:${(item['name'] ?? '').toString()}_${(item['location'] ?? '').toString()}';
      default:
        return 'item:${item.hashCode}';
    }
  }

  void toggleSave(Map<String, dynamic> item, int serviceIndex) {
    final key = computeKey(item, serviceIndex);
    final current = Set<String>.from(savedKeys.value);
    final list = List<Map<String, dynamic>>.from(savedItems.value);
    if (current.contains(key)) {
      current.remove(key);
      list.removeWhere(
        (it) =>
            computeKey(
              it['item'] as Map<String, dynamic>,
              it['serviceIndex'] as int,
            ) ==
            key,
      );
    } else {
      current.add(key);
      list.add({'serviceIndex': serviceIndex, 'item': item});
    }
    savedKeys.value = current;
    savedItems.value = list;
  }

  bool isSaved(Map<String, dynamic> item, int serviceIndex) {
    return savedKeys.value.contains(computeKey(item, serviceIndex));
  }

  void addBooking(
    Map<String, dynamic> item,
    int serviceIndex, {
    String? firstName,
  }) {
    final booking = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'serviceIndex': serviceIndex,
      'item': item,
      'firstName': firstName,
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'active', // active, past, cancelled
    };
    final list = List<Map<String, dynamic>>.from(bookings.value)
      ..insert(0, booking);
    bookings.value = list;
  }

  void cancelBooking(String id) {
    final list = List<Map<String, dynamic>>.from(bookings.value);
    for (final b in list) {
      if (b['id'] == id) {
        b['status'] = 'cancelled';
        break;
      }
    }
    bookings.value = list;
  }

  void completeBooking(String id) {
    final list = List<Map<String, dynamic>>.from(bookings.value);
    for (final b in list) {
      if (b['id'] == id) {
        b['status'] = 'past';
        break;
      }
    }
    bookings.value = list;
  }
}
