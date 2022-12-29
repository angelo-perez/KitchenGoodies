import 'package:elective_project/main_pages/community_page/community_page.dart';
import 'package:elective_project/main_pages/create_page.dart';
import 'package:elective_project/main_pages/home_page.dart';
import 'package:elective_project/main_pages/recipes_page.dart';
import 'package:elective_project/main_pages/setting_page.dart';
import 'package:elective_project/resources/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

//Main Page of the App (w/ Bottom Navigation Bar)

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //int currentNavIndex = 0;
  //int _page = 0;
  //final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  Color navBarColor = const Color(0xFF12A2726);
  static Color canvasColor = const Color(0xFFF2E5D9);
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  final _screens = [
    HomePage(),
    RecipesPage(),
    CreatePage(),
    CommunityPage(),
    SettingsPage(),
  ];

  // bool isClickedCategory1 = false;
  // bool isClickedCategory2 = false;
  // bool isClickedCategory3 = false;
  // bool isClickedCategory4 = false;
  // bool isClickedCategory5 = false;
  // bool isClickedCategory7 = false;
  // bool isClickedCategory8 = false;

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    // final items = <Widget>[
    //   Icon(
    //     Icons.home_filled,
    //     size: 30,
    //   ),
    //   Icon(
    //     Icons.food_bank,
    //     size: 30,
    //   ),
    //   Icon(
    //     Icons.groups_rounded,
    //     size: 30,
    //   ),

    // ];

    return Scaffold(
      // body: screens[_page], //selects what page it will display
      // bottomNavigationBar: Theme(
      //   data: Theme.of(context).copyWith(
      //       iconTheme: IconThemeData(
      //     color: Color(0xFFF2E5D9),
      //   )),
      //   child: CurvedNavigationBar(
      //     key: _bottomNavigationKey,
      //     index: _page,
      //     height: 60.0,
      //     items: items,
      //     color: Color(0xFF12A2726),
      //     buttonBackgroundColor: Color(0xFF12A2726),
      //     backgroundColor: Color(0xFFF2E5D9),
      //     animationCurve: Curves.easeInOut,
      //     animationDuration: Duration(milliseconds: 300),
      //     onTap: (index) {
      //       setState(() {
      //         _page = index;
      //       });
      //     },
      //     letIndexChange: (index) => true,
      //   ),
      // ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style12,
        backgroundColor: navBarColor,
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: canvasColor,
        inactiveColorPrimary: canvasColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.book),
        title: ("Recipes"),
        activeColorPrimary: canvasColor,
        inactiveColorPrimary: canvasColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.add),
        title: ("Create"),
        activeColorPrimary: canvasColor,
        inactiveColorPrimary: canvasColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.group),
        title: ("Community"),
        activeColorPrimary: canvasColor,
        inactiveColorPrimary: canvasColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: canvasColor,
        inactiveColorPrimary: canvasColor,
      ),
    ];
  }
}
