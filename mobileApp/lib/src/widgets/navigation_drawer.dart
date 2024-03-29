import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/view/Calendar/calendar_view.dart';
import 'package:mathiflo/src/view/CuddlyToys/cuddly_toys_view.dart';
import 'package:mathiflo/src/view/Groceries/groceries_view.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(context),
              _buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) => Container(
        color: mainColor,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  // tabs in sidebar

  Widget _buildMenuItems(BuildContext context) => Column(
        children: [
          _tab(
            context,
            "Calendrier",
            Icon(Icons.calendar_month, color: mainColor),
            const CalendarView(),
          ),

          // -----------------------------

          _tab(
            context,
            "Liste de courses",
            Icon(Icons.local_grocery_store, color: mainColor),
            const GroceriesView(),
          ),

          // -----------------------------

          _tab(
            context,
            "Doudous",
            Icon(Icons.hotel_rounded, color: mainColor),
            const CuddlyToysView(),
          ),

          // -----------------------------

          // _tab(
          //   context,
          //   "Tricount",
          //   Icon(Icons.savings, color: mainColor),
          //   const TricountView()
          // ),

          // ...
        ],
      );

  // tab style

  ListTile _tab(BuildContext context, String title, Icon icon, Widget view) =>
      ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(color: mainColor),
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => view),
          );
        },
      );
}
