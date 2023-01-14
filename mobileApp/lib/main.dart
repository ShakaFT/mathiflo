import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/config/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/groceries_list.dart';
import 'package:mathiflo/views/Groceries/groceries_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfigData();
  log(groceriesUrl);
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
          darkTheme: _theme(),
          home: HookBuilder(
            builder: (context) => useGroceriesView(),
          ),
        ),
      );
}

_theme() => ThemeData(
      // primarySwatch: Colors.orange,
      primaryColor: mainColor,
    );
