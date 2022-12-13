import 'package:elective_project/resources/google_sign_in.dart';
import 'package:elective_project/main_pages/login_page.dart';
import 'package:elective_project/resources/auth_methods.dart';
import 'package:elective_project/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'main_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser; // access current user's data

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            'Kitchen Goodies',
            style: GoogleFonts.bebasNeue(
              fontSize: 27,
              color: scaffoldBackgroundColor,
            ),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SettingsList(
            lightTheme: SettingsThemeData(
              settingsListBackground: scaffoldBackgroundColor
            ),
            sections: [
              SettingsSection(
                title: Text('Settings'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: Icon(Icons.person),
                    title: Text('Account'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SettingsTile.navigation(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      
                    },
                    initialValue: false,
                    leading: Icon(Icons.format_paint_rounded),
                    title: Text('Dark Theme'),
                  ),
                  SettingsTile.navigation(
                    leading: Icon(Icons.security),
                    title: Text('Privacy & Security'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SettingsTile.navigation(
                    leading: Icon(Icons.support),
                    title: Text('Help & Support'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SettingsTile.navigation(
                    leading: Icon(Icons.help),
                    title: Text('About'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
              SettingsSection(
                tiles: [
                  SettingsTile(
                    title: Text('Logout'), 
                    onPressed: (val){
                      final provider = Provider.of<GoogleSignInProvider>( 
                              context,
                              listen: false);
                          provider.logout();
                    },
                    leading: Icon(Icons.logout),

                  )
                ],
              ),
            ],
            applicationType: ApplicationType.both,
          ),
        ));
  }
}
