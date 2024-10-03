import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profile_app/core/JSON/users.dart';
import 'package:profile_app/main.dart';
import 'package:profile_app/src/SQLite/database_helper.dart';
import 'package:profile_app/src/auth/screens/login.dart';
import 'package:profile_app/src/auth/user_preferences.dart';
import 'package:profile_app/src/components/round_button.dart';
import 'package:profile_app/src/profile/update_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserPreferences userPreferences = UserPreferences();
  DatabaseHelperClass db = DatabaseHelperClass();
  Users? profile;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  Future<void> getUserDetail() async {
    await userPreferences.GetUsername();
    String? username = userPreferences.username;
    if (username != null) {
      Users? fetchuser = await db.getUser(username);
      if (fetchuser != null) {
        setState(() {
          profile = fetchuser;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text('Profile', style: TextStyle(fontSize: 20)),
      ),
      body: SafeArea(
        child: profile == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30.h),

                      // Profile Picture
                      CircleAvatar(
                        radius: 55.r,
                        backgroundColor: Colors.blueAccent,
                        child: CircleAvatar(
                          radius: 53.r,
                          backgroundImage: profile?.imagepath != null &&
                                  profile!.imagepath!.isNotEmpty
                              ? FileImage(File(profile!.imagepath!))
                              : NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Username
                      Text(
                        profile?.username ?? "",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Details Section Title
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Email
                      ListTile(
                        leading: Icon(
                          Icons.email,
                          size: 28.sp,
                          color: Colors.blueAccent,
                        ),
                        title: Text(
                          profile!.email ?? "",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Divider(),

                      // Phone
                      ListTile(
                        leading: Icon(
                          Icons.phone,
                          size: 28.sp,
                          color: Colors.blueAccent,
                        ),
                        title: Text(
                          profile!.phone ?? "",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Divider(),

                      // Date of Birth
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          size: 28.sp,
                          color: Colors.blueAccent,
                        ),
                        title: Text(
                          profile!.dob ?? "",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Divider(),

                      // Gender
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.user,
                          size: 28.sp,
                          color: Colors.blueAccent,
                        ),
                        title: Text(
                          profile!.gender ?? "",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // Update and Logout Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundButton(
                            title: 'Update',
                            width: 120.w,
                            onPress: () async {
                              // Navigate and refresh profile when returning
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProfile(),
                                ),
                              );
                              // Reload user details after returning
                              getUserDetail();
                            },
                          ),
                          SizedBox(width: 20.w),
                          RoundButton(
                            title: 'Logout',
                            width: 120.w,
                            onPress: () {
                              userPreferences.DeleteUser();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
