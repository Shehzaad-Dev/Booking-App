import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class BookingFormPage extends StatefulWidget {
  final String itemName;
  const BookingFormPage({super.key, required this.itemName});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _country.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text('Your details'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking: ${widget.itemName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _field('First name', _firstName, validator: _required),
                      _field('Last name', _lastName, validator: _required),
                      _field(
                        'Email',
                        _email,
                        keyboard: TextInputType.emailAddress,
                        validator: _emailValidator,
                      ),
                      _field('Country', _country, validator: _required),
                      _field(
                        'Mobile number',
                        _phone,
                        keyboard: TextInputType.phone,
                        validator: _required,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Confirm details'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    // Extract item and serviceIndex from the route that opened this form
    Map<String, dynamic>? parentArgs;
    final raw = ModalRoute.of(context)?.settings.arguments;
    if (raw is Map<String, dynamic>) parentArgs = raw;
    final item = parentArgs != null && parentArgs['item'] is Map
        ? Map<String, dynamic>.from(parentArgs['item'] as Map)
        : null;
    final serviceIndex = parentArgs != null && parentArgs['serviceIndex'] is int
        ? parentArgs['serviceIndex'] as int
        : null;

    // Add booking immediately so it appears in Active
    if (item != null && serviceIndex != null) {
      AppState.instance.addBooking(
        item,
        serviceIndex,
        firstName: _firstName.text.trim(),
      );
    }

    Navigator.pushNamed(
      context,
      '/booking-confirmation',
      arguments: {
        'itemName': widget.itemName,
        'firstName': _firstName.text.trim(),
        'item': item,
        'serviceIndex': serviceIndex,
      },
    );
  }
}
