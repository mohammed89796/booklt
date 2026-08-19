import 'dart:convert';

import 'package:booklt/models/provider.dart';
import 'package:http/http.dart' as http;

class ProviderService {
  Future<List<Provider>>getProviders()async{
    final response =await http.get(Uri.parse('http://10.0.2.2:3000/api/providers'));
    final List data=jsonDecode(response.body);
    return data.
      map((json)=>Provider.fromJson(json)).toList();
  }
}