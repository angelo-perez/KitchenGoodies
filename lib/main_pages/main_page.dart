import 'package:elective_project/main_pages/community_page.dart';
import 'package:elective_project/create_recipe/create_page.dart';
import 'package:elective_project/main_pages/home_page.dart';
import 'package:elective_project/main_pages/myrecipes_page.dart';
import 'package:elective_project/main_pages/recipes_page.dart';
import 'package:elective_project/main_pages/profile_page.dart';
import 'package:elective_project/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../util/colors.dart';

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
    MyRecipesPage(),
    CommunityPage(),
    SettingsPage(),
  ];

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
    _precacheImage();

    FlutterRingtonePlayer.stop;

    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style12,
        hideNavigationBarWhenKeyboardShows: true,
        confineInSafeArea: true,
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(FluentIcons.home_24_filled),
        title: ("Home"),
        activeColorPrimary: appBarColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FluentIcons.food_24_filled),
        title: ("Recipes"),
        activeColorPrimary: appBarColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FluentIcons.add_square_24_filled),
        title: ("My Recipes"),
        activeColorPrimary: appBarColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FluentIcons.people_24_filled),
        title: ("Community"),
        activeColorPrimary: appBarColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FluentIcons.settings_20_filled),
        title: ("Settings"),
        activeColorPrimary: appBarColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  void _precacheImage() {
    precacheImage(AssetImage("images/recipe_categories/chicken.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/pork.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/beef.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/fish.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/crustacean.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/vegetables.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/dessert.jpg"), context);
    precacheImage(AssetImage("images/recipe_categories/others.jpg"), context);
  }
}
