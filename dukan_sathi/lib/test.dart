





/*
1).GETTING STARTE PAGE CODE
 body: Container(
          color: const Color.fromARGB(255, 237, 235, 166),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset("assets/imgs/one.jpg"),
                ),
                Text("Your Grocery Ready With Us"),

                ElevatedButton(
                  onPressed: () {
                    print("");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Get Started  -> "),
                ),
              ],
            ),
          ),
        ),


2).LOGIN PAGE CODE
 body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Image.asset("assets/imgs/1.png", height: 150),

              Text("Hello", style: TextStyle(fontSize: 70)),
              Text(
                "Sign In To Your Account",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),

              Text(""),

              Text("Select Owner"),
              Padding(padding:EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0), child: Card(shadowColor: Colors.black, elevation: 5, child: TextField())),

              Text("Username"),
              Padding(padding:EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0), child: Card(shadowColor: Colors.black, elevation: 5, child: TextField())),

              Text("Password "),
              Padding(padding:EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0), child: Card(shadowColor: Colors.black, elevation: 5, child: TextField())),

              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Text("Forget Password?"),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Sign In",style: TextStyle(fontSize: 20),),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          print("");
                        },
                        child: Text("-->"),
                      ),
                    ],
                  ),
                ),
              ),

            Container(
              alignment: Alignment.center,
              child: Text("Don’t have an account? Create"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/imgs/2.jpg", height: 160),
              ],
            ),

            ],
          ),


3).
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
          body:Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Image.asset("assets/imgs/1.png", height: 150),

              Text("Hello", style: TextStyle(fontSize: 70)),
              Text(
                "Sign In To Your Account",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),

              Text(""),

              Text("Select Owner"),
              Padding(padding:EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0), child: Card(shadowColor: Colors.black, elevation: 5, child: TextField())),

              Text("Username"),
              Padding(padding:EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0), child: Card(shadowColor: Colors.black, elevation: 5, child: TextField())),

              Text("Password "),
              Padding(padding:EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0), child: Card(shadowColor: Colors.black, elevation: 5, child: TextField())),

              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Text("Forget Password?"),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Sign In",style: TextStyle(fontSize: 20),),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          print("");
                        },
                        child: Text("-->"),
                      ),
                    ],
                  ),
                ),
              ),

            Container(
              alignment: Alignment.center,
              child: Text("Don’t have an account? Create |"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/imgs/2.jpg", height: 160),
              ],
            ),

            ],
          ),
      ),
    );
  }
}
