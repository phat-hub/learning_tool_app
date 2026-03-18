import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' show log;

import '../screen.dart';

class EditAuthScreen extends StatefulWidget {
  static const routeName = '/edit_auth';

  EditAuthScreen(
    User user, {
    super.key,
  }) {
    this.user = user;
  }

  late final User user;

  @override
  State<EditAuthScreen> createState() => _EditAuthScreenState();
}

class _EditAuthScreenState extends State<EditAuthScreen> {
  final _editForm = GlobalKey<FormState>();
  late User _editedUser;

  @override
  void initState() {
    _editedUser = widget.user;
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    try {
      final userManager = context.read<AuthManager>();
      final user = userManager.getUserDetails();

      final updatedUser = await userManager.updateUser(
          _editedUser, user['id'], _editedUser.phoneNumber);

      if (mounted) {
        // Cập nhật UI với người dùng đã được cập nhật
        setState(() {
          _editedUser = updatedUser;
        });
        Navigator.of(context).pop();
      }
    } catch (error) {
      log('$error');
      if (mounted) {
        showErrorDialog(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _editForm,
          child: ListView(
            children: <Widget>[
              _buildAvatarPreview(),
              const SizedBox(height: 20),
              _buildNameField(),
              const SizedBox(height: 20),
              _buildPhoneField(),
              const SizedBox(height: 20),
              _buildAddressField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250,
          height: 350,
          decoration: BoxDecoration(
            border: !_editedUser.hasAvatarImage()
                ? Border.all(width: 1, color: Colors.black)
                : Border.all(color: Colors.white),
          ),
          child: !_editedUser.hasAvatarImage()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editedUser.avatar == null
                      ? Image.network(
                          _editedUser.avatarUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editedUser.avatar!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: SizedBox(height: 100, child: _buildImagePickerButton()),
        ),
      ],
    );
  }

  TextButton _buildImagePickerButton() {
    return TextButton.icon(
      icon: const Icon(
        Icons.image,
        color: const Color(0xFFFFA500),
      ),
      label: const Text(
        'Chọn hình ảnh từ thiết bị',
        style: TextStyle(color: const Color(0xFFFFA500)),
      ),
      onPressed: () async {
        final imagePicker = ImagePicker();
        try {
          final imageFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }
          _editedUser = _editedUser.copyWith(avatar: File(imageFile.path));

          setState(() {});
        } catch (error) {
          if (mounted) {
            showErrorDialog(context, 'Something went wrong');
          }
        }
      },
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _editedUser.name,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Họ và tên',
        prefixIcon: Icon(Icons.person),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập họ và tên';
        }
        return null;
      },
      onSaved: (value) {
        _editedUser = _editedUser.copyWith(name: value);
      },
    );
  }

  TextFormField _buildPhoneField() {
    return TextFormField(
      initialValue: _editedUser.phoneNumber,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
        prefixIcon: Icon(Icons.phone),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        } else if (!RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$').hasMatch(value)) {
          return 'Số điện thoại không đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _editedUser = _editedUser.copyWith(phoneNumber: value);
      },
    );
  }

  TextFormField _buildAddressField() {
    return TextFormField(
      initialValue: _editedUser.address,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Địa chỉ',
        prefixIcon: Icon(Icons.location_on),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập địa chỉ';
        }
        return null;
      },
      onSaved: (value) {
        _editedUser = _editedUser.copyWith(address: value);
      },
    );
  }
}
