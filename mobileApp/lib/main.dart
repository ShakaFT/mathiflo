import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/data/data.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/views/Groceries/groceries_view.dart';

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
          title: 'mathiflo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: GroceriesView(),
        ),
      );
}
