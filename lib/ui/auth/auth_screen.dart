import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:developer' show log;

import '../screen.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isAgreed = false; // Biến lưu trữ trạng thái checkbox
  final _keyForm = GlobalKey<FormState>();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'phoneNumber': '',
    'address': '',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final isValid = _keyForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _keyForm.currentState!.save();

    try {
      await context.read<AuthManager>().login(
            _authData['email']!,
            _authData['password']!,
          );
    } catch (error) {
      log('$error');
      if (mounted) {
        showErrorDialog(context, error.toString());
      }
    }
  }

  Future<void> _signup() async {
    final isValid = _keyForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!_isAgreed) {
      // Nếu checkbox chưa được tick, thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn cần đồng ý với các điều khoản bảo mật cá nhân'),
        ),
      );
      return;
    }
    _keyForm.currentState!.save();

    try {
      await context.read<AuthManager>().signup(
            _authData['name']!,
            _authData['email']!,
            _authData['phoneNumber']!,
            _authData['password']!,
            _authData['address']!,
          );
      _switchAuthMode();
    } catch (error) {
      log('$error');
      if (mounted) {
        showErrorDialog(context, error.toString());
      }
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _authMode == AuthMode.login ? 'Đăng nhập' : 'Đăng ký',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _keyForm,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 40),
              _buildLogo(),
              const SizedBox(height: 40),
              if (_authMode == AuthMode.signup) _buildNameField(),
              if (_authMode == AuthMode.signup) const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),
              if (_authMode == AuthMode.signup) _buildPhoneField(),
              if (_authMode == AuthMode.signup) const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              if (_authMode == AuthMode.signup) _buildConfirmPasswordField(),
              if (_authMode == AuthMode.signup) const SizedBox(height: 20),
              if (_authMode == AuthMode.signup) _buildAddressField(),
              if (_authMode == AuthMode.signup) const SizedBox(height: 20),
              if (_authMode == AuthMode.signup) _buildAgreeTerms(),
              if (_authMode == AuthMode.signup) const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
              _buildSignupLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/Logo2.png',
        height: 100,
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      controller: _nameController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Họ và tên',
        prefixIcon: Icon(Icons.person),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập họ và tên';
        }
        return null;
      },
      onSaved: (value) {
        _authData['name'] = value!;
      },
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập Email';
        } else if (!value.contains('@')) {
          return 'Vui lòng nhập đúng địa chỉ Email';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }

  TextFormField _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
        prefixIcon: Icon(Icons.phone),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        } else if (!RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$').hasMatch(value)) {
          return 'Số điện thoại không đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _authData['phoneNumber'] = value!;
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        } else if (value.length < 8) {
          return 'Password quá ngắn!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  TextFormField _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Nhập lại mật khẩu',
        prefixIcon: Icon(Icons.lock),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập lại mật khẩu';
        }
        if (value != _passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
    );
  }

  TextFormField _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Địa chỉ',
        prefixIcon: Icon(Icons.location_on),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập địa chỉ';
        }
        return null;
      },
      onSaved: (value) {
        _authData['address'] = value!;
      },
    );
  }

  Widget _buildAgreeTerms() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isAgreed,
          onChanged: (newValue) {
            setState(() {
              _isAgreed = newValue!;
            });
          },
        ),
        const Expanded(
          child: Text(
            'Tôi đồng ý với các điều khoản bảo mật cá nhân',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_authMode == AuthMode.login) {
          _login();
        } else if (_authMode == AuthMode.signup) {
          _signup();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        _authMode == AuthMode.login ? 'Đăng nhập' : 'Đăng ký',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bạn chưa có tài khoản? ',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: _switchAuthMode,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(
              _authMode == AuthMode.signup ? 'Đăng Nhập' : 'Đăng ký',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
