import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String feedId;
  String bookingId;
  String workerId; // Add workerId field
  String title;
  String feedback;

  Feed({
    required this.bookingId,
    required this.workerId,
    required this.title,
    required this.feedback,
    required this.feedId,
    
  });
}