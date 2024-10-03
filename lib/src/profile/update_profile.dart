import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:profile_app/main.dart';
import 'package:profile_app/src/SQLite/database_helper.dart';
import 'package:profile_app/src/auth/user_preferences.dart';
import 'package:profile_app/src/components/round_button.dart';
import 'package:profile_app/src/profile/profile.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? phoneNumber;
  String? dob;
  UserPreferences userPreferences = UserPreferences();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Handle the date input and return a formatted string
  String? handleDate(DateTime? date) {
    if (date != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      setState(() {
        dob = formattedDate;
      });
      return formattedDate;
    }
    return null;
  }

  Future<void> updateUserProfile() async {
    await userPreferences.GetUsername();
    String? username = userPreferences.username;
    DatabaseHelperClass dbHelper = DatabaseHelperClass();

    // Create the map of fields to update
    Map<String, dynamic> updates = {};

    // Only update fields if the controllers have values
    if (usernameController.text.isNotEmpty)
      updates['username'] = usernameController.text;
    if (emailController.text.isNotEmpty)
      updates['email'] = emailController.text;
    if (passwordController.text.isNotEmpty)
      updates['password'] = passwordController.text;
    if (phoneNumber != null && phoneNumber!.isNotEmpty)
      updates['phone'] = phoneNumber;
    if (dob != null && dob!.isNotEmpty) updates['dob'] = dob;

    if (updates.isNotEmpty && username != null) {
      int rowsUpdated = await dbHelper.updateUser(username, updates);

      if (rowsUpdated > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        UserPreferences userPreferences = UserPreferences();
        userPreferences.updateuserName(usernameController.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      } else {
        print('No user found with the provided username');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
      }
    } else {
      print('No fields to update or username not found');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide at least one field to update.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Improved Padding
            child: Center(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to the left
                children: [
                  // Title Heading
                  Text(
                    'Update Your Profile',
                    style: TextStyle(
                      fontSize: 24.sp, // Adjusted font size for title
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Username Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Username:'),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                            labelText: 'Enter your username',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Email Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Email:'),
                      SizedBox(width: 34.w),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: 'Enter your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Password Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Password:'),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: 'Enter new password',
                          ),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Phone Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Phone:'),
                      SizedBox(width: 30.w),
                      Expanded(
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          initialCountryCode: 'PK',
                          onChanged: (phone) {
                            phoneNumber = phone.completeNumber;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Date of Birth Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('DOB:'),
                      SizedBox(width: 40.w),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: dob ?? 'Select Date of Birth',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                );
                                handleDate(date);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Submit Button
                  Center(
                    child: RoundButton(
                      width: 200.w,
                      onPress: updateUserProfile, // Call the update method
                      title: 'Update Profile',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
