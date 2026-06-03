import 'package:flutter/material.dart';
import 'sos_button.dart';
import 'package:shahd/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await addTestData();

  runApp(const RailMateApp());
}

Future<void> addTestData() async {
  final users = await UserModel.getAllUsers();

  if (users.isNotEmpty) {
    print("Test data already exists");
    return;
  }

  // // 1. fake user
  // await UserModel.insertUser({
  //   'name': 'Ahmed',
  //   'email': 'Ahmed@gmail.com',
  //   'phone': '01012345678',
  //   'password': '123456',
  // });

  print("TEST DATA INSERTED (USERS & CONTACTS ONLY)");
}

class RailMateApp extends StatelessWidget {
  const RailMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RailMate SOS',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EmergencyTypesScreen(),
    );
  }
}
