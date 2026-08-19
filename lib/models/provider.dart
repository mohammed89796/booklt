class Provider {
  final String id;
  final String name;
  final String location;
  final String image;
  final int postalCode;

  Provider({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.postalCode,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
      image: json['image'],
      postalCode: json['postalCode'],
    );
  }
}