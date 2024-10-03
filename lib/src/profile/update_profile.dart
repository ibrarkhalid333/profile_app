import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_app/main.dart';
import 'package:profile_app/src/SQLite/database_helper.dart';
import 'package:profile_app/src/auth/user_preferences.dart';
import 'package:profile_app/src/components/round_button.dart';
import 'package:profile_app/src/profile/profile.dart';
import 'dart:io';

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
  File? _image; // Selected image file
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Gender handling
  String? selectedGender = 'Male'; // Default gender
  final List<String> genders = ['Male', 'Female']; // Gender options

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
      print('image is saved in path $newImagePath');
      return newImagePath; // Return the new image path
    } catch (e) {
      print("Error saving image: $e");
      return ''; // Return empty string on error
    }
  }

  Future<void> updateUserProfile(BuildContext context) async {
    await userPreferences.GetUsername();
    String? currentUsername = userPreferences.username;
    DatabaseHelperClass dbHelper = DatabaseHelperClass();

    // Create the map of fields to update
    Map<String, dynamic> updates = {};

    if (usernameController.text.isNotEmpty)
      updates['username'] = usernameController.text;
    if (emailController.text.isNotEmpty)
      updates['email'] = emailController.text;
    if (passwordController.text.isNotEmpty)
      updates['password'] = passwordController.text;
    if (phoneNumber != null && phoneNumber!.isNotEmpty)
      updates['phone'] = phoneNumber;
    if (dob != null && dob!.isNotEmpty) updates['dob'] = dob;
    if (selectedGender != null && selectedGender!.isNotEmpty)
      updates['gender'] = selectedGender;
    if (_imagePath != null && _imagePath!.isNotEmpty)
      updates['imagepath'] = _imagePath;

    if (updates.isNotEmpty && currentUsername != null) {
      int rowsUpdated = await dbHelper.updateUser(currentUsername, updates);

      if (rowsUpdated > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        String updatedUsername = usernameController.text.isNotEmpty
            ? usernameController.text
            : currentUsername;

        userPreferences.updateuserName(updatedUsername);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
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
                  SizedBox(height: 16.h),

                  // Gender Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Gender:'),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: DropdownButtonFormField<String>(
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: 'Select Gender',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Image picker
                  Center(
                    child: InkWell(
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
                  ),
                  SizedBox(height: 32.h),

                  // Submit Button
                  Center(
                    child: RoundButton(
                      width: 200.w,
                      onPress: () =>
                          updateUserProfile(context), // Call the update method
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
