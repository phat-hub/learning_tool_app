import '../ui/screen.dart';

class FavoritesService {
  Future<Set<String>> getUserFavorites() async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;

    final result = await pb.collection('favorites').getFullList(
          filter: "userId = '$userId'",
        );

    return result.map((e) => e.getStringValue('productId')).toSet();
  }

  Future<void> toggleFavorite(String productId) async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;

    final existing = await pb.collection('favorites').getFullList(
          filter: "userId = '$userId' && productId = '$productId'",
        );

    if (existing.isNotEmpty) {
      // đã thích → xoá
      await pb.collection('favorites').delete(existing.first.id);
    } else {
      // chưa thích → thêm
      await pb.collection('favorites').create(body: {
        'userId': userId,
        'productId': productId,
      });
    }
  }
}
