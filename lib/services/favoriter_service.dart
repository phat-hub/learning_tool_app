import 'package:pocketbase/pocketbase.dart';

class FavoriteService {
  final PocketBase pb;

  FavoriteService(this.pb);

  /// Lấy danh sách favorite theo user
  Future<List<RecordModel>> fetchFavorites(String userId) async {
    return await pb.collection('favorites').getFullList(
          filter: 'user = "$userId"',
        );
  }

  /// Thêm favorite
  Future<RecordModel> addFavorite(String userId, String productId) async {
    return await pb.collection('favorites').create(body: {
      'user': userId,
      'product': productId,
    });
  }

  /// Xóa favorite
  Future<void> deleteFavorite(String favoriteId) async {
    await pb.collection('favorites').delete(favoriteId);
  }
}
