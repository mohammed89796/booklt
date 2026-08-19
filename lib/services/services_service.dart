import 'dart:convert';

import 'package:booklt/models/service.dart';
import 'package:http/http.dart' as http;

class ServicesService {
  Future<List<Service>> getServices(String providerId) async {
    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2:3000/api/providers/$providerId/services',
      ),
    );

    final List data = jsonDecode(response.body);

    return data
        .map((json) => Service.fromJson(json))
        .toList();
  }
}