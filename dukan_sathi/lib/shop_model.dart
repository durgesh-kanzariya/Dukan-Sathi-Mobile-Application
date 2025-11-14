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

  // Add this copyWith method
  Shop copyWith({
    String? id,
    String? shopName,
    String? address,
    String? ownerId,
    String? imageUrl,
    String? description,
    String? contact,
    String? openTime,
    String? closeTime,
  }) {
    return Shop(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      ownerId: ownerId ?? this.ownerId,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      contact: contact ?? this.contact,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

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
