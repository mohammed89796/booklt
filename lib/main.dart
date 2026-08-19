import 'package:booklt/pages/register_page.dart';
import 'package:booklt/pages/tabs_page.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: 'pk_test_aG9wZWZ1bC1iZWV0bGUtNDAuY2xlcmsuYWNjb3VudHMuZGV2JA',
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ClerkErrorListener(
          child: ClerkAuthBuilder(
            signedInBuilder: (context, authState) {
              return const TabsPage();
            },
            signedOutBuilder: (context, authState) {
              return RegisterPage();
            },
          ),
        ),
      ),
    );
  }
}

