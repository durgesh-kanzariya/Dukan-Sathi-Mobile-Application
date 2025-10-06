import 'package:dukan_sathi/customer/discover_shop.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import '/bottom_nav.dart';
import 'package:get/get.dart';
import 'profile.dart';

class QuickOrder extends StatefulWidget {
  const QuickOrder({super.key});

  @override
  State<QuickOrder> createState() => _QuickOrderState();
}

class _QuickOrderState extends State<QuickOrder> {
  int i = 0;
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
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF567751),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
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
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        Get.to(Profile());
                      },
                      child: Icon(Icons.person),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Positioned(
                  top: 80,
                  left: 110,
                  child: Text(
                    "Quick Order List",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(DiscoverShop());
              },
              child: Text("Discover More Items"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFACBF92),
              ),
            ),

            SizedBox(height: 20),

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

                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.white.withOpacity(0.9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Cookie -  250"),

                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Card(
                                                  elevation: 5,
                                                  color: Colors.white,
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (i < 10) {
                                                              i++;
                                                            }
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .add_circle_rounded,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: 20,
                                                        child: Text("${i}"),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (i > 0 &&
                                                                i <= 10) {
                                                              i--;
                                                            }
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .remove_circle_rounded,
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  ListTile(
                    trailing: ElevatedButton(
                      onPressed: () {
                        Get.to(CardPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF567751),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Add All to Cart →"),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            SizedBox(height: 70),
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
