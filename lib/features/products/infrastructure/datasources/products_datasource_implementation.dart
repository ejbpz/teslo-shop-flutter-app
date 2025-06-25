import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/products.dart';

class ProductsDatasourceImplementation extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;
  
  ProductsDatasourceImplementation({required this.accessToken})
    : dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,
        headers: {
          'Authorization': 'Bearer $accessToken'
        }
      )
    );
    
  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName)
      });

      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadImages(List<String> images) async {
    final imagesToUpload = images.where((image) => image.contains('/data')).toList();
    final imagesToIgnore = images.where((image) => !image.contains('/data')).toList();

    final List<Future<String>> uploadJob = imagesToUpload.map(
      (e) => _uploadFile(e)
    ).toList();

    final newImages = await Future.wait(uploadJob);
    return [...imagesToIgnore, ...newImages];
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';
      productLike.remove('id');
      productLike['images'] = await _uploadImages(productLike['images']);

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method
        ),
      );

      return ProductsMapper.jsonToProduct(ProductsResponse.fromJson(response.data));
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {      
      final response = await dio.get('/products/$id');

      return ProductsMapper.jsonToProduct(ProductsResponse.fromJson(response.data));
    } on DioException catch(e) {
      if(e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>(
      '/products', 
      queryParameters: {
        'limit': limit,
        'offset': offset,
      }
    );

    final List<Product> products = [];

    for (final product in response.data ?? []) {
      products.add(ProductsMapper.jsonToProduct(ProductsResponse.fromJson(product)));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    throw UnimplementedError();
  }

}