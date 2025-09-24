import 'package:flutter/material.dart';
import 'pages/search_results_page.dart';
import 'pages/item_detail_page.dart';
import 'pages/booking_form_page.dart';
import 'pages/booking_confirmation_page.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/results':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => SearchResultsPage(
          title: args['title'] as String,
          serviceIndex: args['serviceIndex'] as int,
          items: List<Map<String, dynamic>>.from(args['items'] as List),
        ),
      );
    case '/item-detail':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => ItemDetailPage(
          serviceIndex: args['serviceIndex'] as int,
          item: Map<String, dynamic>.from(args['item'] as Map),
        ),
      );
    case '/booking-form':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => BookingFormPage(itemName: args['itemName'] as String),
      );
    case '/booking-confirmation':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => BookingConfirmationPage(
          itemName: args['itemName'] as String,
          firstName: args['firstName'] as String?,
        ),
      );
  }
  return null;
}
