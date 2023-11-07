import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swapsta/widgets/pill.dart';
import '../../globals.dart' as globals;
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/sort_modal.dart';
import '../widgets/swappables_grid.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final categories = globals.categories;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);

  ScrollController? _scrollController;
  String selectedFilter = 'All Categories';
  String searchQuery = '';
  Sort sort = Sort.added;
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
    });
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

  void _onSearchQueryChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  void _onSortChanged(Sort value) {
    setState(() {
      sort = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      showChildOpacityTransition: false,
      child: Column(
        children: [
          const HomeHeader(),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Flexible(
                  child: SearchBox(
                    handleSearch: (String value) {
                      _onSearchQueryChanged(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 10),
            height: 50,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                return Pill(
                  name: categories[i].name,
                  emoji: categories[i].emoji,
                  handleTap: () {
                    _onFilterChanged(categories[i].name);
                  },
                  active: selectedFilter == categories[i].name,
                ); // return category pill widget here
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SwappablesGrid(
                  filter: selectedFilter,
                  searchQuery: searchQuery,
                  order: sort,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
