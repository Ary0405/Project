import 'dart:async';
import 'dart:math';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:swapsta/icons/swapcons_icons.dart';
import 'package:swapsta/providers/bottom_nav_visibility_provider.dart';
import 'package:swapsta/providers/screen_provider.dart';
import 'package:swapsta/screens/add_item_screen.dart';
import 'package:swapsta/screens/explore_screen.dart';
import 'package:swapsta/screens/listing_screen.dart';
import 'package:swapsta/screens/profile_screen.dart';
import 'package:swapsta/screens/swap_screen.dart';
import 'package:swapsta/widgets/settings_sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);

  ScrollController? _scrollController;
  String selectedFilter = 'All Categories';
  String searchQuery = '';
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  final _screens = [
    const ExploreScreen(),
    const SwapScreen(),
    const ListingScreen(),
  ];
  void _indicateLoading() {
    setState(() {
      loading = true;
    });
  }

  void _refresh() {
    return setState(
      () {
        loading = false;
      },
    );
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    int screenIndex = Provider.of<ScreenProvider>(context).screenIndex;

    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: () async {
          _indicateLoading();
          Future.delayed(const Duration(seconds: 2)).then(
            (_) => _refresh(),
          );
        },
        child: Stack(
          children: [
            SafeArea(
              child: _screens[screenIndex],
              bottom: false,
            )
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Consumer<BottomBarVisibilityProvider>(
        builder: (context, bottomBarVisibilityProvider, _) => AnimatedOpacity(
          opacity: bottomBarVisibilityProvider.isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !bottomBarVisibilityProvider.isVisible,
            child: DotNavigationBar(
              backgroundColor: Colors.black,
              dotIndicatorColor: Colors.white,
              currentIndex: screenIndex,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                )
              ],
              enablePaddingAnimation: false,
              onTap: (int index) {
                Provider.of<ScreenProvider>(context, listen: false)
                    .setScreenIndex(index);
              },
              items: [
                DotNavigationBarItem(
                    icon: const Icon(Icons.explore),
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey),
                DotNavigationBarItem(
                    icon: const Icon(Swapcons.swap),
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey),
                DotNavigationBarItem(
                    icon: const Icon(Icons.list_alt_rounded),
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey),
              ],
            ),
          ),
        ),
      ),
      endDrawer: const Drawer(
        child: SettingsDrawer(),
      ),
    );
  }
}
