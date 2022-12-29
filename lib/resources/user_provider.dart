import 'package:elective_project/resources/auth_methods.dart';
import 'package:flutter/widgets.dart';

import '../main_pages/community_page/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  bool get isLoggedIn => _user != null;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;

    notifyListeners();
  }
}
