import 'package:teslo_shop/features/products/products.dart';

class ProductsMapper {
  static Product jsonToProduct(ProductsResponse productLike) => Product(
    id: productLike.id, 
    title: productLike.title, 
    price: productLike.price, 
    description: productLike.description, 
    slug: productLike.slug, 
    stock: productLike.stock, 
    sizes: productLike.sizes, 
    gender: productLike.gender, 
    tags: productLike.tags, 
    images: productLike.images, 
    user: productLike.user
  );
}