import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_page.dart';
import 'recipes_page.dart';
import 'community_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        primaryColor: Color(0xFF12A2726),
      ),
    );
  }
}

//Main Page of the App (w/ Bottom Navigation Bar)
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //int currentNavIndex = 0;
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final screens = [
    HomePage(),
    RecipesPage(),
    CommunityPage(),
  ];

  // bool isClickedCategory1 = false;
  // bool isClickedCategory2 = false;
  // bool isClickedCategory3 = false;
  // bool isClickedCategory4 = false;
  // bool isClickedCategory5 = false;
  // bool isClickedCategory7 = false;
  // bool isClickedCategory8 = false;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.home_filled,
        size: 30,
      ),
      Icon(
        Icons.food_bank,
        size: 30,
      ),
      Icon(
        Icons.groups_rounded,
        size: 30,
      ),
      
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Goodies'),
        backgroundColor: Color(0xFF12A2726),
      ),
      body: screens[_page], //selects what page it will display
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(
          color: Color(0xFFF2E5D9),
        )),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          height: 60.0,
          items: items,
          color: Color(0xFF12A2726),
          buttonBackgroundColor: Color(0xFF12A2726),
          backgroundColor: Color(0xFFF2E5D9),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
