import 'package:flutter/material.dart';
import 'package:tukangnow1/screens/appliance_screen.dart';
import 'package:tukangnow1/screens/fixture_screen.dart';
import 'package:tukangnow1/screens/painting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tukangnow1/model/user_model.dart';
import 'package:tukangnow1/screens/payment_screen.dart';
import 'package:tukangnow1/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tukangnow1/screens/status_booking.dart';
import 'package:tukangnow1/screens/submitted_booking.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
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
      setState(() {});
    });
  }

  void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ClipPath(
                    clipper: ClippingClass(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff40dedf), Color(0xff0fb2ea)],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to profile page
                      navigateTo(context, ProfileScreen());
                    },
                    child: ClipRRect(
                     borderRadius: BorderRadius.circular(100),
                      child: loggedInUser.user_image != null
                    ? Image.network(
                        loggedInUser.user_image!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/user.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hi ${loggedInUser.firstName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Experience the convenience of\nhome services at your doorstep.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 2 / 7 + 100,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            navigateTo(context, FixtureInstallationPage());
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 85, 162, 224),
                                  Color.fromARGB(255, 89, 159, 194)
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.build, color: Colors.white),
                                Text('Fixture Installation',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: GestureDetector(
                            onTap: () {
                              navigateTo(context, PaintingPage());
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 85, 162, 224),
                                    Color.fromARGB(255, 89, 159, 194)
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.brush, color: Colors.white),
                                  Text('Painting',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                bottom: MediaQuery.of(context).size.height * 1 / 7 + 100,
                left: 20,
                right: 20,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Expanded(
                child: GestureDetector(
                onTap: () {
                  navigateTo(context, SmallApplianceRepairPage());
                },
                child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 85, 162, 224),
                              Color.fromARGB(255, 89, 159, 194)
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.settings, color: Colors.white),
                            Text('Small Appliance Repair',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                           ],
                  ),
                ),
                
              ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: AspectRatio(
                aspectRatio: 1.5,

              child: GestureDetector(
                onTap: () {
                  navigateTo(context, statusBooking ());
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 85, 162, 224),
                        Color.fromARGB(255, 89, 159, 194)
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.assignment, color: Colors.white),
                      Text(
                        'Booking Status',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
               ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ),
          ],
        ),
      ),
              ],
    ),
  );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.6);
    var controlPoint = Offset(size.width - (size.width / 2), size.height - 500);
    var endPoint = Offset(size.width, size.height * 0.6);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
