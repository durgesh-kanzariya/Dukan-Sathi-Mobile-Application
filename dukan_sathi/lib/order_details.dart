import 'package:dukan_sathi/pickup_code.dart';
import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'package:get/get.dart';
import 'history.dart';
import 'pickup_code.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      Get.to(History());
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
      
          SizedBox(height: 20),
      
          Column(
            // mainAxisAlignment: MainAxisAlignment.c,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Order Id :", style: TextStyle(fontSize: 17)),
      
                  Text("812463187642", style: TextStyle(fontSize: 17)),
                ],
              ),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Order Satatus :", style: TextStyle(fontSize: 17)),
      
                  Text("Ready To PickUp", style: TextStyle(fontSize: 17)),
                ],
              ),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Shop Name :", style: TextStyle(fontSize: 17)),
      
                  Text("Best Bakery", style: TextStyle(fontSize: 17)),
                ],
              ),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Date :", style: TextStyle(fontSize: 17)),
      
                  Text("31/8/25", style: TextStyle(fontSize: 17)),
                ],
              ),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Address :", style: TextStyle(fontSize: 17)),
                  Container(
                    width: 100,
                    child: Text(
                      "Mavdi chowk, nana mauva main road, Rajkot",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
      
              SizedBox(height: 20),
      
              Container(
                height: 160,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: ((context, index) {
                      return Card(
                        elevation: 10,
                        child: ListTile(
                          leading: Image.asset(
                            "assets/imgs/image.png",
                            height: 100,
                            width: 100,
                          ),
                          title: Text("Choklate Cake"),
                          subtitle: Text("1.5 KG"),
                          trailing: Column(
                            children: [
                              Text("50"),
                              Card(
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(
                                    30,
                                    5,
                                    30,
                                    5,
                                  ),
                                  child: Text("2"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
      
              SizedBox(height: 10),
              ListTile(
                trailing: Text(
                  "Total prize  : 75 rupees",
                  style: TextStyle(fontSize: 17),
                ),
              ),
      
              SizedBox(height: 10),
      
              ElevatedButton(
                onPressed: () {
                  Get.to(PickupCode());
                },
                child: Text("Show To Pick Up Code"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFACBF92),
                ),
              ),
      
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
