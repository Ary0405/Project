import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapsta/screens/explore_screen.dart';
import 'package:swapsta/screens/profile_screen.dart';
import 'package:swapsta/screens/swap_screen.dart';
import 'package:swapsta/screens/add_item_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import './providers/swappables_provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Swappables(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFF9F6F2),
          fontFamily: 'RedHatDisplay',
        ),
        home: const Home(),
        routes: {"/add-item": (context) => const AddItemScreen()},
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  int _screenIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _screenIndex = index;
    });
  }

  final _screens = [
    const ExploreScreen(),
    const SwapScreen(),
    const ProfileScreen(),
    const AddItemScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
          top: 0,
          left: -20,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('assets/img/circle.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.3), BlendMode.modulate)),
            ),
          ),
        ),
        SafeArea(
          child: _screens[_screenIndex],
          bottom: false,
        )
      ]),
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
          dotIndicatorColor: Colors.orange,
          currentIndex: _screenIndex,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
          enablePaddingAnimation: false,
          onTap: (int index) {
            _selectPage(index);
          },
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.explore),
              selectedColor: Colors.orange,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.swap_horiz),
              selectedColor: Colors.orange,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              selectedColor: Colors.orange,
            ),
          ]),
    );
  }
}
