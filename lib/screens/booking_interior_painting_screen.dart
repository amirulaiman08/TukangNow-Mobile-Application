import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tukangnow1/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:tukangnow1/screens/invoice_screen.dart';
import 'package:tukangnow1/screens/payment_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingInteriorPaintingPage extends StatefulWidget {
  const BookingInteriorPaintingPage({Key? key}) : super(key: key);

@override
  _BookingInteriorPaintingPageState createState() => _BookingInteriorPaintingPageState();
}

class _BookingInteriorPaintingPageState extends State<BookingInteriorPaintingPage> {
   String? provider;
  String? currentUserId;
  late String orderId;
  List<Map<String, dynamic>> _myJson = [];
  DateTime selectedPickupDate = DateTime.now();
  TimeOfDay selectedDropOffTime = TimeOfDay.now();
  final TextEditingController addressEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }
  
  _selectPickupDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedPickupDate, 
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.input,
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Select pickup date',
      cancelText: 'Not now',
      confirmText: 'Done',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Pickup date',
      fieldHintText: 'Month/Date/Year',
    );
    if (picked != null && picked != selectedPickupDate)
      setState(() {
        selectedPickupDate = picked;
      });
  }

  _selectDropOffTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedDropOffTime, // This should be a TimeOfDay instance
  );
  if (picked != null && picked != selectedDropOffTime)
    setState(() {
      selectedDropOffTime = picked;
    });
}
@override
void initState() {
  super.initState();
  orderId = generateRandomOrderId();// Set the initial value to null
  _fetchWorkerData();
  _fetchUserData();
  _getCurrentUser();
  
}
String generateRandomOrderId() {
    final random = Random();
    final orderId = random.nextInt(100000).toString().padLeft(5, '0');
    return orderId;
  }

Future<void> _fetchWorkerData() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('workers').get();

    setState(() {
      _myJson = querySnapshot.docs.map((doc) {
        return {
          'wid': doc.id, // Include the document ID as 'id'
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  } catch (error) {
    print("Error fetching worker data: $error");
  }
}
void _getCurrentUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    setState(() {
      currentUserId = user.uid;
    });
  }
}
Future<void> _fetchUserData() async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      addressEditingController.text = userSnapshot['address'] ?? '';
    });
  } catch (error) {
    print("Error fetching user data: $error");
  }
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset("assets/images/interior.jpg"),
          ),
          buttonArrow(context),
          scroll(),
        ],
      ),
     bottomNavigationBar: FadeInUp(
        child: MaterialButton(
          height: 50,
          minWidth: double.infinity,
          color: Color.fromARGB(255, 93, 141, 187),
          onPressed: () {
            final String title = "Interior Painting";
              final String price = "RM 55.00";
              final String status = "Received";
              final String bookingId= orderId;
              final String selectedDate =
                  selectedPickupDate.toLocal().toString().split(' ')[0];
              final String selectedTime =
                  selectedDropOffTime.format(context).toString();
              final String address = addressEditingController.text;
              final selectedWorker = _myJson.firstWhere((worker) => worker['name'] == provider);
              final String workerId = selectedWorker['wid']; // Get the selected worker's ID

               _firestore.collection('workers').doc(workerId).collection('booking').add({
                'title': title,
                'price': price,
                'selectedDate': selectedDate,
                'selectedTime': selectedTime,
                'address': address,
                'provider':provider,
                'userid': currentUserId,
                'workerId': workerId,
                'status':status,
                'bookingId':bookingId,
              }).then((value) {
                print("Data added to Firestore");
                // You can show a success message or navigate to a new screen here.
              }).catchError((error) {
                print("Failed to add data to Firestore: $error");
                // Handle the error, show an error message, or retry.
              });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InvoiceScreen(
                title: title,
                price: price,
                bookingId:bookingId,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                address: address,
                provider:provider!,
                userid: currentUserId!,
                workerId: workerId,
              )),
            );
          },
          child: Text(
            'Confirm Booking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
    ),
        ),
      ),
    ),
  );
}

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Interior Painting",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                  "RM 55.00",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: SecondaryText),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            
                            child:DropdownButton(
                              isExpanded: true,
                              hint: Text('Select Service Provider'),
                              value:provider,
                              onChanged:(newValue){
                               setState(() {
                               provider = newValue!;
                                // Find the worker with the selected name and get its ID
                                final selectedWorker = _myJson.firstWhere(
                                    (worker) => worker['name'] == newValue);
                                final selectedWorkerId = selectedWorker['wid'];
                                // Store the worker ID in a variable or you can directly include it in Firestore data
                                // For example, you can add 'workerId' key in the Firestore data and set its value to selectedWorkerId
                              });

                              },
                              items: _myJson.map((worker) {
                               return DropdownMenuItem(
                                value:worker['name'].toString(),
                               child:Row(
                                children: [
                                  Image.network(
                                  worker['provider_image'],
                                  width:20),
                                  Container(
                                  margin: EdgeInsets.only(left:10),
                                  child: Text(worker['name']),

                                )
                                ],
                                ) 
                               );

                              }).toList(),
                              ),
                            ),
                          )
                        
                      ),
                          
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Interior painting is the art of storytelling, where each room becomes a chapter, and the colors and textures become the characters that bring the story to life.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: SecondaryText),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // to give equal space around the buttons
                    children: [
                     Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8.0), // Added margin to give space between buttons
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${selectedPickupDate.toLocal()}"
                                    .split(' ')[0],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectPickupDate(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Select the Date',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(
                              left:
                                  8.0), // Added margin to give space between buttons
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${selectedDropOffTime.format(context)}", // Changed to display time
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectDropOffTime(
                                      context); // Changed function to select time
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Select the Time',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  
                  SizedBox(height: 10.0,),
                  
                     Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        child: Row(
                          children:[
                           Icon(Icons.location_on),
                          SizedBox(width: 10), 
                          Expanded(
                            child: Text(
                              addressEditingController.text,
                              style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            ),
                          ),
                          ],
                          
                        ),
                      ),
                ],
              ),
            ),
          );
        });
  }
 
}