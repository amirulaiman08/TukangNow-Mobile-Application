import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tukangnow1/model/booking.dart';

import 'package:tukangnow1/service%20provider/chat_worker.dart';
import 'package:tukangnow1/service%20provider/customer_feedback.dart';

class ServicesWorker extends StatefulWidget {
  const ServicesWorker({Key? key}) : super(key: key);

  @override
  State<ServicesWorker> createState() => _ServicesWorkerState();
}

class _ServicesWorkerState extends State<ServicesWorker> {
  // Sample bookings list (replace this with your actual list)
  final List<Booking> bookings = [];
  String? workerId;

  @override
  void initState() {
    super.initState();
    fetchWorkerAndBookings();
  }

  Future<void> fetchWorkerAndBookings() async {
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
        QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
            .collection('workers')
            .doc(user.uid)
            .collection('booking')
            .get();

        // Clear the existing bookings list
        bookings.clear();

        // Add each booking to the list
        bookingsSnapshot.docs.forEach((bookingDoc) {
          Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
          String bookId = bookingDoc.id;
          String bookingId = bookingData['bookingId'] ?? '';
          String title = bookingData['title'] ?? '';
          String status = bookingData['status'] ?? '';
          String address = bookingData['address'] ?? '';
          String selectedDate = bookingData['selectedDate'] ?? '';
          String selectedTime = bookingData['selectedTime'] ?? '';
          String provider = bookingData['provider'] ?? '';
          String userid = bookingData['userid'] ?? '';

          Booking booking = Booking(
            bookId:bookId,
            bookingId: bookingId,
            workerId: workerId!, // Pass the workerId to Booking
            title: title,
            status: status,
            selectedTime:selectedTime,
            selectedDate:selectedDate,
            address:address,
            provider: provider,
            userid: userid,

          );

          bookings.add(booking);
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
          'Booking Status',
          style: TextStyle(
          color: Colors.black),),
        backgroundColor: Color.fromARGB(255, 93, 141, 187),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            Booking booking = bookings[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text('Order #${booking.bookingId}'),
                  subtitle: Text('\nService: ${booking.title}\n\nDate: ${booking.selectedDate}\n\nTime: ${booking.selectedTime}\n\nAddress: ${booking.address}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                    DropdownButton<String>(
                    value: booking.status,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Received',
                        child: Text('Received'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'On The Way',
                        child: Text('On The Way'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Processing',
                        child: Text('Processing'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Completed',
                        child: Text('Completed'),
                      ),
                      
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        booking.status = newValue!;
                        // Update the status in Firestore for the specific booking
                        updateBookingStatus(booking.bookId, newValue);
                      });
                    },
                  ),
                 IconButton(
                        icon: Icon(Icons.chat), // Chat button icon
                        onPressed: () {
                          // When the chat button is pressed, navigate to the ChatWorker page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                              userid: booking.userid,
                              workerId: booking.workerId,
                              provider: booking.provider,
                              bookingId: booking.bookingId,
                                
                               ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to update the booking status in Firestore
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      // Get the currently logged-in user
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the status in Firestore for the specific booking
        await FirebaseFirestore.instance
            .collection('workers')
            .doc(user.uid)
            .collection('booking')
            .doc(bookingId)
            .update({'status': newStatus});
      }
    } catch (e) {
      // Handle any errors that may occur during updating
      print('Error updating booking status: $e');
    }
  }
}
