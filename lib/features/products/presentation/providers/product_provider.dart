import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/provider.dart';

final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
    productsRepository: productsRepository, 
    productId: productId
  );
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;
  final String productId;

  ProductNotifier({
    required this.productsRepository,
    required this.productId
  }): super(ProductState(id: productId)) {
    loadProduct();
  }

  Product _newEmptyProduct() => Product(
    id: 'new', 
    title: '', 
    price: 0, 
    description: '', 
    slug: '', 
    stock: 0, 
    sizes: [''], 
    gender: 'men', 
    tags: [], 
    images: [],
  );

  Future<void> loadProduct() async {
    try {
      if(state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: _newEmptyProduct()
        );
      }

      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(
        isLoading: false,
        product: product
      );
    } catch (e) {
      print(e);
    }
  }
}

class ProductState {
  final bool isLoading;
  final bool isSaving;
  final String id;
  final Product? product;

  ProductState({
    this.isLoading = true, 
    this.isSaving = false, 
    required this.id, 
    this.product
  });

  ProductState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? id,
    Product? product,
  }) => ProductState(
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    id: id ?? this.id,
    product: product ?? this.product,
  );
}