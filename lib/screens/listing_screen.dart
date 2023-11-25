import 'package:flutter/material.dart';
import 'package:swapsta/screens/swap_screen.dart';
import 'package:swapsta/widgets/profile_header.dart';
import '../globals.dart' as globals;
import '../widgets/wishlist_tab.dart';
import '../widgets/my_items_tab.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ListingScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final wishlistedSwappables = globals.wishlistedSwappables;
    final mySwappables = globals.mySwappables;

    TabController _tabController = TabController(length: 2, vsync: this);
    List<Map<String, dynamic>> tabsData = [
      {
        "icon": Icons.lightbulb_outlined,
        "text": "My Items",
      },
      {
        "icon": Icons.favorite_outline_rounded,
        "text": "Favorites",
      }
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.09,
            padding: EdgeInsets.all(
              10,
            ),
            // width: 100,
            child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF4F6FB),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
              ),
            ),
            child: TabBar(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              labelColor: Colors.black,
              unselectedLabelColor: const Color.fromRGBO(158, 158, 158, .35),
              indicator: const CustomTabIndicator(),
              indicatorPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.015,
              ),
              tabs: tabsData
                  .map(
                    (tabData) =>
                        _buildTab(context: context, text: tabData["text"]),
                  )
                  .toList(),
              controller: _tabController,
            ),
          ),

          ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .025,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              MyItems(mySwappables: mySwappables),
              WishlistTab(wishlistedSwappables: wishlistedSwappables),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildTab({
  required BuildContext context,
  required String text,
}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.09,
    child: Tab(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}