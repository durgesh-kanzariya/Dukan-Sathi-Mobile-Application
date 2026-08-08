import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/quick_list_item_entity.dart';
import '../../domain/repositories/i_quick_list_repository.dart';
import '../datasources/quick_list_remote_data_source.dart';
import '../models/quick_list_item_model.dart';

class QuickListRepositoryImpl implements IQuickListRepository {
  final IQuickListRemoteDataSource _remoteDataSource;

  QuickListRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<QuickListItemEntity>> getQuickListStream() {
    return _remoteDataSource.getQuickListStream().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<void> addToQuickList(QuickListItemEntity item) async {
    final model = QuickListItemModel.fromEntity(item);
    await _remoteDataSource.addToQuickList(model);
  }

  @override
  Future<void> updateQuantity(String productId, int newQuantity) async {
    await _remoteDataSource.updateQuantity(productId, newQuantity);
  }

  @override
  Future<void> deleteItem(String productId) async {
    await _remoteDataSource.deleteItem(productId);
  }

  @override
  Future<void> clearList() async {
    await _remoteDataSource.clearList();
  }
}

// Riverpod Providers for Quick List Data & Repository
final quickListRemoteDataSourceProvider = Provider<IQuickListRemoteDataSource>((ref) {
  return QuickListRemoteDataSourceImpl();
});

final quickListRepositoryProvider = Provider<IQuickListRepository>((ref) {
  final dataSource = ref.watch(quickListRemoteDataSourceProvider);
  return QuickListRepositoryImpl(dataSource);
});
