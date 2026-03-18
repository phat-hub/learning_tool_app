import 'package:pocketbase/pocketbase.dart';

import 'package:http/http.dart' as http;

import '../ui/screen.dart';

class AuthService {
  void Function(User? user)? onAuthChange;

  AuthService({this.onAuthChange}) {
    if (onAuthChange != null) {
      getPocketbaseInstance().then((pb) {
        pb.authStore.onChange.listen((event) {
          onAuthChange!(event.record == null
              ? null
              : User.fromJson(event.record!.toJson()));
        });
      });
    }
  }
  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      final authRecord =
          await pb.collection('users').authWithPassword(email, password);
      return User.fromJson(authRecord.record.toJson());
    } catch (error) {
      if (error is ClientException &&
          error.toString().contains('authenticate')) {
        throw 'Thông tin đăng nhập không chính xác!';
      }
      throw Exception('An error occurred');
    }
  }

  Future<User> signup(String name, String email, String phoneNumber,
      String password, String address,
      {String role = 'user'}) async {
    final pb = await getPocketbaseInstance();
    // Kiểm tra xem số điện thoại đã tồn tại chưa
    final isPhoneAvailable = await pb.collection('users').getFullList(
          filter: 'phoneNumber="$phoneNumber"',
        );
    if (!isPhoneAvailable.isEmpty) {
      throw 'Số điện thoại này đã tồn tại, vui lòng sử dụng số điện thoại khác';
    }
    try {
      final defaultAvatarUrl =
          'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg';

      // Tải ảnh mặc định lên PocketBase
      final avatarFile = await http.get(Uri.parse(defaultAvatarUrl));
      final record = await pb.collection('users').create(
        body: {
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'passwordConfirm': password,
          'address': address,
          'role': role,
          // Thêm trường avatarUrl vào body để lưu vào PocketBase
          'avatarUrl': defaultAvatarUrl, // Lưu URL ảnh vào trường avatarUrl
        },
        files: [
          http.MultipartFile.fromBytes(
            'avatar',
            avatarFile.bodyBytes,
            filename: 'default-avatar.jpg',
          ),
        ],
      );

      // Lấy URL của avatar
      final avatarUrl = _getAvatarUrl(pb, record);

      return User.fromJson(record.toJson()).copyWith(avatarUrl: avatarUrl);
    } catch (error) {
      if (error is ClientException && error.toString().contains('email')) {
        throw 'Email này đã tồn tại, vui lòng sử dụng email khác';
      }
      throw Exception('Một lỗi đã xảy ra!');
    }
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.record;

    if (model == null) {
      return null;
    }
    return User.fromJson(model.toJson());
  }

  String _getAvatarUrl(PocketBase pb, RecordModel userModel) {
    final avatarFileName = userModel.getStringValue('avatar');
    if (avatarFileName.isEmpty) {
      // Nếu không có avatar, sử dụng URL mặc định
      return 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg';
    }
    // Lấy URL của avatar từ PocketBase
    return pb.files.getUrl(userModel, avatarFileName).toString();
  }

  Future<User> updateUser(User user, String id, String phoneNumber) async {
    final pb = await getPocketbaseInstance();
    // Kiểm tra xem số điện thoại đã tồn tại chưa
    final isPhoneAvailable = await pb.collection('users').getFullList(
          filter: 'phoneNumber="$phoneNumber"',
        );
    if (!isPhoneAvailable.isEmpty && isPhoneAvailable[0].id != id) {
      throw 'Số điện thoại này đã tồn tại, vui lòng sử dụng số điện thoại khác';
    }
    try {
      // Nếu có ảnh đại diện mới, tải lên PocketBase
      String avatarUrl = user.avatarUrl ?? '';
      if (user.avatar != null) {
        // Tải ảnh mới lên PocketBase
        final avatarFile = await http.MultipartFile.fromBytes(
          'avatar',
          await user.avatar!.readAsBytes(),
          filename: 'avatar.jpg',
        );
        final avatarRecord = await pb.collection('users').update(
          user.id!,
          body: {
            'name': user.name,
            'phoneNumber': user.phoneNumber,
            'address': user.address,
            // Cập nhật thông tin người dùng
          },
          files: [avatarFile],
        );

        // Lấy lại URL của avatar sau khi tải lên
        avatarUrl = _getAvatarUrl(pb, avatarRecord);
      } else {
        // Nếu không thay đổi ảnh đại diện, chỉ cập nhật thông tin khác
        await pb.collection('users').update(
          user.id!,
          body: {
            'name': user.name,
            'phoneNumber': user.phoneNumber,
            'address': user.address,
            // Cập nhật thông tin khác của người dùng
          },
        );
      }

      // Trả về đối tượng User đã được cập nhật với URL ảnh đại diện
      // Lấy thông tin người dùng đã cập nhật
      final updatedUser = await pb.collection('users').getOne(user.id!);

      return User.fromJson(updatedUser.toJson()).copyWith(
          avatarUrl: avatarUrl); // Sử dụng .copyWith() để cập nhật avatarUrl
    } catch (error) {
      throw Exception('Failed to update user');
    }
  }
}
