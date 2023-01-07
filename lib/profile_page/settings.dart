import 'package:blurry/blurry.dart';
import 'package:elective_project/profile_page/settings_changePassword.dart';
import 'package:elective_project/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickalert/quickalert.dart';
import '../start_up_page/login_page.dart';
import '../util/colors.dart';

class UserManagementWidget extends StatelessWidget {
  const UserManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: mPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
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
              SettingMenu(
                title: "Change Password",
                icon: Icons.password,
                onPress: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const ChangePassword())),
              ),
              SettingMenu(
                title: "Delete Account",
                icon: Icons.delete_forever,
                onPress: () {
                  _onDeleteAccountPressed(context);
                },
                textColor: Colors.red,
                endIcon: false,
                iconColor: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> _onDeleteAccountPressed(BuildContext context) async {
  bool deleteAccount = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure? Your account will be lost forever"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              AuthMethods().deleteUser();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
            },
            child: Text(
              "Yes",
              style: TextStyle(color: mPrimaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              "No",
              style: TextStyle(color: mPrimaryTextColor),
            ),
          ),
        ],
      );
    },
  );
  return deleteAccount;
}

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.iconColor,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? iconColor;

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
          color: iconColor == null ? mPrimaryTextColor : textColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? mPrimaryTextColor,
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
