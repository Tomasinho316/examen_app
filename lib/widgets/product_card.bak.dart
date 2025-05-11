import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Listado product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(product.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Precio: \$${product.price.toStringAsFixed(0)}'),
            Text('Stock: ${product.stock}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mantén presionado para eliminar'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          onLongPress: () async {
            final productService = Provider.of<ProductService>(context, listen: false);
            await productService.deleteProduct(product, context);
          },
        ),
      ),
    );
  }
}
