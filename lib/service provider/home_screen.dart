
import 'package:flutter/material.dart';
import 'package:tukangnow1/model/worker_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tukangnow1/service%20provider/customer_feedback.dart';
import 'package:tukangnow1/service%20provider/services_booking.dart';
import 'package:tukangnow1/service%20provider/profile_provider_screen.dart';


class HomeWorkers extends StatefulWidget {
  const HomeWorkers({Key? key}) : super(key: key);

  @override
  _HomeWorkersState createState() => _HomeWorkersState();
}
class _HomeWorkersState extends State<HomeWorkers> {
  User? user = FirebaseAuth.instance.currentUser;
  WorkerModel loggedInUser = WorkerModel();
  
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("workers")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = WorkerModel.fromMap(value.data());
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
                      navigateTo(context, ProfileProviderScreen());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: loggedInUser.provider_image != null
                    ? Image.network(
                        loggedInUser.provider_image!,
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
                        "Hi ${loggedInUser.name}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Experience the convenience of\n home services at your doorstep.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Positioned(
            bottom: MediaQuery.of(context).size.height * 1.5 / 7 + 100,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                GestureDetector(
                  onTap: () {
                    navigateTo(context, ServicesWorker());
                  },
                  child: Container(
                    height: 120,
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
                        Text(
                          'Services',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                 GestureDetector(
                  onTap: () {
                    // Navigate to customer feedback page
                    navigateTo(context, CustomerFeedbackScreen());
                  },
                  child: Container(
                    height: 120,
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
                        Icon(Icons.feedback, color: Colors.white),
                        Text(
                          'Customer Feedback',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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

 