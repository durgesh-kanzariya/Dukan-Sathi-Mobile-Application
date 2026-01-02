# 🛍️ Dukan Sathi

**Dukan Sathi** (Shop Companion) is a Flutter-based mobile application that connects local shops with customers, enabling seamless ordering and in-store pickup experiences. The app provides separate interfaces for customers and shopkeepers, facilitating a complete local commerce ecosystem.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-6.0+-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 📱 Features

### For Customers
- 🏪 **Shop Discovery** - Browse and search local shops
- 🛒 **Shopping Cart** - Add products from multiple shops
- ⚡ **Quick Order List** - Save frequently ordered items for faster checkout
- 📦 **Order Tracking** - Real-time order status updates (Pending → Accepted → Preparing → Ready → Completed)
- 📱 **QR Code Pickup** - Scan QR codes at shops to collect orders
- 📊 **Spending Analytics** - Track monthly spending with detailed breakdowns
- 📜 **Order History** - View past orders and receipts
- 👤 **Profile Management** - Update personal information and preferences

### For Shopkeepers
- 🏬 **Shop Management** - Set up and manage shop details, hours, and contact information
- 📦 **Product Management** - Add, edit, and delete products with images and variants
- 📋 **Order Management** - Handle orders with categorized tabs:
  - **New Orders** - Accept or decline incoming orders
  - **Preparing** - Track orders being prepared
  - **Ready** - Manage orders ready for pickup
- 💰 **Sales Analytics** - Monitor monthly profits and sales performance
- 🔍 **QR Code Scanner** - Scan customer QR codes for order verification
- 📊 **Order History** - View complete order history and customer details

---

## 🛠️ Tech Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: GetX 4.6.6, Provider 6.1.5
- **Backend**: Firebase
  - Authentication (Firebase Auth)
  - Database (Cloud Firestore)
  - Storage (Firebase Storage)
  - App Check (Firebase App Check)
- **Image Handling**: Cloudinary Public API
- **QR Code**: `mobile_scanner` 5.1.1, `qr_flutter` 4.1.0
- **UI**: Material Design with Glassmorphism effects

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.8.1 or higher)
- **Dart SDK** (comes with Flutter)
- **Android Studio** / **Xcode** (for iOS development)
- **Firebase Account** (for backend services)
- **Cloudinary Account** (for image hosting)
- **Git** (for version control)

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Dukan-Sathi-Mobile-Application.git
cd Dukan-Sathi-Mobile-Application/dukan_sathi
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable the following services:
   - **Authentication** (Email/Password)
   - **Cloud Firestore**
   - **Firebase Storage**
   - **App Check**

#### Configure Android
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`

#### Configure iOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/GoogleService-Info.plist`

#### Generate Firebase Options
```bash
flutterfire configure
```

### 4. Cloudinary Configuration

1. Sign up at [Cloudinary](https://cloudinary.com/)
2. Get your **Cloud Name** from the dashboard
3. Update the following files with your Cloudinary Cloud Name:
   - `lib/shopkeeper/product/product_controller.dart` (line ~228)
   - `lib/shop_service.dart` (line ~289)
   - `lib/shopkeeper/misc/profile_screen.dart` (line ~570)

Replace `'YOUR_CLOUD_NAME'` with your actual Cloudinary cloud name.

### 5. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For a specific device
flutter devices
flutter run -d <device-id>
```

---

## 📁 Project Structure

```
lib/
├── auth_gate.dart              # Authentication routing
├── main.dart                   # App entry point
├── role_router.dart            # Role-based navigation
├── shop_model.dart             # Shop data model
├── shop_service.dart           # Shop service layer
│
├── controllers/
│   └── cart_controller.dart    # Shopping cart state management
│
├── customer/                   # Customer-facing features
│   ├── dashboard.dart
│   ├── discover_shop.dart
│   ├── cart_page.dart
│   ├── product_page.dart
│   ├── shop_productpage.dart
│   ├── quick_order.dart
│   ├── history.dart
│   ├── order_details.dart
│   ├── pickup_code.dart
│   ├── profile.dart
│   └── change_password.dart
│
├── shopkeeper/                 # Shopkeeper-facing features
│   ├── dashboard/
│   │   ├── dashboard_page.dart
│   │   └── shopkeeper_main_screen.dart
│   ├── product/
│   │   ├── products_screen.dart
│   │   ├── add_product_screen.dart
│   │   ├── edit_product_screen.dart
│   │   ├── product_details_screen.dart
│   │   ├── product_controller.dart
│   │   └── product_model.dart
│   ├── order/
│   │   ├── order_controller.dart
│   │   ├── order_model.dart
│   │   ├── new_order_details_screen.dart
│   │   ├── shopkeeper_order_details.dart
│   │   └── history_screen.dart
│   ├── misc/
│   │   ├── profile_screen.dart
│   │   ├── shop_details_screen.dart
│   │   ├── shop_setup_screen.dart
│   │   ├── pickup_code_screen.dart
│   │   └── change_password.dart
│   └── sells/
│       └── monthly_sells_screen.dart
│
├── models/
│   └── order_model.dart        # Order data model
│
└── widgets/
    ├── bottom_navbar.dart      # Shopkeeper bottom navigation
    └── custom_app_bar.dart     # Reusable app bar
```

---

## 🔧 Configuration

### Firebase App Check (Production)

Before deploying to production, update `lib/main.dart`:

```dart
// Change from DEBUG mode to production
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.playIntegrity, // For Android
  // For iOS, use: appleProvider: AppleProvider.appAttest
);
```

### Android Signing

Configure release signing in `android/app/build.gradle.kts`:

```kotlin
signingConfigs {
    create("release") {
        storeFile = file("path/to/keystore.jks")
        storePassword = "your-store-password"
        keyAlias = "your-key-alias"
        keyPassword = "your-key-password"
    }
}
```

---

## 🎨 Design Theme

- **Primary Color**: `#5A7D60` (Green)
- **Background Color**: `#F9F3E7` (Cream/Beige)
- **Design Style**: Material Design with Glassmorphism effects

---

## 📱 Screenshots

> Add screenshots of your app here
> 
> Example:
> - Customer Dashboard
> - Shop Discovery
> - Order Tracking
> - Shopkeeper Dashboard
> - Product Management

---

## 🔐 Security Rules

### Firestore Security Rules

Ensure your Firestore security rules are properly configured:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Shops collection
    match /shops/{shopId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        resource.data.ownerId == request.auth.uid;
    }
    
    // Products collection
    match /shops/{shopId}/products/{productId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/shops/$(shopId)).data.ownerId == request.auth.uid;
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null && 
        (resource.data.customerId == request.auth.uid || 
         resource.data.shopId in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.shops);
      allow create: if request.auth != null && 
        request.resource.data.customerId == request.auth.uid;
      allow update: if request.auth != null && 
        (resource.data.customerId == request.auth.uid || 
         resource.data.shopId in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.shops);
    }
  }
}
```

---

## 🧪 Testing

Run tests with:

```bash
flutter test
```

For integration testing:

```bash
flutter drive --target=test_driver/app.dart
```

---

## 🚢 Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release
```

Then archive and upload via Xcode.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and testers

---

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/Dukan-Sathi-Mobile-Application/issues) page
2. Create a new issue with detailed information
3. Contact: your.email@example.com

---

## 🔄 Version History

- **v0.1.0** (Current)
  - Initial release
  - Customer and Shopkeeper interfaces
  - Order management system
  - QR code pickup functionality
  - Basic analytics

---

**Made with ❤️ using Flutter**
