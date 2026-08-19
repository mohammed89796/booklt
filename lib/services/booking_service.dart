import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';

class BookingService {
  Future<Booking> createBooking({
    required String providerId,
    required String serviceId,
    required DateTime date,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'provider': providerId,
        'service': serviceId,
        'date': date.toUtc().toIso8601String(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        data['message'] ?? 'Failed to create booking',
      );
    }

    return Booking.fromJson(data['booking']);
  }
}