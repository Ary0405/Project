import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapsta/providers/recieved_swap_provider.dart';
import 'package:swapsta/providers/sent_swaps_provider.dart';
import 'package:swapsta/providers/swap_history_provider.dart';
import 'package:swapsta/widgets/recieved_swap_list.dart';
import 'package:swapsta/widgets/sent_swap_list.dart';
import 'package:swapsta/widgets/swap_history_list.dart';
import '../widgets/swapscreen_header.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);
  static const routeName = '/swap-screen';

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> with TickerProviderStateMixin {
  String searchQuery = '';

  void _onSearchQueryChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    List<Map<String, dynamic>> tabsData = [
      {
        "child": null,
        "text": "Sent",
      },
      {
        "child": null,
        "text": "Recieved",
      },
      {
        "child": null,
        "text": "History",
      },
    ];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SentSwap(),
        ),
        ChangeNotifierProvider(
          create: (_) => SwapHistory(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecievedSwap(),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwapscreenHeader(
            handleSearch: _onSearchQueryChanged,
          ),
          Container(
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
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: sentswapslist(
                      searchQuery: searchQuery,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: recievedswapslist(
                        searchQuery: searchQuery, tabSwitcher: _tabController),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: swaphistorylist(
                      searchQuery: searchQuery,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class CustomTabIndicator extends Decoration {
  final double radius;

  final Color color;

  final double indicatorHeight;

  const CustomTabIndicator({
    this.radius = 8,
    this.indicatorHeight = 4,
    this.color = Colors.transparent,
  });

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      radius,
      color,
      indicatorHeight,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
    this.radius,
    this.color,
    this.indicatorHeight,
  ) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint();
    double xAxisPos = offset.dx + configuration.size!.width / 2;
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2;
    paint.color = color;

    RRect fullRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(xAxisPos, yAxisPos),
        width: configuration.size!.width / 3,
        height: indicatorHeight,
      ),
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );

    canvas.drawRRect(fullRect, paint);
  }
}
