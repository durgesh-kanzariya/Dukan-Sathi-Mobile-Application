import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:get/get.dart';
import 'bottom_nav.dart';

class MonthlySpendingLage extends StatefulWidget {
  const MonthlySpendingLage({super.key});

  @override
  State<MonthlySpendingLage> createState() => _MonthlySpendingLageState();
}

class _MonthlySpendingLageState extends State<MonthlySpendingLage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Get.to( Dashboard(username: "kishan",password: "12345677",));
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
                top: 100,
                left: 100,
                child: Center(
                  child: Text(
                    "Monthly Spending",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 5),


          // this is for the listview builder wite here
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    shadowColor: Colors.white,
                    color: Colors.white,
                    child: ListTile(
                      title: Text('July'),
                      trailing: Text('100000'),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
