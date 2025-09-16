import 'package:flutter/material.dart';

class MonthlySpendingLage extends StatefulWidget {
  const MonthlySpendingLage({super.key});

  @override
  State<MonthlySpendingLage> createState() => _MonthlySpendingLageState();
}




class _MonthlySpendingLageState extends State<MonthlySpendingLage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
            SizedBox(height: 20),
            // this is for the listview builder wite here
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text('July'),
                      trailing: Text('100000'),
                    ),
                  );
                },
                ),
              ),
            ),
        ],
      ),
    );
  }
}