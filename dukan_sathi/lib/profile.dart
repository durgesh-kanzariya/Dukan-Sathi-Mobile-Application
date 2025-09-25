import 'package:dukan_sathi/Login.dart';
import 'package:dukan_sathi/bottom_nav.dart';
import 'package:dukan_sathi/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.dart';
import 'Login.dart';
import 'sign_up.dart';
import 'change_password.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none, // allow overflow
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF567751),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          Get.to(
                            Dashboard(username: "kishan", password: "12345677"),
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Dukan Sathi",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 80,
                left: 150,
                child: Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    leading: Text("User Name "),
                    title: Text(" : "),
                    trailing: Text("@xyzabcd"),
                  ),
                  ListTile(
                    leading: Text("Email  "),
                    title: Text(" : "),
                    trailing: Text("xyz@gmail.com"),
                  ),
                  ListTile(
                    leading: Text("Phone No.  "),
                    title: Text(" : "),
                    trailing: Text("9054831231"),
                  ),
                ],
              ),
            ),
          ),

           ListTile(
                    trailing: ElevatedButton(onPressed: (){

                    }, child: Text("Save Changes → "),
                     style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF567751),
                          foregroundColor: Colors.white,
                        ),
                    ),
                  ),



           Container(
            width: 300,
             child: ElevatedButton(
                    onPressed: () {
                      Get.to(ChangePassword());
                    },
                    child: Text("Change password"),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFACBF92),
                    ),
                  ),
           ),



           Container(
            width: 300,
             child: ElevatedButton(
                    onPressed: () {
                      Get.to(History());
                    },
                    child: Text("View order history"),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFACBF92),
                    ),
                  ),
           ),



           Container(
            width: 300,
             child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(Login());
                    },
                    child: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFACBF92),
                    ),
                  ),
           ),


         
        ],
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
