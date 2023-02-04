import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/cuddly_toys_histories_list.dart';
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
  late CuddlyToysHistoriesNotifier cuddlyToys = CuddlyToysHistoriesNotifier();
  late final Future future = _loadCuddlyToysHistories();

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
                            CuddlyToysWidget(histories: cuddlyToys),
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

  Future<void> _loadCuddlyToysHistories() async {
    if (!await cuddlyToys.refresh()) {
      // ignore: use_build_context_synchronously
      snackbar(context, unknownError, error: true);
    }
  }
}
