import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/views/Groceries/groceries_view.dart';

void main() async {
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
          theme: _theme(),
          darkTheme: _darkTheme(),
          home: HookBuilder(
            builder: (context) => useGroceriesView(),
          ),
        ),
      );
}

_darkTheme() => ThemeData(
      primarySwatch: Colors.orange,
    );

_theme() => ThemeData(
      primarySwatch: Colors.orange,
    );
