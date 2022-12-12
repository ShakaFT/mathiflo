import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utils_app/data/data.dart';

import 'views/Groceries/GroceriesView.dart';

void main() async {
  await Data.setDatabases();
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
