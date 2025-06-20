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

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    throw UnimplementedError();
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