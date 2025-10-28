
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.dart';
import 'bottom_nav.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none, // allow overflow
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          onPressed: () {
                            Get.to(
                              Dashboard(
                                username: "kishan",
                                password: "1234567777",
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Dukan Sathi",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          "MY CART",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            // this is for the next
            Container(
              height: 500,
              width: 340,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF567751), Color(0xFFF9F3E7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(
                                15,
                                10,
                                15,
                                0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Best Barber Shop",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("@BestBakery123"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(
                                10,
                                2,
                                10,
                                0,
                              ),
                              child: Divider(color: Colors.white, thickness: 2),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsetsGeometry.fromLTRB(
                                          0,
                                          10,
                                          0,
                                          10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.5),
                                                Colors.white.withOpacity(0.6),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsGeometry.fromLTRB(
                                                  4,
                                                  0,
                                                  4,
                                                  1,
                                                ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.fromLTRB(
                                                        0,
                                                        5,
                                                        0,
                                                        0,
                                                      ),
                                                  child: Image.asset(
                                                    "assets/imgs/image.png",
                                                    height: 80,
                                                    width: 80,
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Chocolate Cake",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "1.5 KG",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text("50 Rs"),
                                                    Row(
                                                      children: [
                                                        Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  10.0,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      if (i <
                                                                          10) {
                                                                        i++;
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .add_circle_rounded,
                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                  width: 30,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "$i",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      if (i <=
                                                                              10 &&
                                                                          i > 0) {
                                                                        i--;
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove_circle_rounded,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(Icons.delete),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: 3,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                  ),
                                  ListTile(
                                    trailing: Text(
                                      "Total: 150 Rs",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(30, 5, 30, 5),
                        child: Divider(color: Colors.white, thickness: 2),
                      ),
                      Text("Grand total: 150 Rs"),
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(30, 5, 30, 5),
                        child: Divider(color: Colors.white, thickness: 2),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(30, 5, 30, 5),
                        child: Text(
                          "Warning: This will create separate orders. You must pick up and pay at each shop location.",
                        ),
                      ),
                      Container(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                              Dashboard(username: "kishan", password: "123456"),
                            );
                          },
                          child: Text("Place Separate Order"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFACBF92),
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // SizedBox(height: 70),
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
