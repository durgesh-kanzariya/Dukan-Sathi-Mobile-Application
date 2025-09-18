import 'package:flutter/material.dart';
import 'Login.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                Image.asset("assets/imgs/one.jpg"),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(100, 0, 60, 0),
                  child: Text(
                    "Your Grocery Ready With Us. ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(30, 100, 30, 0),
                  child: TextButton(
                    onPressed: () {
                      Get.off(Login());
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

                SizedBox(height: 20,),

                // Text("Hello Kishan"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
