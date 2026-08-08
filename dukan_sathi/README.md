# 🛍️ Dukan Sathi (Shop Companion)

**Dukan Sathi** is a modern, enterprise-grade Flutter mobile application built with Clean Architecture and Riverpod. It bridges local neighborhood retail shops with nearby customers, offering pre-ordering, real-time inventory management, financial profit analytics, and secure in-store QR code & 4-digit PIN verification.

![Flutter](https://img.shields.io/badge/Flutter-3.29.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.7.0-0175C2?logo=dart)
![Riverpod](https://img.shields.io/badge/State-Flutter--Riverpod-42A5F5?logo=riverpod)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?logo=firebase)

---

## 🚀 Recent Key Enhancements & Security Upgrades

- 🔒 **Secure Handover Verification**: Eliminates order fulfillment bypass. Shopkeepers must scan the customer's QR code or enter the secret 4-digit PIN to trigger atomic Firestore handover completion.
- ⚡ **Atomic Read-Before-Write Transactions**: Guaranteed real-time product variant inventory stock deduction upon completed order pickup.
- 📷 **Direct Camera & Gallery Product Photo Capture**: Integrated native camera picker with instant Cloudinary CDN media uploads.
- 📊 **Cost Price, Selling Price & Real-Time Net Profit Analytics**: Track variant cost price (`buyPrice`), selling price (`sellPrice`), unit profit margins (`+X%`), Today's Net Profit, and Average Order Value (AOV).
- 🏪 **Single-Document Shop Profile Upsert**: Prevents duplicate shop registration by maintaining a single deterministic merchant document linked to the owner's Firebase UID.
- 🎨 **Unified Animated Pill Navigation Shell**: Ultra-sleek, responsive bottom navigation shell shared across both Customer and Shopkeeper profiles.

---

## 📱 Features Overview

### 🏪 For Customers
- **Local Shop Discovery**: Browse nearby stores with live search and filter options.
- **Product Catalog & Variant Selector**: View detailed product variants with dynamic pricing.
- **Multi-Store Shopping Cart**: Organize products into store-specific groupings for checkout.
- **Quick Order List**: Re-order frequent essentials instantly.
- **Order Pickup Pass**: Display secret 4-digit PIN and dynamic QR code for counter verification.
- **Order History & Status Tracking**: Live updates across order lifecycle (`Pending` → `Accepted` → `Preparing` → `Ready for Pickup` → `Completed`).

### 🏬 For Merchants / Shopkeepers
- **Live Order Dashboard**: Compact top banner with daily revenue, profit metrics, and instant action filters.
- **Inventory & Variant Manager**: Manage stock levels, low-stock warnings, cost price, selling price, and direct camera photo uploads.
- **Dedicated Financial Analytics**: Deep dive into daily revenue, net profit, average order value, order status progress, and inventory stock health.
- **QR Code & PIN Verification**: Integrated CameraX scanner and manual 4-digit PIN validator to prevent unauthorized order collection.
- **Store Profile Management**: One-click shop details editor and secure account logout.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: Flutter 3.29+ / Dart 3.7+
- **Architecture**: Domain-Driven Feature-First Clean Architecture (`data`, `domain`, `presentation`)
- **State Management**: `flutter_riverpod` (Notifier & Stream Providers)
- **Backend & Database**: 
  - Firebase Authentication
  - Cloud Firestore (Real-time streams & atomic transactions)
- **Camera & QR Scanning**: `mobile_scanner` 5.1+, `image_picker` 1.1+
- **Cloud Media Hosting**: Cloudinary REST API
- **Typography & Theme**: Google Fonts (`Outfit` & `Inter`), Custom `AppColors` palette with glassmorphic cards and subtle micro-animations.

---

## 📁 Repository Structure

```
lib/
├── app/
│   ├── routes/                # GoRouter / AppRouter configuration
│   └── theme/                 # AppColors, typography, global theme tokens
├── core/
│   ├── services/              # Image upload (Cloudinary) & helper utilities
│   ├── utils/                 # Constants, formatters, and validators
│   └── widgets/               # Reusable buttons, cards, dialogs, snackbars
├── features/
│   ├── auth/                  # Firebase Auth, Login, Signup & Role Router
│   ├── customer/
│   │   ├── cart/              # Cart management & checkout
│   │   ├── discovery/         # Shop discovery & product screens
│   │   ├── orders/            # Customer order tracking & QR pickup code
│   │   └── quick_list/        # Re-order quick list
│   └── shopkeeper/
│       ├── data/              # Shopkeeper remote datasource & repositories
│       ├── domain/            # Order & Inventory entities & use cases
│       ├── presentation/
│       │   ├── providers/     # Shopkeeper Riverpod providers & analytics metrics
│       │   └── screens/       # Dashboard, Analytics, Inventory, Scanner & Setup
│       └── shop_mgmt/         # Shop registration & profile setup
├── main.dart                  # App initialization & Firebase configuration
└── role_router.dart           # Role-based shell navigation dispatcher
```

---

## 🚀 Getting Started

### 1. Prerequisites
- **Flutter SDK**: `3.29.0` or higher
- **Android Studio / VS Code** with Flutter extensions
- **Android SDK 21+** / **iOS 13.0+**

### 2. Installation
```bash
git clone https://github.com/durgesh-kanzariya/Dukan-Sathi-Mobile-Application.git
cd Dukan-Sathi-Mobile-Application/dukan_sathi
flutter pub get
```

### 3. Execution
```bash
# Run on connected Android / iOS device
flutter run
```

---

## 👨‍💻 Author

**Durgesh Kanzariya**
- **GitHub**: [@durgesh-kanzariya](https://github.com/durgesh-kanzariya)
- **Email**: durgesh.j.kanzariya@gmail.com

---

**Made with ❤️ using Flutter & Firebase**
