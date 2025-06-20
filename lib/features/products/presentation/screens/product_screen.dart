import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if(context.canPop()) context.pop();
          }, 
          icon: const Icon(Icons.navigate_before)
        ),
        title: const Text('Product'),
      ),
      body: Center(
        child: Text(widget.productId),
      ),
    );
  }
}