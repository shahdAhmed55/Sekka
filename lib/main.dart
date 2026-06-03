import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/ticketProvider.dart';
import 'package:shahd/screens/base.dart';
import 'package:shahd/providers/auth_provider.dart';
import 'package:shahd/screens/home.dart';
import 'package:shahd/screens/auth/register_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),


      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سكة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),

      home: const RegisterScreen( ),
    );
  }
}