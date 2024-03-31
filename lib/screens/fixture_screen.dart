import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tukangnow1/screens/booking_electric_screen.dart';
import 'package:tukangnow1/screens/booking_plumbing_screen.dart';

class FixtureInstallationPage extends StatefulWidget {
 
  const FixtureInstallationPage({ Key? key }) : super(key: key);
  
    @override
  _FixtureInstallationPageState createState() => _FixtureInstallationPageState();
}

class _FixtureInstallationPageState extends State<FixtureInstallationPage> {
  int selectedTool = 0;

  List<dynamic> tools = [
    {
      'image': 'https://img.icons8.com/?size=512&id=s4uFaNCyzfxY&format=png',
      'selected_image': 'https://img.icons8.com/?size=512&id=s4uFaNCyzfxY&format=png',
      'name': 'Electrical',
      'description': 'Where there is electricity, there is possibility.',
    },
    {
      'image': 'https://img.icons8.com/?size=512&id=95AJLxFeHGJ1&format=png',
      'selected_image': 'https://img.icons8.com/?size=512&id=95AJLxFeHGJ1&format=png',
      'name': 'Plumbing',
      'description': 'Water is life, plumbing keeps it flowing.',
    },
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            FadeInDown(
              from: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select a Fixture Installation Type", style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold
                  ),),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.close)
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            FadeInDown(
              from: 50,
              child: Text("What do you want to choose?", style: TextStyle(
                color: Colors.blueGrey.shade400,
                fontSize: 20
              ),),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTool = index;
                      });
                    },
                    child: FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: AnimatedContainer(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: EdgeInsets.only(bottom: 20),
                        duration: Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedTool == index ? Color.fromARGB(255, 93, 141, 187) : Colors.white.withOpacity(0),
                            width: 2
                          ),
                          boxShadow: [
                            selectedTool == index ?
                            BoxShadow(
                              color: Colors.blue.shade100,
                              offset: Offset(0, 3),
                              blurRadius: 10
                            ) : BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(0, 3),
                              blurRadius: 10
                            )
                          ] 
                        ),
                        child: Row(
                          children: [
                            selectedTool == index ?
                            Image.network(tools[index]['selected_image'], width: 50,) :
                            Image.network(tools[index]['image'], width: 50,),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tools[index]['name'], style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  Text(tools[index]['description'], style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),)
                                ],
                              ),
                            ),
                            Icon(Icons.check_circle, color: selectedTool == index ? Color.fromARGB(255, 93, 141, 187) : Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
               
            ),
            
            FadeInUp(
              child: MaterialButton(
                height: 50,
                minWidth: double.infinity,
                color: Color.fromARGB(255, 93, 141, 187),
                onPressed: () {
                  if (selectedTool == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingElectricPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPlumbingPage(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Proceed to Booking',
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
            
          ],
        ),
      ),
    );
  }
}