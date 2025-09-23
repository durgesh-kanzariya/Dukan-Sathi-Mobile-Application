import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'package:get/get.dart';
import 'order_details.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
                  title: const Text(
                    "Dukan Sathi",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () {},
                    child: const Icon(Icons.person),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Positioned(
                top: 80,
                left: 130,
                child: Text(
                  "HISTORY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          //this is body part
          Container(
            height: 400,
            width: 320,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF567751), // start color
                  Color(0xFFF9F3E7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // shadow color
                  blurRadius: 8, // softness of shadow
                  spreadRadius: 2, // how wide the shadow spreads
                  offset: Offset(0, 10), // position of shadow (x, y)
                ),
              ],
            ),

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(OrderDetails());
                    },
                    child: Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.6), // start color
                            Colors.white.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Order Id  : 812463187642"),
                          ),

                          Divider(
                            color: Colors.white, // line ka color
                            thickness: 2, // line ki motai
                            indent: 20, // left side se gap
                            endIndent: 20, // right side se gap
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                            child: Text("Shop Name  : Best Bakery"),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                            child: Text("Order Satatus : Ready For Pickup"),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                            child: Text("Total Prize : 100"),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                            child: Text("Date : 19/09/2025"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.6), // start color
                        Colors.white.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Order Id  : 812463187642"),
                      ),
                      Divider(
                        color: Colors.white, // line ka color
                        thickness: 2, // line ki motai
                        indent: 20, // left side se gap
                        endIndent: 20, // right side se gap
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                        child: Text("Shop Name  : Best Bakery"),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                        child: Text("Order Satatus : Ready For Pickup"),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                        child: Text("Total Prize : 100"),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(8, 0, 1, 0),
                        child: Text("Date : 19/09/2025"),
                      ),
                    ],
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
