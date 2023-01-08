import 'package:elective_project/util/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../community_page/models/user.dart' as model;

class AboutWidget extends StatelessWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "About",
          style: TextStyle(color: mPrimaryTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(1),
          child: Column(
            children: [
              SvgPicture.asset(
                'images/logos/kitchen-goodies.svg',
                width: 250,
                height: 250,
              ),
              const Divider(),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  "Version",
                  style: TextStyle(
                    color: mPrimaryTextColor,
                  ),
                ),
                trailing: const Text("Alpha Testing"),
              ),
              SettingMenu(title: "Contact Us", icon: Icons.phone, onPress: (() {})),
              SettingMenu(title: "Rate Us", icon: Icons.star, onPress: (() {})),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: mPrimaryColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: mPrimaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Color == null ? mPrimaryTextColor : textColor,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18.0,
              ),
            )
          : null,
    );
  }
}
