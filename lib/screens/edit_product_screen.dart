import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../models/productos.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    final product = Provider.of<ProductService>(context, listen: false).SelectProduct!;

    nameController = TextEditingController(text: product.productName);
    priceController = TextEditingController(text: product.price.toString());
    stockController = TextEditingController(text: product.stock.toString());
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final product = productService.SelectProduct!;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.productId == 0 ? 'Nuevo Producto' : 'Editar Producto'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) => value != null && value.isNotEmpty ? null : 'Campo requerido',
            ),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
              validator: (value) => value != null && double.tryParse(value) != null ? null : 'Valor inválido',
            ),
            TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
              validator: (value) => value != null && int.tryParse(value) != null ? null : 'Valor inválido',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                product.productName = nameController.text;
                product.price = double.parse(priceController.text);
                product.stock = int.parse(stockController.text);

                await productService.editOrCreateProduct(product);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              child: const Text('Guardar'),
            )
          ]),
        ),
      ),
    );
  }
}
