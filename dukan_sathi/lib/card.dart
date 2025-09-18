// import 'package:flutter/material.dart';

// class CardPage extends StatefulWidget {
//   const CardPage({super.key});

//   @override
//   State<CardPage> createState() => _CardPageState();
// }

// class _CardPageState extends State<CardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  Column(
//       children: [
//         Stack(
//             clipBehavior: Clip.none, // allow overflow
//             children: [
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF567751),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     ListTile(
//                   leading: IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.arrow_back),
//                     color: Colors.white,
//                   ),
//                   title: const Text(
//                     "Dukan Sathi",
//                     style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5,),
//                 Center(child: Text("MY CART",style: TextStyle(color: Colors.white,fontSize: ),)),
//                   ],
//                 ),
//               ),

//             ],
//           ),

//           // this is for the next
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//               colors: [
//                 Color(0xFF567751), // Start color
//                 Color(0xFFF9F3E7), // End color
//               ],
//               begin: Alignment.topLeft,  // adjust as needed
//               end: Alignment.bottomRight,
//             ),
//             ),
//           ),
//       ],
//     ),
//     );
//   }
// }
