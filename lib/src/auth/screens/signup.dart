import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:profile_app/core/JSON/users.dart';
import 'package:profile_app/src/SQLite/database_helper.dart';
import 'package:profile_app/src/auth/screens/login.dart';
import 'package:profile_app/src/components/round_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/src/profile/profile.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  String? dob;
  String? selectedGender;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  final List<String> genders = [
    'Male',
    'Female',
  ];
  final db = DatabaseHelperClass();
  IsSignUp() async {
    var res = await db.createUser(Users(
        username: username.text,
        password: password.text,
        email: email.text,
        phone: phone.text,
        dob: dob,
        gender: selectedGender));
    if (res > 0) {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  String? handleDate(DateTime? date) {
    if (date != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      setState(() {});
      return formattedDate;
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('SignUp'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: 38.r,
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Username',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      IntlPhoneField(
                        controller: phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'PK',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Date of Birth',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month),
                            onPressed: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              dob = handleDate(date);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Select Gender',
                        ),
                        value: selectedGender,
                        items: genders
                            .map((gender) => DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          height: 30.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            color: _image != null ? Colors.green : Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RoundButton(
                  title: 'SignUp',
                  width: 200.w,
                  onPress: () {
                    IsSignUp();
                  },
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account  '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
