import 'package:flutter/material.dart';
import 'package:shahd/screens/home.dart';
import 'package:shahd/screens/auth/register_screen.dart';

class BaseSreen extends StatelessWidget {
  const BaseSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterScreen();
  }
}