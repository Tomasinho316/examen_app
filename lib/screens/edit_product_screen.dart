import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../models/productos.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _imageCtrl;
  String _state = 'Activo';

  @override
  void initState() {
    super.initState();
    final p = Provider.of<ProductService>(context, listen: false).SelectProduct!;
    _nameCtrl = TextEditingController(text: p.productName);
    _priceCtrl =
        TextEditingController(text: p.productPrice.toStringAsFixed(0));
    _imageCtrl = TextEditingController(text: p.productImage);
    _state = p.productState;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ProductService>(context);
    final p = service.SelectProduct!;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.productId == 0 ? 'Nuevo Producto' : 'Editar Producto'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: service.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    validator: (v) => v == null ||
                            double.tryParse(v.trim()) == null
                        ? 'Inválido'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imageCtrl,
                    decoration:
                        const InputDecoration(labelText: 'URL de Imagen'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _state,
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: ['Activo', 'Inactivo']
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _state = v!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      p.productName = _nameCtrl.text.trim();
                      p.productPrice =
                          double.parse(_priceCtrl.text.trim());
                      p.productImage = _imageCtrl.text.trim();
                      p.productState = _state;
                      await service.editOrCreateProduct(p);
                      Navigator.pop(context);
                    },
                  ),
                  if (p.productId != 0) ...[
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Eliminar',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Eliminar producto'),
                            content: const Text(
                                '¿Estás seguro de eliminar este producto?'),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Eliminar')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await service.deleteProduct(p);
                          Navigator.pop(context);
                        }
                      },
                    )
                  ]
                ]),
              ),
            ),
    );
  }
}