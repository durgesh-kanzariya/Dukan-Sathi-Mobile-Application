import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String id;
  final String shopName;
  final String address;
  final String ownerId;
  final String imageUrl;
  // --- NEW FIELDS ---
  final String description;
  final String contact;
  final String openTime; // e.g., "9:00 AM"
  final String closeTime; // e.g., "8:00 PM"

  Shop({
    required this.id,
    required this.shopName,
    required this.address,
    required this.ownerId,
    required this.imageUrl,
    // --- NEW FIELDS ---
    required this.description,
    required this.contact,
    required this.openTime,
    required this.closeTime,
  });

  factory Shop.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};
    return Shop(
      id: snap.id,
      shopName: data['shopName'] ?? '',
      address: data['address'] ?? '',
      ownerId: data['ownerId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      // --- NEW FIELDS ---
      description: data['description'] ?? '',
      contact: data['contact'] ?? '',
      openTime: data['openTime'] ?? '9:00 AM',
      closeTime: data['closeTime'] ?? '5:00 PM',
    );
  }

  // A toMap is needed for saving
  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'address': address,
      'ownerId': ownerId,
      'imageUrl': imageUrl,
      // --- NEW FIELDS ---
      'description': description,
      'contact': contact,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}