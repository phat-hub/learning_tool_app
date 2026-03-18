import '../ui/screen.dart';

class CartService {
  Future<List<CartItem>> fetchCartItems() async {
    final List<CartItem> cartItems = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final cartModels =
          await pb.collection('cart').getFullList(filter: "userId='${userId}'");
      for (final cartModel in cartModels) {
        // Truy xuất productId từ cartModel
        final productId =
            cartModel.data['productId']; // Sử dụng data để lấy các trường

        // Tạo CartItem từ dữ liệu của cartModel
        final cartItem = CartItem.fromJson(cartModel.toJson());

        // Cập nhật CartItem với productId
        cartItem.productId = productId;

        // Thêm CartItem vào danh sách
        cartItems.add(cartItem);
      }
      return cartItems;
    } catch (error) {
      print("Lỗi lấy list cart: '${error}'");
      return cartItems;
    }
  }

  Future<CartItem?> addCartItem(CartItem cartItem) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final cartModel = await pb.collection('cart').create(
        body: {
          ...cartItem.toJson(),
          'userId': userId,
        },
      );
      return cartItem.copyWith(
        id: cartModel.id,
      );
    } catch (error) {
      print("Lỗi thêm sản phẩm vào giỏ hàng: '${error}'");
      return null;
    }
  }

  Future<CartItem?> updateCartItem(CartItem cartItem,
      {bool check = false}) async {
    try {
      final pb = await getPocketbaseInstance();
      if (!check) {
        await pb.collection('cart').update(
          cartItem.id!,
          body: {
            'quantity': cartItem.quantity,
          },
        );
        return cartItem.copyWith(quantity: cartItem.quantity);
      } else {
        await pb.collection('cart').update(
          cartItem.id!,
          body: {
            'select': cartItem.select,
          },
        );
        return cartItem.copyWith(select: cartItem.select);
      }
    } catch (error) {
      print("Lỗi update cartItem: '${error}'");
      return null;
    }
  }

  Future<bool> deleteCartItem(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      // Xóa CartItem từ collection 'cart' dựa trên id
      await pb.collection('cart').delete(id);
      return true; // Trả về true khi xóa thành công
    } catch (error) {
      print("Lỗi khi xóa CartItem: '${error}'");
      return false; // Trả về false khi gặp lỗi
    }
  }
}
