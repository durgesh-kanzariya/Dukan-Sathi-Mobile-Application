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
              height: 400,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(25, 5, 0, 4),
                    child: Text(
                      "Best Bakery",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
        
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/imgs/image.png",
                              height: 70,
                              width: 70,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Chocolate Cake",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "1.5 KG",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "50rupees",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
        
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      elevation: 5,
                                      color: const Color.fromARGB(
                                        255,
                                        212,
                                        206,
                                        206,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text("1"),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                  SizedBox(height: 20),
        
                  // this is second card
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/imgs/image.png",
                              height: 70,
                              width: 70,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Chocolate Cake",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "1.5 KG",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "50rupees",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
        
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      elevation: 5,
                                      color: const Color.fromARGB(
                                        255,
                                        212,
                                        206,
                                        206,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text("1"),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Place Seprate Order"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFACBF92),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 70,),
          ],

        ),

      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
