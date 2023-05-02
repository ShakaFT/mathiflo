import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Mathiflo/mathiflo_controller.dart';
import 'package:mathiflo/src/view/home_view.dart';
import 'package:state_extended/state_extended.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfigData();
  await initializeDateFormatting();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final controller = MathifloController();
  await controller.initialize();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mathiflo',
      theme: _theme(),
      darkTheme: _theme(),
      home: Mathiflo(controller: controller),
    ),
  );
}

class Mathiflo extends StatefulWidget {
  const Mathiflo({super.key, required this.controller});
  final MathifloController controller;

  @override
  State createState() => _MathifloState();
}

class _MathifloState extends AppStateX<Mathiflo> {
  factory _MathifloState() => _this ??= _MathifloState._();
  _MathifloState._() : super();
  static _MathifloState? _this;

  late MathifloController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget buildIn(BuildContext context) => HomeView(controller: _controller);
}

_theme() => ThemeData(
      primaryColor: mainColor,
    );
