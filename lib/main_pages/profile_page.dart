import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/profile_page/about_widget.dart';
import 'package:elective_project/profile_page/edit_profile_widget.dart';
import 'package:elective_project/profile_page/settings.dart';
import 'package:elective_project/profile_page/view_profile.dart';
import 'package:elective_project/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/google_sign_in.dart';
import '../providers/user_provider.dart';
import '../community_page/models/user.dart' as model;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    // final user = FirebaseAuth.instance.currentUser; // access current user's data
    String useruid = user.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        title: Text(
          "  Account",
          style: TextStyle(color: mPrimaryTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: SvgPicture.asset('images/icons/settings/night-mode.svg'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(user.profImage),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user.username,
                style: TextStyle(
                  color: mPrimaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: TextStyle(
                  color: mPrimaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EditProfileWidget())),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    "Edit Profile",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              SettingMenu(
                title: "View Profile",
                icon: Icons.person,
                onPress: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewProfile(
                          uid: user.uid,
                        ))),
              ),
              SettingMenu(
                title: "Settings",
                icon: Icons.settings,
                onPress: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const UserManagementWidget())),
              ),
              const Divider(),
              SettingMenu(
                title: "About",
                icon: Icons.info_outline,
                onPress: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const AboutWidget())),
              ),
              SettingMenu(
                title: "Logout",
                icon: Icons.logout,
                onPress: () {
                  _onDeleteAccountPressed(context);
                  // final googleProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  // googleProvider.logout(context);
                },
                endIcon: false,
                textColor: Colors.red,
              ),
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

Future<bool> _onDeleteAccountPressed(BuildContext context) async {
  bool deleteAccount = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout Account"),
        content: const Text("Confirm Logout"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final googleProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
              googleProvider.logout(context);
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
