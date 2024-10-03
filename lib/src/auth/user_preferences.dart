import 'package:profile_app/core/JSON/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  String? username;
  Future<void> SaveUser(Users? user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('username', user!.username);
  }

  Future<bool> DeleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('username');
    return true;
  }

  Future<void> GetUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
  }

  Future<void> updateuserName(String updateusername) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool istrue = await pref.setString('username', updateusername);
    print('${istrue} + done');
    if (istrue) {
      username = pref.getString('username');
      print(username);
    }
  }
}
