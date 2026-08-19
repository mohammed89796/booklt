import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<String?> getToken(BuildContext context) async {
    final clerk = ClerkAuth.of(context);
    final sessionToken = await clerk.sessionToken();
    return sessionToken.jwt;
  }

  static Stream<String> tokenStream(BuildContext context) {
    final clerk = ClerkAuth.of(context);
    return clerk.sessionTokenStream.map((token) => token.jwt);
  }
}