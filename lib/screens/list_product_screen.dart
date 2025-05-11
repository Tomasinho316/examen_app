import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../models/productos.dart';

class ListProductScreen extends StatelessWidget {
  const ListProductScreen({Key? key}) : super(key: key);

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
          : RefreshIndicator(
              onRefresh: productService.loadProducts,
              child: ListView.builder(
                itemCount: productService.products.length,
                itemBuilder: (context, i) {
                  final p = productService.products[i];
                  return GestureDetector(
                    onTap: () {
                      productService.SelectProduct = p;
                      Navigator.pushNamed(context, 'edit');
                    },
                    child: ProductCard(product: p),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          productService.SelectProduct = Listado(
            productId: 0,
            productName: '',
            productPrice: 0,
            productImage: '',
            productState: 'Activo',
          );
          Navigator.pushNamed(context, 'edit');
        },
      ),
    );
  }
}
