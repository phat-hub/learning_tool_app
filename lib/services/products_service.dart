import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

import '../ui/screen.dart';

class ProductsService {
  String _getFeaturedImageUrl(
      PocketBase pb, RecordModel productModel, String imageField) {
    final imageName = productModel.getStringValue(imageField);
    return pb.files.getUrl(productModel, imageName).toString();
  }

  Future<Product?> addProduct(Product product) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final productModel = await pb.collection('products').create(
        body: {
          ...product.toJson(),
          'userId': userId,
        },
        files: [
          http.MultipartFile.fromBytes(
            'featuredImage1',
            await product.featuredImage1!.readAsBytes(),
            filename: product.featuredImage1!.uri.pathSegments.last,
          ),
          http.MultipartFile.fromBytes(
            'featuredImage2',
            await product.featuredImage2!.readAsBytes(),
            filename: product.featuredImage2!.uri.pathSegments.last,
          ),
          http.MultipartFile.fromBytes(
            'featuredImage3',
            await product.featuredImage3!.readAsBytes(),
            filename: product.featuredImage3!.uri.pathSegments.last,
          ),
          http.MultipartFile.fromBytes(
            'featuredImage4',
            await product.featuredImage4!.readAsBytes(),
            filename: product.featuredImage4!.uri.pathSegments.last,
          ),
        ],
      );

      return product.copyWith(
        id: productModel.id,
        imageURL1: _getFeaturedImageUrl(pb, productModel, 'featuredImage1'),
        imageURL2: _getFeaturedImageUrl(pb, productModel, 'featuredImage2'),
        imageURL3: _getFeaturedImageUrl(pb, productModel, 'featuredImage3'),
        imageURL4: _getFeaturedImageUrl(pb, productModel, 'featuredImage4'),
      );
    } catch (error) {
      return null;
    }
  }

  Future<Product?> updateProduct(Product product) async {
    try {
      final pb = await getPocketbaseInstance();
      final productModel = await pb.collection('products').update(
        product.id!,
        body: product.toJson(),
        files: [
          if (product.featuredImage1 != null)
            http.MultipartFile.fromBytes(
              'featuredImage1',
              await product.featuredImage1!.readAsBytes(),
              filename: product.featuredImage1!.uri.pathSegments.last,
            ),
          if (product.featuredImage2 != null)
            http.MultipartFile.fromBytes(
              'featuredImage2',
              await product.featuredImage2!.readAsBytes(),
              filename: product.featuredImage2!.uri.pathSegments.last,
            ),
          if (product.featuredImage3 != null)
            http.MultipartFile.fromBytes(
              'featuredImage3',
              await product.featuredImage3!.readAsBytes(),
              filename: product.featuredImage3!.uri.pathSegments.last,
            ),
          if (product.featuredImage4 != null)
            http.MultipartFile.fromBytes(
              'featuredImage4',
              await product.featuredImage4!.readAsBytes(),
              filename: product.featuredImage4!.uri.pathSegments.last,
            ),
        ],
      );
      return product.copyWith(
        imageURL1: product.featuredImage1 != null
            ? _getFeaturedImageUrl(pb, productModel, 'featuredImage1')
            : product.imageURL1,
        imageURL2: product.featuredImage2 != null
            ? _getFeaturedImageUrl(pb, productModel, 'featuredImage2')
            : product.imageURL2,
        imageURL3: product.featuredImage3 != null
            ? _getFeaturedImageUrl(pb, productModel, 'featuredImage3')
            : product.imageURL3,
        imageURL4: product.featuredImage4 != null
            ? _getFeaturedImageUrl(pb, productModel, 'featuredImage4')
            : product.imageURL4,
      );
    } catch (error) {
      print("ERROR IN UPDATE RECORD: '${error}'");
      return null;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('products').delete(id);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Product>> fetchProducts({bool filteredByUser = false}) async {
    final List<Product> products = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final productModels = await pb
          .collection('products')
          .getFullList(filter: filteredByUser ? "userId ='$userId'" : null);
      for (final productModel in productModels) {
        products.add(
          Product.fromJson(
            productModel.toJson()
              ..addAll(
                {
                  'imageURL1':
                      _getFeaturedImageUrl(pb, productModel, 'featuredImage1'),
                  'imageURL2':
                      _getFeaturedImageUrl(pb, productModel, 'featuredImage2'),
                  'imageURL3':
                      _getFeaturedImageUrl(pb, productModel, 'featuredImage3'),
                  'imageURL4':
                      _getFeaturedImageUrl(pb, productModel, 'featuredImage4'),
                },
              ),
          ),
        );
      }
      return products;
    } catch (error) {
      return products;
    }
  }
}
