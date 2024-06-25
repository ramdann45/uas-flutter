import 'package:flutter/material.dart';
import 'package:learn_1/pages/new-user/firstPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramdan Nugraha',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
    );
  }
}
