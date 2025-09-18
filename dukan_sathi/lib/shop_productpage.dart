import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:get/get.dart';

import 'bottom_nav.dart';
import 'monthly_spending_lage.dart';
import 'product_page.dart';

class ShopProductpage extends StatefulWidget {
  const ShopProductpage({super.key});

  @override
  State<ShopProductpage> createState() => _ShopProductpageState();
}

class _ShopProductpageState extends State<ShopProductpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            Stack(
              clipBehavior: Clip.none, // allow overflow
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration:  BoxDecoration(
                    color: Color(0xFF567751),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: ListTile(
                    leading:IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back),color: Colors.white,),
                    title:  Text(
                      "Dukan Sathi",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                ),


                Positioned(
                  top: 100,
                  left: 40,
                  right: 40,
                  child: Container(
                    padding:  EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.6), // 60% opacity
                        Colors.white.withOpacity(0.1), // 10% opacity
                      ],
                    ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset:  Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                          "Best Bakery",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.heart_broken)),
                        ),

                         SizedBox(height: 8),
                         Text("@best bakery"),
                         SizedBox(height: 4),
                         Text("Buiness Our : 9AM - 4PM "),
                         SizedBox(height: 4),
                          Text("Address : Rajkot Mavdi Chokdi "),
                         SizedBox(height: 4),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 100,),
            Container(
              height:400,
              width: 320,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF567751), // dark green
                    Color(0xFFF9F3E7), // cream white
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // visible shadow
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20), // optional rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Product List",style: TextStyle(color: Colors.white,fontSize: 20),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for the cards items
                        Card(
                          elevation: 10,
                          shadowColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Image.asset('assets/imgs/image.png',height: 100,width: 110,),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("Chocolate Cake"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("doler50"),
                              ),
                            ],
                          ),
                        )
                      ,
                       Card(
                          elevation: 10,
                          shadowColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Image.asset('assets/imgs/image.png',height: 100,width: 110,),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("Chocolate Cake"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("doler50"),
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 10,
                          shadowColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Image.asset('assets/imgs/image.png',height: 100,width: 110,),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("Chocolate Cake"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("doler50"),
                              ),
                            ],
                          ),
                        ),


                       Card(
                          elevation: 10,
                          shadowColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Image.asset('assets/imgs/image.png',height: 100,width: 110,),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("Chocolate Cake"),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("doler50"),
                              ),
                            ],
                          ),
                        )
        
                      ],
                    ),
                  ),
                SizedBox(height: 20,)
                ],
              ),
            )



        ],
      ),


      bottomNavigationBar: BottomNav(),
    );
  }
}