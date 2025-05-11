import 'package:flutter/material.dart';
import '../models/productos.dart';

class ProductCard extends StatelessWidget {
  final Listado product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: product.productImage.isNotEmpty
            ? Image.network(product.productImage, width: 50, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported),
        title: Text(
          product.productName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'Precio: \$${product.productPrice.toStringAsFixed(0)} • Stock: ${product.productState}'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
