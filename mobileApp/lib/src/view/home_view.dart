import 'package:flutter/material.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/src/controller/Mathiflo/mathiflo_controller.dart';
import 'package:mathiflo/src/view/CuddlyToys/cuddly_toys_view.dart';
import 'package:mathiflo/src/view/Groceries/groceries_view.dart';
import 'package:mathiflo/src/widgets/popups.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.controller});
  final MathifloController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: needUpdateAppPopup(
          bundleId: packageInfo.packageName,
          display: !controller.needUpdateApp,
          child: ListView(
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
            ],
          ),
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

_test(BuildContext context, String path, {int nbItems = 1}) => Image.asset(
      path,
      height: 100.0 * nbItems,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    );
