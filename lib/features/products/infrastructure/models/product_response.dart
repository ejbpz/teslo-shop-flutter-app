import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/auth.dart';

class ProductsResponse {
    final String id;
    final String title;
    final double price;
    final String description;
    final String slug;
    final int stock;
    final List<String> sizes;
    final String gender;
    final List<String> tags;
    final List<String> images;
    final User? user;

    ProductsResponse({
        required this.id,
        required this.title,
        required this.price,
        required this.description,
        required this.slug,
        required this.stock,
        required this.sizes,
        required this.gender,
        required this.tags,
        required this.images,
        required this.user,
    });

    factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
        id: json["id"],
        title: json["title"],
        price: double.parse(json["price"].toString()),
        description: json["description"],
        slug: json["slug"],
        stock: json["stock"],
        sizes: List<String>.from(json["sizes"].map((x) => x)),
        gender: json["gender"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        images: List<String>.from(
          json["images"].map(
            (x) => x.startsWith('http')
              ? x
              : '${Environment.apiUrl}/files/product/$x',
          )
        ),
        user: UserMapper.jsonToUser(LoginResponse.fromJson(json["user"])),
    );
}

