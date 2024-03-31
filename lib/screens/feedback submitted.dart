import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tukangnow1/screens/feedback_screen.dart';
import 'package:tukangnow1/screens/home_screen.dart';
import 'package:tukangnow1/screens/status_booking.dart';


class feedbackSubmit extends StatefulWidget {

  @override
  _feedbackSubmitState createState() => _feedbackSubmitState();
}
class _feedbackSubmitState extends State<feedbackSubmit> {
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
            Image.network('https://ouch-cdn2.icons8.com/7Wcwad4hjnDNcCBnO2v5nfmJhUkRiDeBPUDdtusqZSo/rs:fit:256:299/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvODQ5/LzJlNmEyN2ZiLTU3/ZjAtNGZlMi05MDk0/LWIzMjQxYjIyN2Q0/MC5zdmc.png', width: 280, fit:BoxFit.cover,),
            SizedBox(height:50,),
            FadeInDown(
              child: Text("Feedback Submitted",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              ),
              ),
              FadeInDown(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Your feedback have been submitted. We appreciate your input and will use it to improve our services", textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade700),),
                   ),
                   ),
                   SizedBox(height:50,),
                   FadeInDown(
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
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
                      child: Text("Home Page",
                      style: TextStyle(
                        color:Colors.white
                        ),
                      ),

                    ),
                    ),
          ],
          ),
       ),
      ),
  ),
  );

  }
}