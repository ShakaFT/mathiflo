import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/view/Calendar/calendar_view.dart';
import 'package:state_extended/state_extended.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfigData();
  await initializeDateFormatting();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mathiflo',
      theme: _theme(),
      darkTheme: _theme(),
      home: const Mathiflo(),
    ),
  );
}

class Mathiflo extends StatefulWidget {
  const Mathiflo({super.key});

  @override
  State createState() => _MathifloState();
}

class _MathifloState extends AppStateX<Mathiflo> {
  factory _MathifloState() => _this ??= _MathifloState._();
  _MathifloState._() : super();
  // _MathifloState._() : super(controller: MathifloController());
  static _MathifloState? _this;

  @override
  Widget buildIn(BuildContext context) => const CalendarView();
}

_theme() => ThemeData(
      // primarySwatch: Colors.orange,
      primaryColor: mainColor,
    );
