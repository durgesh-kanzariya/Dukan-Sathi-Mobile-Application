import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ye likhan to he jaruri ,to avoid overflow of page
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Color(0xFFF9F3E7),
        child: Center(
          child: SingleChildScrollView(
            // isko sirf or sirf column mehi rakho for overflow avoidance
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                Image.asset("assets/images/logo.png"),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(100, 0, 60, 0),
                  child: Text(
                    "Your Grocery Ready With Us.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(30, 100, 30, 0),
                  child: TextButton(
                    onPressed: () {
                      print("Button CLiked");
                      // Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login(),   ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Get Started ", style: TextStyle(fontSize: 15)),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Text("Hello Kishan"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
