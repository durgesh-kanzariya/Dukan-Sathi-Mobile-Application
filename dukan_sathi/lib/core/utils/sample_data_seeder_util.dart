import 'package:cloud_firestore/cloud_firestore.dart';
import 'grocery_image_assets.dart';

/// Utility to automatically seed realistic test shops & products into Firestore.
class SampleDataSeederUtil {
  SampleDataSeederUtil._();

  static Future<void> seedSampleShopsAndProducts() async {
    final firestore = FirebaseFirestore.instance;

    // 1. Shop 1: Shree Ram Kirana Store
    final shop1Ref = firestore.collection('shops').doc('shop_shree_ram_kirana');
    await shop1Ref.set({
      'shopName': 'Shree Ram Kirana Store',
      'address': 'Station Road, Anand (0.8 km away)',
      'ownerId': 'owner_kirana_1',
      'imageUrl': GroceryImageAssets.kiranaStoreBanner,
      'description': 'Fresh daily groceries, grains, aata, pulses & organic spices.',
      'contact': '+91 98765 43210',
      'openTime': '08:00 AM',
      'closeTime': '09:00 PM',
      'isOpen': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final shop1Products = [
      {
        'id': 'prod_aata_5kg',
        'shopId': 'shop_shree_ram_kirana',
        'productName': 'Golden Whole Wheat (Aata)',
        'name': 'Golden Whole Wheat (Aata)',
        'description': '100% pure stone-ground whole wheat flour for soft rotis.',
        'category': 'Kirana & Grains',
        'imageUrl': GroceryImageAssets.wheatAtta,
        'variants': [
          {'name': '1 kg', 'variant': '1 kg', 'sellPrice': 52.0, 'buyPrice': 45.0, 'price': 52.0, 'stock': 40},
          {'name': '5 kg', 'variant': '5 kg', 'sellPrice': 245.0, 'buyPrice': 220.0, 'price': 245.0, 'stock': 25},
          {'name': '10 kg', 'variant': '10 kg', 'sellPrice': 480.0, 'buyPrice': 430.0, 'price': 480.0, 'stock': 15},
        ],
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'prod_rice_5kg',
        'shopId': 'shop_shree_ram_kirana',
        'productName': 'Premium Basmati Rice',
        'name': 'Premium Basmati Rice',
        'description': 'Aromatic long-grain aged basmati rice for biryani & pulao.',
        'category': 'Kirana & Grains',
        'imageUrl': GroceryImageAssets.basmatiRice,
        'variants': [
          {'name': '1 kg', 'variant': '1 kg', 'sellPrice': 95.0, 'buyPrice': 80.0, 'price': 95.0, 'stock': 30},
          {'name': '5 kg', 'variant': '5 kg', 'sellPrice': 450.0, 'buyPrice': 400.0, 'price': 450.0, 'stock': 20},
        ],
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var prod in shop1Products) {
      await shop1Ref.collection('products').doc(prod['id'] as String).set(prod);
    }

    // 2. Shop 2: Amul Dairy & Bakery Point
    final shop2Ref = firestore.collection('shops').doc('shop_amul_dairy_point');
    await shop2Ref.set({
      'shopName': 'Amul Dairy & Bakery Point',
      'address': 'Mayur Complex, Anand (1.2 km away)',
      'ownerId': 'owner_dairy_2',
      'imageUrl': GroceryImageAssets.dairyStoreBanner,
      'description': 'Fresh morning milk, paneer, dahi, butter & artisan breads.',
      'contact': '+91 98989 12345',
      'openTime': '06:00 AM',
      'closeTime': '10:00 PM',
      'isOpen': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final shop2Products = [
      {
        'id': 'prod_milk_1l',
        'shopId': 'shop_amul_dairy_point',
        'productName': 'Pure Organic Farm Milk',
        'name': 'Pure Organic Farm Milk',
        'description': 'Pasteurized fresh whole milk delivered every morning.',
        'category': 'Dairy & Milk',
        'imageUrl': GroceryImageAssets.organicMilk,
        'variants': [
          {'name': '500 ml', 'variant': '500 ml', 'sellPrice': 33.0, 'buyPrice': 28.0, 'price': 33.0, 'stock': 50},
          {'name': '1 Litre', 'variant': '1 Litre', 'sellPrice': 64.0, 'buyPrice': 56.0, 'price': 64.0, 'stock': 30},
        ],
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'prod_bread_400g',
        'shopId': 'shop_amul_dairy_point',
        'productName': 'Artisan Whole Wheat Bread',
        'name': 'Artisan Whole Wheat Bread',
        'description': 'Freshly baked 100% whole wheat bread loaf.',
        'category': 'Bakery & Toast',
        'imageUrl': GroceryImageAssets.artisanBread,
        'variants': [
          {'name': '400g', 'variant': '400g', 'sellPrice': 45.0, 'buyPrice': 38.0, 'price': 45.0, 'stock': 20},
        ],
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'prod_eggs_12',
        'shopId': 'shop_amul_dairy_point',
        'productName': 'Fresh Farm Eggs (12 pcs)',
        'name': 'Fresh Farm Eggs (12 pcs)',
        'description': 'High-protein fresh farm brown eggs.',
        'category': 'Dairy & Milk',
        'imageUrl': GroceryImageAssets.farmEggs,
        'variants': [
          {'name': '6 pcs', 'variant': '6 pcs', 'sellPrice': 44.0, 'buyPrice': 36.0, 'price': 44.0, 'stock': 30},
          {'name': '1 Dozen', 'variant': '1 Dozen', 'sellPrice': 84.0, 'buyPrice': 70.0, 'price': 84.0, 'stock': 25},
        ],
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var prod in shop2Products) {
      await shop2Ref.collection('products').doc(prod['id'] as String).set(prod);
    }
  }
}
