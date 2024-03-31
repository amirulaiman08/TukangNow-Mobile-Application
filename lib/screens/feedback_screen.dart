import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tukangnow1/screens/feedback%20submitted.dart';
class FeedbackPage extends StatefulWidget {
   final String userid;
  final String workerId;
  final String title;
  final String bookingId;
  FeedbackPage({
    
    required this.userid,
    required this.workerId,
    required this.title,
    required this.bookingId,
    });

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}
class _FeedbackPageState extends State<FeedbackPage>{
   
  String? workerImageUrl;
  final Color firstColor = Color.fromARGB(255, 93, 141, 187);
  final Color secondColor = Color.fromARGB(255, 32, 77, 134);
  final msgController=TextEditingController();
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Method to fetch the worker's image URL from Firestore.
  Future<void> _fetchWorkerImage() async {
    try {
      // Get the worker document using the workerId.
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('workers')
              .doc(widget.workerId)
              .get();

      // Access the 'image' field in the worker document to get the image URL.
      String imageUrl = snapshot.data()?['provider_image'];

      // Update the workerImageUrl state variable to trigger a rebuild with the new image URL.
      setState(() {
        workerImageUrl = imageUrl;
      });
    } catch (e) {
      // Handle any errors that might occur during the fetching process.
      print('Error fetching worker image: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    // Fetch the worker's image URL when the widget is initialized.
    _fetchWorkerImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(

            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  width: double.infinity,
                  height: 310,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        firstColor,
                        secondColor
                      ] 
                      ),
                      boxShadow: const[
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 12,
                          offset:Offset(0,6)
                        )
                      ]
                  ),
                ),
                ),
                const Positioned(
                  top: 50,
                  left: 25,
                  child: Text('Feedback',style: TextStyle( color: Colors.white,fontSize: 25),
                  )
                ),
              const Positioned(
                  top: 90,
                  left: 25,
                  child: Text('Give Your Feedback To Our Workers',
                  style: TextStyle( color: Colors.white,
                  fontSize: 16),
                  )
                ),
               
            Positioned(
            top: 130,
            left: 25,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/white.jpg'),
              child: workerImageUrl != null
                  ? Opacity(
                      opacity: 0.8,
                      child: Image.network(
                        workerImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : null,
            ),
          ),
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text ('Tell us How We Can Improve',
            style: TextStyle(color:Colors.black, fontSize: 18.0),
            ),
            ),
        
          Row(
            children: [
              Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              height: 150,
              decoration: BoxDecoration(
                color:Colors.grey.shade200,
                
               ),
               child: TextField(
                controller: msgController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15
                   ),
                maxLines: 10,
                decoration: const InputDecoration(   
                  hintText: ' Write Your Feedback Here..'
                ),
               ),
            ),
            ),
          ],
          ),
          
           SizedBox(height: 200,),
            Center( 
            child:Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(20),
                color:Color.fromARGB(255, 93, 141, 187),
              ),
              child:MaterialButton(
                onPressed: (){
                  final String feedback = msgController.text;
                  _firestore.collection('workers').doc(widget.workerId).collection('feedback').add({
                'title': widget.title,
                'userid': widget.userid,
                'workerId': widget.workerId,
                'feedback':feedback,
                'bookingId':widget.bookingId,
              }).then((value) {
                print("Data added to Firestore");
                // You can show a success message or navigate to a new screen here.
              }).catchError((error) {
                print("Failed to add data to Firestore: $error");
                // Handle the error, show an error message, or retry.
              });
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => feedbackSubmit(),
              ),
            );
                },
                child: const Text('Send Now', style:TextStyle(
                  color: Colors.white,
                  fontFamily: 'Fonts/Oswald-Bold.ttf',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
                ),
            ),
            ),

        ],
      ),
        ]
       )
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip (Size size){
    var path = Path();
    path.lineTo(0, size.height -70);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-300);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return false;
  }
}