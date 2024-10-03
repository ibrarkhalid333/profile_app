import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_app/core/JSON/users.dart';
import 'package:profile_app/src/SQLite/database_helper.dart';
import 'package:profile_app/src/auth/screens/login.dart';
import 'package:profile_app/src/components/round_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers for input fields
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String? dob; // Date of birth
  String? selectedGender = 'Male'; // Default gender
  File? _image; // Selected image file
  String? _imagePath; // Path where image will be saved
  bool _isLoading = false; // Loading state for UI

  final ImagePicker _picker = ImagePicker(); // Image picker instance
  final List<String> genders = ['Male', 'Female']; // Gender options
  final db = DatabaseHelperClass(); // Database helper instance

  // Sign up function
  Future<void> signUp(BuildContext context) async {
    try {
      var res = await db.createUser(Users(
          username: usernameController.text,
          password: passwordController.text,
          email: emailController.text,
          phone: phoneController.text,
          dob: dob ?? '',
          gender: selectedGender ?? '',
          imagepath: _imagePath));

      if (res > 0) {
        // Navigate to Login screen if signup is successful
        if (!mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    } catch (e) {
      print("Error during signup: $e");
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // Handle date formatting
  String? handleDate(DateTime? date) {
    if (date != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      return formattedDate;
    }
    return null;
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true; // Set loading state to true
      print("Loading started"); // Add debugging print
    });

    try {
      print('the try');
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      print("Picker completed"); // Check if the picker completes

      if (pickedFile != null) {
        _image = File(pickedFile.path); // Get the image file
        print('Image is picked: ${pickedFile.path}'); // Confirm image is picked

        String newImagePath = await saveImage(_image); // Save the image
        print("Image saved at: $newImagePath"); // Confirm the image is saved

        setState(() {
          _imagePath = newImagePath; // Update the image path
          print("State updated with new image path");
        });
      } else {
        print("No image selected."); // Print when no image is selected
      }
    } catch (e) {
      print("Error picking image: $e"); // Catch any errors
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
        print("Loading finished"); // Confirm loading is done
      });
    }
  }

  // Save the image to the app's document directory
  Future<String> saveImage(File? image) async {
    try {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDirectoryPath = appDocumentsDirectory.path;
      String imagesFolderPath = '$appDirectoryPath/images';

      Directory imagesFolder = Directory(imagesFolderPath);
      if (!await imagesFolder.exists()) {
        await imagesFolder.create(
            recursive: true); // Create images directory if not exist
      }

      String fileName = basename(image!.path); // Get file name
      String newImagePath = '$imagesFolderPath/$fileName'; // New image path
      File newImageFile =
          await image.copy(newImagePath); // Copy the image to new location
      print('image is saved in path ${newImagePath}');
      return newImagePath; // Return the new image path
    } catch (e) {
      print("Error saving image: $e");
      return ''; // Return empty string on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('SignUp'),
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
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : const NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                ) as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Username',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      IntlPhoneField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        initialCountryCode: 'PK',
                        onChanged: (phone) {
                          print(phone
                              .completeNumber); // Print complete phone number
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Date of Birth',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              dob = handleDate(date); // Handle date formatting
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
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
                            selectedGender = value; // Update selected gender
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      InkWell(
                        onTap: _pickImage, // Call the image picker
                        child: Container(
                          height: 30.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            color: _image != null ? Colors.green : Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? const Icon(Icons.check, color: Colors.white)
                              : const Icon(Icons.image, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : RoundButton(
                        title: 'SignUp',
                        width: 200.w,
                        onPress: () {
                          signUp(context); // Call sign-up function
                        },
                      ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?  '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text('Login'),
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
