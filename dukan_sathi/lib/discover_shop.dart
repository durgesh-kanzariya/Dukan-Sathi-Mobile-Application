import 'package:flutter/material.dart';

class DiscoverShop extends StatefulWidget {
  const DiscoverShop({super.key});

  @override
  State<DiscoverShop> createState() => _DiscoverShopState();
}




class _DiscoverShopState extends State<DiscoverShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none, // allow overflow
            children: [
              // Top green container
              Container(
                height: 180,
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

              // Search box aligned at bottom center
              Positioned(
                left: 20,
                right: 20,
                top: 100, // pull it down below the container
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for shop',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5), // adjust for overlap

          // List of shops
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue,
                    child: const ListTile(
                      leading: Icon(Icons.person_2_rounded),
                      title: Text('Bakry Shop'),
                      subtitle: Text('Best Bakry'),
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
