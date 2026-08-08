import '../entities/shop_entity.dart';
import '../entities/product_entity.dart';

/// Repository interface for customer shop & product discovery.
abstract class IShopRepository {
  Stream<List<ShopEntity>> getShopsStream();
  Stream<List<ProductEntity>> getShopProductsStream(String shopId);
  Future<ProductEntity?> getProductDetails(String shopId, String productId);
  Future<ShopEntity?> getShopById(String shopId);
}
