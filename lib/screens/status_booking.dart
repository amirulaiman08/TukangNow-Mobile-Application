import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tukangnow1/model/booking.dart';
import 'package:tukangnow1/screens/chat_user.dart';
import 'package:tukangnow1/screens/feedback_screen.dart';

class statusBooking extends StatefulWidget {
  const statusBooking({Key? key}) : super(key: key);

  @override
  State<statusBooking> createState() => _statusBookingState();
}

class _statusBookingState extends State<statusBooking> {
  // Sample bookings list (replace this with your actual list)
  final List<Booking> bookings = [];
  String? workerId;

  @override
  void initState() {
    super.initState();
    fetchBookingsForUser();
  }

  Future<void> fetchBookingsForUser() async {
    try {
      // Get the currently logged-in user
      final User? users = FirebaseAuth.instance.currentUser;

      if (users != null) {
        // Get the bookings from Firestore where the userId matches the user's ID
        QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
            .collectionGroup('booking')
            .where('userid', isEqualTo: users.uid)
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
            bookId: bookId,
            bookingId: bookingId,
            workerId: bookingData['workerId'] ?? '',
            title: title,
            status: status,
            selectedTime: selectedTime,
            selectedDate: selectedDate,
            address: address,
            provider: provider,
            userid: userid,
          );

          bookings.add(booking);
        });

        // Update the UI with the fetched data
        setState(() {});
      }
    } catch (e) {
      // Handle any errors that may occur during fetching
      print('Error fetching bookings for user: $e');
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
       child: Expanded(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Order #${booking.bookingId}'),
                          subtitle: Text(
                              '\nService: ${booking.title}\n\nProvider: ${booking.provider}\n\nDate: ${booking.selectedDate}\n\nTime: ${booking.selectedTime}'),
                          trailing: SizedBox(
                            height: 250.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Status: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${booking.status}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to home page
                                  // Replace HomePage with the actual home page route or screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        userid: booking.userid,
                                          workerId: booking.workerId,
                                          provider: booking.provider,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Chat Worker'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to feedback page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                        userid: booking.userid,
                                          workerId: booking.workerId,
                                          title: booking.title,
                                          bookingId: booking.bookingId,
                                        // Pass any required parameters to the FeedbackPage if needed
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Feedback'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}





