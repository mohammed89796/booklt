import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';


class RegisterPage extends StatelessWidget{
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SafeArea(
              child: ClerkErrorListener(
                child: ClerkAuthBuilder(
                  signedInBuilder: (context, authState) {
                    return ClerkUserButton();
                  },
                  signedOutBuilder: (context, authState) {
                    return ClerkAuthentication();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}