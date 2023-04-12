import 'package:flutter/material.dart';
import 'package:mathiflo/src/widgets/bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar("Bienvenue sur Mathiflo"),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              _gridItem("Title 1", Icons.home, Colors.red),
              _gridItem("Title 2", Icons.home, Colors.yellow),
              _gridItem("Title 3", Icons.home, Colors.green),
              _gridItem("Title 4", Icons.home, Colors.grey)
            ],
          ),
        ),
      );
}

_gridItem(String title, IconData icon, Color color) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    );
