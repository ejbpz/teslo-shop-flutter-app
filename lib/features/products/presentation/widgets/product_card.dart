import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {  
  final Product product;

  const ProductCard({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(images: product.images),
        Text(product.title, textAlign: TextAlign.center)
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  
  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    if(images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        height: 250,
        images.first,
        fit: BoxFit.cover,
      ),
    );
  }
}