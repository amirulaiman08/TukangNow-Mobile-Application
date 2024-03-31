import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tukangnow1/model/user_model.dart';
import 'package:tukangnow1/screens/login_screen.dart';
import 'package:tukangnow1/widget/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tukangnow1/constants/button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
 
  final Logger _logger = Logger();
  String? user_image;
  /*===============  IMAGE PICKER ===============*/
  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      return File(imageFile.path);
    }
    return null;
  }

  /*===============  UPLOAD IMAGE ===============*/
  Future<String?> uploadImage(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String fileName = 'images/${user.uid}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        return null;
      }
    } catch (e) {
      _logger;
      return null;
    }
  }
   User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        user_image = loggedInUser.user_image;
      });
    });
  }
  Future<void> updateProfileImage() async {
  File? pickedImageFile = await pickImage();
  if (pickedImageFile != null) {
    String? imageUrl = await uploadImage(pickedImageFile);
    if (imageUrl != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'user_image': imageUrl});

        // Set the profileImageUrl to the new URL
        setState(() {
          user_image = imageUrl;
        });

        displayMessage('Profile image updated successfully!');
      }
    } else {
      displayMessage("Failed to upload profile image.");
    }
  } else {
    displayMessage("No image was selected.");
  }
}
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                CustomBackButton(pageHeader: 'User Profile'),
                SizedBox(height: 30),
                CircleAvatar(
                  radius: 60,
                  foregroundColor: Colors.blue,
                  backgroundImage: user_image != null
                      ? NetworkImage(
                          user_image!) // Use the profile image URL if available
                       :null// Use default image if not available
                ),
                SizedBox(height: 20),
                Text(
                  "${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 30),
                Info(
                  infoText: 'Name: ',
                  infoData: "${loggedInUser.firstName} ${loggedInUser.secondName}",
                ),
                Info(
                  infoText: 'Email: ',
                  infoData: "${loggedInUser.email}",
                ),
                Info(
                  infoText: 'Address: ',
                  infoData: "${loggedInUser.address}",
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
                MyButton(
                  onTap:
                      updateProfileImage, // Call updateProfileImage method when tapped
                  text: 'Upload Image',
                ),
          Spacer(),
          Padding(
          padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 93, 141, 187)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                minimumSize:
                    MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                logout(context);
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  final String infoText;
  final String infoData;

  Info({required this.infoText, required this.infoData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              infoText,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            
            Text(
              infoData,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: infoText == 'Address: ' ? 14 : 18,
              ),
            ),
            
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  
}