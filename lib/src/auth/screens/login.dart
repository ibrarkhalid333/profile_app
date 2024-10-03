import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:profile_app/core/JSON/users.dart';
import 'package:profile_app/core/SQLite/database_helper.dart';
import 'package:profile_app/main.dart';
import 'package:profile_app/src/SQLite/database_helper.dart';
import 'package:profile_app/src/auth/screens/signup.dart';
import 'package:profile_app/src/auth/user_preferences.dart';
import 'package:profile_app/src/components/round_button.dart';
import 'package:profile_app/src/profile/profile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloginTrue = false;
  final username = TextEditingController();
  final password = TextEditingController();
  final db = DatabaseHelperClass();
  login() async {
    Users? userdetail = await db.getUser(username.text);
    var res = await db
        .authenticate(Users(username: username.text, password: password.text));
    UserPreferences userPreferences = UserPreferences();
    userPreferences.SaveUser(userdetail);
    if (res == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    } else {
      setState(() {
        isloginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0.sp),
            child: Center(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 48.r,
                        backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'username'),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'password'),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    RoundButton(
                        title: 'Login',
                        width: 200.w,
                        onPress: () {
                          login();
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Donot have an account  '),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signup(),
                                ),
                              );
                            },
                            child: Text('SignUp'))
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
