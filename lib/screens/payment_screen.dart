import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
void main(){
  Stripe.publishableKey='pk_test_51NHV4DA29PxR0rMkvcJqgNPEcsJ4xHNTYHRQBzenY3flU7MHA9IzxoW0ARVAm1w2iYUhZsQjmfQu2fYCe3FffrOT00BrfKodA5';
  runApp(const PaymentPage());
}
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stripe Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body:Center(
        child: ElevatedButton(
          onPressed: () {
          makepayment("100", "RM");  
            
          },child: Text("Checkout"),
        ),
      ),
      );
    

  }


 Map<String,dynamic>? paymentIntentData;
  Future<void> makepayment(String amount,String currency)async{
    try{
      paymentIntentData=await createPaymentIntent(amount,currency);
      if(paymentIntentData!=null){
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: true,
                googlePay: PaymentSheetGooglePay(merchantCountryCode: 'MY'),
                merchantDisplayName: "Prospects",
                customerId: paymentIntentData!['customer'],
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                customerEphemeralKeySecret: paymentIntentData!['ephemeralkey']
            ));
        displayPaymentSheet();
      }
    }catch(e,s){
      print("EXCEPTION ===$e$s");

    }

  }

createPaymentIntent(String amount, String currency) async{
    try{
      Map<String,dynamic> body={
        'amount':calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card'
      };
      var response=await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: body,headers: {
        'Authorization':"sk_test_51NHV4DA29PxR0rMks2F91l3MXrgp4h2HE4B99Ez1CSmNbDy7EHFhuIsBRqqkUlqxhgaSVshKGfhSZXvCDaPF4mbN00uFwKpokQ",
            'Content-Type':'application/x-www-form-urlencoded'
          }
      );
      return jsonDecode(response.body);
    }catch(err){
      print("err charging user $err");
    }
  }
  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar("Payment info", "pay successful");
    } on Exception catch (e) {
      if (e is StripeException) {
        print("error from stripe $e");
      } else {
        print("Unforeseen error $e");
      }
    } catch (e) {
      print("exception===$e");
    }
  }

  calculateAmount(String amount) {
    final a=(int.parse(amount))*100;
    return a.toString();
  }
}