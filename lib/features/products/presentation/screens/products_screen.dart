import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: const Text(
          'All Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New product'),
        icon: const Icon( Icons.add ),
        onPressed: () {},
      ),
    );
  }
}


class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ConsumerState<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<_ProductsView> {
  final ScrollController scrollController = ScrollController();

  Future<void> _loadNextPage() async {
    if ((scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent) {
      ref.read(productsProvider.notifier).loadNextPage();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadNextPage);
    ref.read(productsProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        crossAxisCount: 2, 
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ProductCard(product: product)
          );
        },
      )
    );
  }
}