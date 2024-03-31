import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String bookId;
  String bookingId;
  String workerId; // Add workerId field
  String title;
  String status;
  String selectedDate;
  String selectedTime;
  String address;
  String provider;
  String userid;

  Booking({
    required this.bookingId,
    required this.workerId,
    required this.title,
    required this.status,
    required this.bookId,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.provider,
    required this.userid,
  });
}