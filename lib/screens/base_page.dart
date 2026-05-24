import 'package:flutter/material.dart';
import 'package:sekka_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sekka_app/providers/auth_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BaseSreen extends StatelessWidget {
  const BaseSreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
          locale: const Locale('ar', 'EG'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomeScreen()),
    );
  }
}

// notifyListeners();
