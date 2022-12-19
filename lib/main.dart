import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:utils_app/data/data.dart';
import 'package:utils_app/models/groceries_list.dart';
import 'package:utils_app/views/Groceries/groceries_view.dart';

void main() async {
  await setDatabases();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => StateNotifierProvider(
        create: (context) => GroceriesListNotifier(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Utils App',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: GroceriesView(),
        ),
      );
}
