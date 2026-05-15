import 'package:flutter/material.dart';
import 'package:sekka_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sekka_app/providers/auth_provider.dart';

class BaseSreen extends StatelessWidget {
  const BaseSreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}

// notifyListeners();

//shahd branch
