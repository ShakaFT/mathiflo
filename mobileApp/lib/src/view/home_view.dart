import 'package:flutter/material.dart';
import 'package:mathiflo/src/view/CuddlyToys/cuddly_toys_view.dart';
import 'package:mathiflo/src/view/Groceries/groceries_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            _test(context, 'assets/home_page/example.jpeg', nbItems: 2),
            _test(context, 'assets/home_page/example.png'),
            _gridItem(
              context,
              "Doudous",
              Icons.hotel_rounded,
              Colors.red,
              const CuddlyToysView(),
            ),
            _gridItem(
              context,
              "Liste de courses",
              Icons.local_grocery_store,
              Colors.yellow,
              const GroceriesView(),
            ),
            _gridItem(context, "Feature 3", Icons.home, Colors.green, null),
            _gridItem(context, "Feature 4", Icons.home, Colors.grey, null),
            _gridItem(context, "Feature 5", Icons.home, Colors.blue, null),
            _gridItem(context, "Feature 6", Icons.home, Colors.orange, null),
            _gridItem(context, "Feature 7", Icons.home, Colors.pink, null),
            _gridItem(context, "Feature 8", Icons.home, Colors.black, null),
            _gridItem(context, "Feature 7", Icons.home, Colors.cyan, null),
            _gridItem(context, "Feature 8", Icons.home, Colors.teal, null)
          ],
        ),
      );
}

_gridItem(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  Widget? direction,
) =>
    InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => direction!),
        );
      }, // Handle your callback
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: DecoratedBox(
          decoration: BoxDecoration(
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
        ),
      ),
    );

_test(BuildContext context, String path, {int nbItems = 1}) {
  print(MediaQuery.of(context).size.width);
  return Image.asset(
    path,
    height: 100.0 * nbItems,
    width: MediaQuery.of(context).size.width,
    fit: BoxFit.fill,
  );
}
