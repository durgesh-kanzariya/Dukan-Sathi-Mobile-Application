/// System-wide constants for Dukan Sathi.
class AppConstants {
  AppConstants._();

  static const String appName = 'Dukan Sathi';
  static const String appVersion = '1.0.0';

  // Firestore Collection Names
  static const String usersCollection = 'users';
  static const String shopsCollection = 'shops';
  static const String productsSubCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String quickListSubCollection = 'quickPurchaseList';

  // Cloudinary Configurations
  static const String cloudinaryCloudName = 'dizbwzb7i';
  static const String cloudinaryUploadPreset = 'dukan_sathi_preset';
  static const String productImagesFolder = 'product_images';
  static const String profileImagesFolder = 'profile_images';
  static const String shopImagesFolder = 'shop_images';

  // Order Status Identifiers
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusPreparing = 'preparing';
  static const String statusReadyForPickup = 'ready_for_pickup';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleShopkeeper = 'shopkeeper';
}
