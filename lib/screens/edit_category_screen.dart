import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import '../models/categoria.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    final categoryService = Provider.of<CategoryService>(context, listen: false);
    final Detalle category = categoryService.selectedCategory!;
    _nameController.text = category.categoryName;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    final isNew = categoryService.selectedCategory?.categoryId == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'Nueva Categoría' : 'Editar Categoría'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un nombre válido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final updated = Detalle(
                    categoryId: categoryService.selectedCategory!.categoryId,
                    categoryName: _nameController.text.trim(),
                  );

                  await categoryService.editOrCreateCategory(updated);
                  if (mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: Text(isNew ? 'Crear' : 'Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              if (!isNew)
                TextButton.icon(
                  onPressed: () async {
                    await categoryService.deleteCategory(
                        categoryService.selectedCategory!, context);
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar categoría'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}