import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tukangnow1/screens/chat_user.dart';
import 'package:tukangnow1/screens/feedback_screen.dart';
import 'package:tukangnow1/screens/home_screen.dart';
import 'package:tukangnow1/screens/status_booking.dart';


class bookingSubmit extends StatefulWidget {
  final String userid;
  final String workerId;
  final String title;
  final String bookingId;
  final String provider;
  bookingSubmit({
    
    required this.userid,
    required this.workerId,
    required this.title,
    required this.bookingId,
    required this.provider,
    });

  @override
  _bookingSubmitState createState() => _bookingSubmitState();
}
class _bookingSubmitState extends State<bookingSubmit> {
  @override
  Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Colors.white,
    body:SafeArea(
    child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        width:double.infinity,
        child: Column(
          children: [
            Image.network('https://ouch-cdn2.icons8.com/sKA0OIxPkl0I0781QsiNkP28UmoSsO3JLgJhLIZcSGM/rs:fit:256:256/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMi8z/MjIzZGM5Ny1jNzU3/LTRiNmEtOTllYy02/MTA2NTEzN2MyOTku/c3Zn.png', width: 280, fit:BoxFit.cover,),
            SizedBox(height:50,),
            FadeInDown(
              child: Text("Booking Confirm",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              ),
              ),
              FadeInDown(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Your booking have been submitted. Check the detail for further information", textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade700),),
                   ),
                   ),
                   
                     SizedBox(height:25,),
                   FadeInDown(
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            workerId: widget.workerId,
                            userid: widget.userid,
                            provider:widget.provider,
                          ),
                        ),
                      );
                      },
                      color: Color.fromARGB(255, 93, 141, 187),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) 
                        ),
                        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        minWidth: double.infinity, 
                      child: Text("Chat Worker",
                      style: TextStyle(
                        color:Colors.white
                        ),
                      ),

                    ),
                    ),
                    SizedBox(height:25,),
                   FadeInDown(
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                      },
                      color: Color.fromARGB(255, 93, 141, 187),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) 
                        ),
                        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 20), 
                        minWidth: double.infinity,
                      child: Text("Home Page",
                      style: TextStyle(
                        color:Colors.white
                        ),
                      ),

                    ),
                    ),
                    SizedBox(height:25,),
                   FadeInDown(
                    child: MaterialButton(
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => statusBooking (),
                        ),
                      );
                      },
                      color: Color.fromARGB(255, 93, 141, 187),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) 
                        ),
                        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 20), 
                      minWidth: double.infinity,
                      child: Text("Booking Status",
                      style: TextStyle(
                        color:Colors.white
                        ),
                      ),

                    ),
                    )
          ],
          ),
       ),
      ),
  ),
  );

  }
}