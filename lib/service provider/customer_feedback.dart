
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tukangnow1/model/feedback.dart';

class CustomerFeedbackScreen extends StatefulWidget {
  const CustomerFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<CustomerFeedbackScreen> createState() => _CustomerFeedbackScreenState();
}

class _CustomerFeedbackScreenState extends State<CustomerFeedbackScreen> {
  // Sample bookings list (replace this with your actual list)
  final List<Feed> feedbacks = [];
  String? workerId;

  @override
  void initState() {
    super.initState();
    fetchWorkerAndFeedback();
  }

  Future<void> fetchWorkerAndFeedback() async {
  try {
    // Get the currently logged-in user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the worker's document from Firestore based on the user's ID
      DocumentSnapshot workerSnapshot =
          await FirebaseFirestore.instance.collection('workers').doc(user.uid).get();

      if (workerSnapshot.exists) {
        // Get the worker's data and workerId
        Map<String, dynamic> workerData = workerSnapshot.data() as Map<String, dynamic>;
        workerId = workerSnapshot.id;

        // Get the bookings subcollection of the worker
        QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance
            .collection('workers')
            .doc(user.uid)
            .collection('feedback')
            .get();

        // Clear the existing bookings list
        feedbacks.clear();

        // Add each booking to the list
        feedbackSnapshot.docs.forEach((feedbackDoc) {
          Map<String, dynamic> feedbackData = feedbackDoc.data() as Map<String, dynamic>;
          String feedId = feedbackDoc.id;
          String bookingId = feedbackData['bookingId'] ?? '';
          String title = feedbackData['title'] ?? '';
          String feedback= feedbackData['feedback'] ?? '';
          

          Feed feedbackss = Feed(
            feedId:feedId,
            bookingId: bookingId,
            workerId: workerId!, // Pass the workerId to Booking
            title: title,
            feedback:feedback,
        

          );

          feedbacks.add(feedbackss);
        });

        // Update the UI with the fetched data
        setState(() {});
      }
    }
  } catch (e) {
    // Handle any errors that may occur during fetching
    print('Error fetching worker and bookings: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black, // Set the color of the back button icon
        onPressed: () {
          Navigator.pop(context); // Navigate to the previous page
        },
      ),
        centerTitle: true,
        title: Text(
          'Customer Feedback',
          style: TextStyle(
          color: Colors.black),),
        backgroundColor: Color.fromARGB(255, 93, 141, 187),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            Feed feedbackss = feedbacks[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text('Order #${feedbackss.bookingId}'),
                  subtitle: Text('\nService: ${feedbackss.title}\n\nFeedback: ${feedbackss.feedback}'),
                  
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
