import 'package:flutter/material.dart';
import 'views/Groceries/GroceriesView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Utils App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const GroceriesView(),
    );
  }
}
