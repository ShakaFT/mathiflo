import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/CuddlyToys/cuddly_toys_controller.dart';
import 'package:mathiflo/src/view/CuddlyToys/cuddly_toys.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/navigation_drawer.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:state_extended/state_extended.dart';

class CuddlyToysView extends StatefulWidget {
  const CuddlyToysView({super.key});

  @override
  State createState() => _CuddlyToysViewState();
}

class _CuddlyToysViewState extends StateX<CuddlyToysView> {
  _CuddlyToysViewState() : super(CuddlyToysController()) {
    _controller = controller! as CuddlyToysController;
  }
  late CuddlyToysController _controller;

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: appBar("Doudous"),
          body: FutureBuilder(
            // ignore: discarded_futures
            future: _loadCuddlyToysHistories(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? loader()
                    : RefreshIndicator(
                        color: mainColor,
                        onRefresh: _loadCuddlyToysHistories,
                        child: CuddlyToysWidget(controller: _controller),
                      ),
          ),
          drawer: const NavigationDrawerWidget(),
        ),
        onWillPop: () async => false,
      );

  // Action methods

  Future<void> _loadCuddlyToysHistories() async {
    if (!await _controller.refreshCuddlyToys()) {
      if (mounted) snackbar(context, unknownError, error: true);
    }
  }
}
