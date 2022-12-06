import 'package:flutter/material.dart';
import '../widgets/NavigationDrawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: const NavigationDrawer(),
    );
  }
}
