import 'package:dukan_sathi/Login.dart';
import 'package:dukan_sathi/bottom_nav.dart';
import 'package:dukan_sathi/history.dart';
import 'package:dukan_sathi/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.dart';
import 'Login.dart';
import 'sign_up.dart';
import 'change_password.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
                            Profile(),
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
                    "Change Password",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    
                    labelText: 'Old Password',
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),




                 TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    
                    labelText: 'New Password',
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),



                 TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    
                    labelText: 'Comfirm New Password',
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  
                ),
                SizedBox(height: 10,),

                 ListTile(
                    trailing: ElevatedButton(onPressed: (){

                    }, child: Text("Save Changes → "),
                     style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF567751),
                          foregroundColor: Colors.white,
                        ),
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}