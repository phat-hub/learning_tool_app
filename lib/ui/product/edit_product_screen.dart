import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../screen.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        price: 0,
        imageURL1: '',
        imageURL2: '',
        imageURL3: '',
        imageURL4: '',
        ram: 0,
        rom: 0,
        rate: 0,
        type: '',
        screenSize: 0,
        cpu: '',
        gpu: '',
        capacity: 0,
        operatingSystem: '',
      );
    } else {
      this.product = product;
    }
  }

  late final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _keyForm = GlobalKey<FormState>();
  late Product _editProduct;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _ramController = TextEditingController();
  final _romController = TextEditingController();
  final _rateController = TextEditingController();
  final _typeController = TextEditingController();
  final _screenSizeController = TextEditingController();
  final _cpuController = TextEditingController();
  final _gpuController = TextEditingController();
  final _capacityController = TextEditingController();
  final _operatingSystemController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _editProduct = widget.product;
    if (_editProduct.id != null) {
      _nameController.text = _editProduct.title;
      _priceController.text = _editProduct.price.toString();
      _ramController.text = _editProduct.ram.toString();
      _romController.text = _editProduct.rom.toString();
      _rateController.text = _editProduct.rate.toString();
      _typeController.text = _editProduct.type;
      _screenSizeController.text = _editProduct.screenSize.toString();
      _cpuController.text = _editProduct.cpu;
      _gpuController.text = _editProduct.gpu;
      _capacityController.text = _editProduct.capacity.toString();
      _operatingSystemController.text = _editProduct.operatingSystem;
    }

    super.initState();
  }

  Future<void> _save() async {
    if (!_keyForm.currentState!.validate() ||
        !_editProduct.hasFeaturedImage1() ||
        !_editProduct.hasFeaturedImage2() ||
        !_editProduct.hasFeaturedImage3() ||
        !_editProduct.hasFeaturedImage4()) {
      return;
    }
    _keyForm.currentState!.save();

    try {
      final productManager = context.read<ProductManager>();
      if (_editProduct.id == null) {
        await productManager.addProduct(_editProduct);
      } else if (_editProduct.id != null) {
        await productManager.updateProduct(_editProduct);
      }
      Navigator.of(context).pop();
    } catch (error) {
      print("LOI: '${error}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _editProduct.id == null ? 'Thêm sản phẩm' : 'Chỉnh sửa sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _keyForm,
          child: ListView(
            children: [
              _buildProductPreview1(),
              const SizedBox(height: 20),
              _buildProductPreview2(),
              const SizedBox(height: 20),
              _buildProductPreview3(),
              const SizedBox(height: 20),
              _buildProductPreview4(),
              const SizedBox(height: 20),
              _buildNameField(),
              const SizedBox(height: 20),
              _buildPriceField(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 25,
                    child: _buildRamField(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 25,
                    child: _buildRomField(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRateField(),
              const SizedBox(height: 20),
              _buildTypeField(),
              const SizedBox(height: 20),
              _buildScreenSizeField(),
              const SizedBox(height: 20),
              _buildCpuField(),
              const SizedBox(height: 20),
              _buildGpuField(),
              const SizedBox(height: 20),
              _buildCapacityField(),
              const SizedBox(height: 20),
              _buildOperatingSystemField(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      controller: _nameController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Tên sản phẩm',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập tên sản phẩm';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(title: value);
      },
    );
  }

  TextFormField _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Giá',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập giá sản phẩm';
        } else if (int.tryParse(value) == null) {
          return 'Vui lòng nhập đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(price: int.tryParse(value!));
      },
    );
  }

  TextFormField _buildRamField() {
    return TextFormField(
      controller: _ramController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'RAM',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập dung lượng RAM';
        } else if (int.tryParse(value) == null) {
          return 'Vui lòng nhập đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(ram: int.tryParse(value!));
      },
    );
  }

  TextFormField _buildRomField() {
    return TextFormField(
      controller: _romController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'ROM',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập dung lượng ROM';
        } else if (int.tryParse(value) == null) {
          return 'Vui lòng nhập đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(rom: int.tryParse(value!));
      },
    );
  }

  TextFormField _buildRateField() {
    return TextFormField(
      controller: _rateController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Mức độ đánh giá',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập mức độ đánh giá';
        } else if (double.tryParse(value) == null) {
          return 'Vui lòng nhập đúng định dạng';
        } else if (double.tryParse(value)! > 5.0) {
          return 'Mức độ đánh giá nhỏ hơn 5.0';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(rate: double.tryParse(value!));
      },
    );
  }

  TextFormField _buildTypeField() {
    return TextFormField(
      controller: _typeController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Loại sản phẩm',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập loại sản phẩm';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(type: value);
      },
    );
  }

  TextFormField _buildScreenSizeField() {
    return TextFormField(
      controller: _screenSizeController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Kích thước màn hình',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập kích thước màn hình';
        } else if (double.tryParse(value) == null) {
          return 'Vui lòng nhập đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct =
            _editProduct.copyWith(screenSize: double.tryParse(value!));
      },
    );
  }

  TextFormField _buildCpuField() {
    return TextFormField(
      controller: _cpuController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'CPU',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập CPU';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(cpu: value);
      },
    );
  }

  TextFormField _buildGpuField() {
    return TextFormField(
      controller: _gpuController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'GPU',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập GPU';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(gpu: value);
      },
    );
  }

  TextFormField _buildCapacityField() {
    return TextFormField(
      controller: _capacityController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Dung lượng pin',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập dung lượng pin';
        } else if (int.tryParse(value) == null) {
          return 'Vui lòng nhập đúng định dạng';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(capacity: int.tryParse(value!));
      },
    );
  }

  TextFormField _buildOperatingSystemField() {
    return TextFormField(
      controller: _operatingSystemController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Hệ điều hành',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập hệ điều hành';
        }
        return null;
      },
      onSaved: (value) {
        _editProduct = _editProduct.copyWith(operatingSystem: value);
      },
    );
  }

  Widget _buildProductPreview1() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            border: !_editProduct.hasFeaturedImage1()
                ? Border.all(width: 1, color: Colors.black)
                : Border.all(color: Colors.white),
          ),
          child: !_editProduct.hasFeaturedImage1()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editProduct.featuredImage1 == null
                      ? Image.network(
                          _editProduct.imageURL1,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editProduct.featuredImage1!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: SizedBox(height: 100, child: _buildImagePickerButton1()),
        ),
      ],
    );
  }

  TextButton _buildImagePickerButton1() {
    return TextButton.icon(
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        'Chọn hình ảnh từ thiết bị',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () async {
        final imagePicker = ImagePicker();
        try {
          final imageFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }

          setState(() {
            _editProduct = _editProduct.copyWith(
              featuredImage1: File(imageFile.path),
            );
          });
        } catch (error) {
          print("Lỗi tải ảnh lên từ thiết bị: '${error}'");
        }
      },
    );
  }

  Widget _buildProductPreview2() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            border: !_editProduct.hasFeaturedImage2()
                ? Border.all(width: 1, color: Colors.black)
                : Border.all(color: Colors.white),
          ),
          child: !_editProduct.hasFeaturedImage2()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editProduct.featuredImage2 == null
                      ? Image.network(
                          _editProduct.imageURL2,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editProduct.featuredImage2!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: SizedBox(height: 100, child: _buildImagePickerButton2()),
        ),
      ],
    );
  }

  TextButton _buildImagePickerButton2() {
    return TextButton.icon(
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        'Chọn hình ảnh từ thiết bị',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () async {
        final imagePicker = ImagePicker();
        try {
          final imageFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }

          setState(() {
            _editProduct = _editProduct.copyWith(
              featuredImage2: File(imageFile.path),
            );
          });
        } catch (error) {
          print("Lỗi tải ảnh lên từ thiết bị: '${error}'");
        }
      },
    );
  }

  Widget _buildProductPreview3() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            border: !_editProduct.hasFeaturedImage3()
                ? Border.all(width: 1, color: Colors.black)
                : Border.all(color: Colors.white),
          ),
          child: !_editProduct.hasFeaturedImage3()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editProduct.featuredImage3 == null
                      ? Image.network(
                          _editProduct.imageURL3,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editProduct.featuredImage3!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: SizedBox(height: 100, child: _buildImagePickerButton3()),
        ),
      ],
    );
  }

  TextButton _buildImagePickerButton3() {
    return TextButton.icon(
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        'Chọn hình ảnh từ thiết bị',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () async {
        final imagePicker = ImagePicker();
        try {
          final imageFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }

          setState(() {
            _editProduct = _editProduct.copyWith(
              featuredImage3: File(imageFile.path),
            );
          });
        } catch (error) {
          print("Lỗi tải ảnh lên từ thiết bị: '${error}'");
        }
      },
    );
  }

  Widget _buildProductPreview4() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            border: !_editProduct.hasFeaturedImage4()
                ? Border.all(width: 1, color: Colors.black)
                : Border.all(color: Colors.white),
          ),
          child: !_editProduct.hasFeaturedImage4()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editProduct.featuredImage4 == null
                      ? Image.network(
                          _editProduct.imageURL4,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editProduct.featuredImage4!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: SizedBox(height: 100, child: _buildImagePickerButton4()),
        ),
      ],
    );
  }

  TextButton _buildImagePickerButton4() {
    return TextButton.icon(
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        'Chọn hình ảnh từ thiết bị',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () async {
        final imagePicker = ImagePicker();
        try {
          final imageFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }

          setState(() {
            _editProduct = _editProduct.copyWith(
              featuredImage4: File(imageFile.path),
            );
          });
        } catch (error) {
          print("Lỗi tải ảnh lên từ thiết bị: '${error}'");
        }
      },
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        _editProduct.id == null ? 'Thêm sản phẩm' : 'Lưu thay đổi',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
