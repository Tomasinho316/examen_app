import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../models/productos.dart';

class ListProductScreen extends StatelessWidget {
  const ListProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Productos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: productService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productService.products.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    productService.SelectProduct = Listado(
                      productId: productService.products[i].productId,
                      productName: productService.products[i].productName,
                      price: productService.products[i].price,
                      stock: productService.products[i].stock,
                    );
                    Navigator.pushNamed(context, 'edit');
                  },
                  child: ProductCard(product: productService.products[i]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          productService.SelectProduct = Listado(
            productId: 0,
            productName: '',
            price: 0,
            stock: 0,
          );
          Navigator.pushNamed(context, 'edit');
        },
      ),
    );
  }
}
