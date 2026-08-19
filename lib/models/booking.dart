class Booking {
  final String id;
  final String user;
  final String provider;
  final String service;
  final DateTime date;
  final String status;

  Booking({
    required this.id,
    required this.user,
    required this.provider,
    required this.service,
    required this.date,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      user: json['user'] is String
          ? json['user']
          : json['user']['_id'] ?? '',
      provider: json['provider'] is String
          ? json['provider']
          : json['provider']['_id'] ?? '',
      service: json['service'] is String
          ? json['service']
          : json['service']['_id'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'pending',
    );
  }
}