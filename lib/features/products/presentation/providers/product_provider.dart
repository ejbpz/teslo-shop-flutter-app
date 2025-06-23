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

  Future<void> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);

      state = state.copyWith(
        isLoading: false,
        product: product
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadProduct() async {
    try {
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