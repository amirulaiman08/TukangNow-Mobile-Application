import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:tukangnow1/model/user_model.dart';
import 'package:tukangnow1/model/utils.dart';
import 'package:tukangnow1/screens/submitted_booking.dart';

class InvoiceScreen extends StatefulWidget {
  final String title;
  final String price;
  final String bookingId;
  final String selectedDate;
  final String selectedTime;
  final String address;
  final String provider;
  final String userid;
  final String workerId;

  InvoiceScreen({
    required this.title,
    required this.price,
    required this.bookingId,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.provider,
    required this.userid,
    required this.workerId,
    });

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}
class _InvoiceScreenState extends State<InvoiceScreen> {

  Stream<DocumentSnapshot<Map<String, dynamic>>> _fetchWorkerData() {
    return FirebaseFirestore.instance
        .collection('worker')
        .doc(widget.workerId)
        .snapshots();
  }
 Stream<DocumentSnapshot<Map<String, dynamic>>> _fetchBookingData() {
  return FirebaseFirestore.instance
      .collection('worker')
      .doc(widget.workerId)
      .collection('booking')
      .doc(widget.bookingId) // Assuming each booking has a unique document ID
      .snapshots();
}
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    
    return Container(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.fromLTRB(21*fem, 31*fem, 16*fem, 20*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 126*fem, 25*fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigates to the previous page
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 0.3*fem, 102*fem, 0*fem),
                      width: 20*fem,
                      height: 15.3*fem,
                      child: Image.asset(
                        'assets/images/vector.png',
                        width: 20*fem,
                        height: 15.3*fem,
                      ),
                    ),
                  ),
                  Text(
                    '     Details',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Roboto',
                      fontSize: 24*ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.1725*ffem/fem,
                      color: Color(0xff292929),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(103.5*fem, 0*fem, 107.5*fem, 18*fem),
              width: double.infinity,
              height: 184*fem,
              child: Stack(
                children: [
                  Positioned(
                    left: 9.5*fem,
                    top: 0*fem,
                    child: Align(
                      child: SizedBox(
                        width: 146*fem,
                        height: 171*fem,
                        child: Image.asset(
                          'assets/images/delivery-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    
                    left: 0*fem,
                    top: 165*fem,
                    child: Align(
                        child: Text(
                          'Provider: ${widget.provider}',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff03045e),
                          ),
                        ),
                      
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5*fem, 105*fem),
              width: 372*fem,
              height: 367*fem,
              child: Stack(
                children: [
                  Positioned(
                    left: 1*fem,
                    top: 0*fem,
                    child: Align(
                      child: SizedBox(
                        width: 371*fem,
                        height: 367*fem,
                        child: Container(
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(10*fem),
                            border: Border.all(color: Color(0xffe9ebf0)),
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20*fem,
                    top: 18*fem,
                    child: Align(
                      child: SizedBox(
                        width: 150*fem,
                        height: 19*fem,
                        child: RichText(
                          text: TextSpan(
                            style: SafeGoogleFont (
                              'Roboto',
                              fontSize: 13*ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.1725*ffem/fem,
                              color: Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: widget.bookingId != null ? 'Order ${widget.bookingId}' : 'Order ID Unavailable',
                                style: SafeGoogleFont (
                                  'Roboto',
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1725*ffem/fem,
                                  color: Color(0xff292929),
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // homeserviceGdc (4:108)
                    left: 20*fem,
                    top: 63*fem,
                    child: Align(
                      child: SizedBox(
                        width: 100*fem,
                        height: 19*fem,
                        child: Text(
                          'Services',
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff03045e),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // exteriorpaintingk2z (4:109)
                    left: 20*fem,
                    top: 91*fem,
                    child: Align(
                      child: SizedBox(
                        width: 95*fem,
                        height: 16*fem,
                        child: Text(
                          '${widget.title}',
                          
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 13*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff292929),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    
                    left: 305*fem,
                    top: 94*fem,
                    child: Align(
                      child: SizedBox(
                        width: 56*fem,
                        height: 16*fem,
                        child: Text(
                          '${widget.price}',
                          
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 13*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff3a86ff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // scheduledateandtime7ne (4:111)
                    left: 20*fem,
                    top: 132*fem,
                    child: Align(
                      child: SizedBox(
                        width: 174*fem,
                        height: 19*fem,
                        child: Text(
                          'Schedule Date and Time',
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff03045e),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // bookingtimeRHY (4:112)
                    left: 23*fem,
                    top: 170*fem,
                    child: Align(
                      child: SizedBox(
                        width: 74*fem,
                        height: 15*fem,
                        child: Text(
                          'Booking Time',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 12*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff82858a),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // bookingdateXLa (4:113)
                    left: 228*fem,
                    top: 168*fem,
                    child: Align(
                      child: SizedBox(
                        width: 72*fem,
                        height: 15*fem,
                        child: Text(
                          'Booking Date',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 12*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff82858a),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // timeccv (4:125)
                    left: 62*fem,
                    top: 196.5*fem,
                    child: Container(
                      width: 293*fem,
                      height: 22*fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // amLJ2 (4:126)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 119*fem, 0*fem),
                            child: Text(
                              '${widget.selectedTime}',
                              
                              style: SafeGoogleFont (
                                'Roboto',
                                fontSize: 18*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.1725*ffem/fem,
                                color: Color(0xff3a86ff),
                              ),
                            ),
                          ),
                          Padding(
                          padding: EdgeInsets.only(
                                left: 30.0), // Adjust the value as needed
                            child: Text(
                              '${widget.selectedDate}',
                              style: SafeGoogleFont(
                                'Roboto',
                                fontSize: 18 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.1725 * ffem / fem,
                                color: Color(0xff3a86ff),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // deliveryaddressNEi (4:143)
                    left: 20*fem,
                    top: 245*fem,
                    child: Align(
                      child: SizedBox(
                        width: 121*fem,
                        height: 19*fem,
                        child: Text(
                          'Delivery Address',
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff03045e),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // blok3pangsapuridanaumasjalanpl (4:146)
                    left: 50*fem,
                    top: 282*fem,
                    child: Align(
                      child: SizedBox(
                        width: 273*fem,
                        height: 29*fem,
                        child: Text(
                          '${widget.address}',
                          //"${loggedInUser.address}",
                          style: SafeGoogleFont (
                            'Roboto',
                            fontSize: 12*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.1725*ffem/fem,
                            color: Color(0xff82858a),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // date164E (4:156)
                    left: 215*fem,
                    top: 182*fem,
                    child: Align(
                      child: SizedBox(
                        width: 54*fem,
                        height: 54*fem,
                        child: Image.asset(
                          'assets/images/date-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // maps11bWn (4:157)
                    left: 0*fem,
                    top: 260*fem,
                    child: Align(
                      child: SizedBox(
                        width: 65*fem,
                        height: 65*fem,
                        child: Image.asset(
                          'assets/images/maps-1-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // time11vJA (4:158)
                    left: 8*fem,
                    top: 179*fem,
                    child: Align(
                      child: SizedBox(
                        width: 60*fem,
                        height: 60*fem,
                        child: Image.asset(
                          'assets/images/time-1-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogrouphx672rz (BLozsDZj94u2gQK5hRhx67)
              margin: EdgeInsets.fromLTRB(210*fem, 0*fem, 5*fem, 39*fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // totalyGS (4:150)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 25*fem, 0*fem),
                    child: Text(
                      'Total:',
                      style: SafeGoogleFont (
                        'Roboto',
                        fontSize: 20*ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.1725*ffem/fem,
                        color: Color(0xff03045e),
                      ),
                    ),
                  ),
                  Text(
                    '${widget.price}',
                    textAlign: TextAlign.right,
                    style: SafeGoogleFont (
                      'Roboto',
                      fontSize: 20*ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.1725*ffem/fem,
                      color: Color(0xff3a86ff),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
            onTap: () {
            // Navigate to the PaymentConfirmationScreen when "Pay" is pressed.
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => bookingSubmit(
              workerId: widget.workerId,
              userid: widget.userid,
              title: widget.title,
              bookingId:widget.bookingId,
              provider:widget.provider,
              
             ),
            ),
           );
          },
            child: Container(
              margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
              width: 376*fem,
              height: 54*fem,
              decoration: BoxDecoration (
                color: Color.fromARGB(255, 93, 141, 187),
                borderRadius: BorderRadius.circular(8*fem),
              ),
              child: Center(
                child: Text(
                  'Pay ',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont (
                    'Roboto',
                    fontSize: 16*ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.1725*ffem/fem,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ), 
          ],
        ),
      ),
          );
         }
}
       
    