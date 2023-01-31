import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/cuddly_toys.dart';
import 'package:mathiflo/views/CuddlyToys/widgets/cuddly_toys.dart';
import 'package:mathiflo/widgets/bar.dart';
import 'package:mathiflo/widgets/navigation_drawer.dart';
import 'package:mathiflo/widgets/popups.dart';

useCuddlyToysView() => use(const _CuddlyToysView());

class _CuddlyToysView extends Hook<void> {
  const _CuddlyToysView();

  @override
  _CuddlyToysViewState createState() => _CuddlyToysViewState();
}

class _CuddlyToysViewState extends HookState<void, _CuddlyToysView> {
  late CuddlyToysNotifier cuddlyToys = CuddlyToysNotifier();
  late final Future future = _loadCuddlyToys();

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: appBar("Doudous", icons: _appBarIcons()),
          body: FutureBuilder(
            // ignore: discarded_futures
            future: future,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator(color: mainColor))
                    : HookBuilder(
                        builder: (context) =>
                            CuddlyToysWidget(cuddlyToys: cuddlyToys),
                      ),
          ),
          drawer: const NavigationDrawerWidget(),
        ),
        onWillPop: () async => false,
      );

  // Widget methods

  _appBarIcons() => <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
      ];

  // Action methods

  Future<void> _loadCuddlyToys() async {
    if (!await cuddlyToys.refresh()) {
      snackbar(context, unknownError, error: true);
    }
  }
}
