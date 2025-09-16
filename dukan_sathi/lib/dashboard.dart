import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String password;

   Dashboard({super.key, required this.username, required this.password});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

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
                    title:  Text(
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
                        shape:  CircleBorder(),
                        padding:  EdgeInsets.all(10),
                      ),
                      onPressed: () {},
                      child:  Icon(Icons.person),
                    ),
                  ),
                ),

                Positioned(
                  top: 80,
                  left: 40,
                  right: 40,
                  child: Container(
                    padding:  EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "Hi, Kishan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(height: 8),
                         Text("Last Month - ₹50,000"),
                         SizedBox(height: 4),
                         Text("Current Month Spending"),
                         SizedBox(height: 4),
                         Text(
                          "₹1,00,00,000.00",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top:200,
                  left:300,
                  child:  ElevatedButton(
                            onPressed: () {
                              print("More button clicked");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF567751),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("More →"),
                          ),)
              ],
            ),

             SizedBox(height: 150), // space below stack
            Padding(
              padding:  EdgeInsets.all(8.0),
              child:  Text(
                "Order & Status",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Best Bakery :  • Ready for Pickup"),
                  Text("Raj General Store :  • Preparing"),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("View All in history →"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF567751),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding:  EdgeInsets.all(30.0),
              child: Container(
                height: 250,
                width: 300,
                // color: Colors.green.withOpacity(0.5),
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8DBE9B), // light green
                      Color(0xFFDCE5D8), // very light green/cream
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(15.0),
                      child: Text(
                        "QUICK ORDER LIST",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Center(
                      child: Card(
                        child: Padding(
                          padding:  EdgeInsets.all(10.0),
                          child: Text(
                            "Cookie - 250g",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Card(
                        child: Padding(
                          padding:  EdgeInsets.all(10.0),
                          child: Text(
                            "Cookie - 250g",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Card(
                        child: Padding(
                          padding:  EdgeInsets.all(10.0),
                          child: Text(
                            "Cookie - 250g",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text("Add To All Card →"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF567751),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: MyBottomNav(currentIndex: 0, onTap: (index) {}),
    );
  }
}
