import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';
import 'package:teslo_shop/features/shared/widgets/full_screen_loader.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  
  const ProductScreen({
    super.key,
    required this.productId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.canPop() ? context.pop() : null, 
          icon: const Icon(Icons.navigate_before)
        ),
        titleSpacing: 0,
        centerTitle: true,
        title: const Text(
          'Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.camera_alt_outlined)
          )
        ],
      ),
      body: productState.isLoading 
      ? const FullScreenLoader()
      : Center(
        child: Text(productState.id)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.sd_storage_outlined),
      ),
    );
  }
}