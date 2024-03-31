import 'package:flutter/material.dart';
import 'package:tukangnow1/screens/login_screen.dart';
import 'package:tukangnow1/service%20provider/login_screen.dart';


class EntryScreenPage extends StatelessWidget {
  const EntryScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 227, 248),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          // logo
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              width: 2500, 
              height: 250,
            ),
          ),
          //title
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Welcome to TukangNow",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Text(
            "We fix it right, so you can sleep tight",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),

          const SizedBox(height: 25),

          //button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(18.0),
                      ),
                    ),
                    child: Text(
                      "User".toUpperCase(),
                      style: const TextStyle(color:Color.fromARGB(255, 93, 141, 187)),
                      
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              workersLoginScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Color.fromARGB(255, 93, 141, 187)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(18.0),
                      ),
                    ),
                    child: Text("Workers".toUpperCase()),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
