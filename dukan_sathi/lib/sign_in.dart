import 'package:flutter/material.dart';
import 'login_page.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   foregroundColor: Colors.black,
      // ),

      //ye likhan to he jaruri ,to avoid overflow of page
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Color(0xFFF9F3E7),
        height: double.infinity,
        child: SingleChildScrollView(
          // isko sirf or sirf column mehi rakho for overflow avoidance
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/imgs/1.png",
                height: 110,
                width: double.infinity,
              ),
              Text("Hello", style: TextStyle(fontSize: 70)),
              Text(
                "Sign In To Your Account ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),

              Text(""),

              // DropdownButton(items: ['Shop Owner','User'], onChanged:(){print("");}),
              Text("Select Owner"),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: TextField(),
                ),
              ),

              Text("Username"),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: TextField(),
                ),
              ),

              Text("Password "),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: TextField(obscureText: true),
                ),
              ),

              Text("Email"),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: TextField(),
                ),
              ),
              Text("Mobile "),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(30, 0, 30, 0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: TextField(),
                ),
              ),

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
                      Text("Create", style: TextStyle(fontSize: 20)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          print("");
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //this is for sign in page redirect link make later
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF9F3E7),
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                ),
                child: Text("Are You Have Account ,Then Login "),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Image.asset("assets/imgs/2.jpg", height: 200)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
