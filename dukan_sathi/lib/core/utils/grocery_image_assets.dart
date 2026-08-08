/// High-resolution, context-accurate appetizing food & retail shop asset URLs.
class GroceryImageAssets {
  GroceryImageAssets._();

  // Product Photography
  static const String wheatAtta = 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800&auto=format&fit=crop&q=80';
  static const String organicMilk = 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800&auto=format&fit=crop&q=80';
  static const String basmatiRice = 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=800&auto=format&fit=crop&q=80';
  static const String artisanBread = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&auto=format&fit=crop&q=80';
  static const String farmEggs = 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=800&auto=format&fit=crop&q=80';
  static const String freshVeggies = 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&auto=format&fit=crop&q=80';
  static const String freshFruits = 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=800&auto=format&fit=crop&q=80';

  // Store Banners
  static const String kiranaStoreBanner = 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=800&auto=format&fit=crop&q=80';
  static const String dairyStoreBanner = 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?w=800&auto=format&fit=crop&q=80';
  static const String bakeryStoreBanner = 'https://images.unsplash.com/photo-1517433670267-08bbd4be890f?w=800&auto=format&fit=crop&q=80';
  static const String organicStoreBanner = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=80';

  static String getFallbackForProduct(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wheat') || lower.contains('atta') || lower.contains('flour')) {
      return wheatAtta;
    } else if (lower.contains('milk') || lower.contains('dahi') || lower.contains('paneer')) {
      return organicMilk;
    } else if (lower.contains('rice') || lower.contains('chawal')) {
      return basmatiRice;
    } else if (lower.contains('bread') || lower.contains('toast') || lower.contains('bun')) {
      return artisanBread;
    } else if (lower.contains('egg')) {
      return farmEggs;
    } else if (lower.contains('veg') || lower.contains('fruit') || lower.contains('apple')) {
      return freshVeggies;
    }
    return wheatAtta;
  }

  static String getFallbackForShop(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('dairy') || lower.contains('milk')) {
      return dairyStoreBanner;
    } else if (lower.contains('bakery') || lower.contains('bread')) {
      return bakeryStoreBanner;
    } else if (lower.contains('organic') || lower.contains('farm')) {
      return organicStoreBanner;
    }
    return kiranaStoreBanner;
  }
}
