import 'package:dukan_sathi/pickup_code.dart';
import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'package:get/get.dart';
import 'history.dart';
import 'order_details.dart';

class PickupCode extends StatefulWidget {
  const PickupCode({super.key});

  @override
  State<PickupCode> createState() => _PickupCodeState();
}

class _PickupCodeState extends State<PickupCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF567751),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        Get.to(OrderDetails());
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    title: const Text(
                      "Dukan Sathi",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        
                SizedBox(height: 10),
        
                Positioned(
                  top: 80,
                  left: 100,
                  child: Text(
                    "ORDER DETAILS",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
        
            SizedBox(height: 50),
        
           Center(
             child: Card(
              color: Color(0xFFACBF92),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Image.asset( "assets/imgs/qr_img.png",height: 200,width: 200),

                    SizedBox(height: 15,),
                    Text("5867-0980"),
                  ],
                ),
              ),
             ),
           )
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(),
    );
 
  }
}