class Service {
  final String id;
  final String name;
  final double price;
  final String description;
  final String providerId;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.providerId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      providerId: json['provider'],
    );
  }
}