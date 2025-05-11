import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import '../models/categoria.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({Key? key}) : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  String _state = 'Activa';

  @override
  void initState() {
    super.initState();
    final c =
        Provider.of<CategoryService>(context, listen: false).selectedCategory!;
    _nameCtrl = TextEditingController(text: c.categoryName);
    _state = c.categoryState;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<CategoryService>(context);
    final c = service.selectedCategory!;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.categoryId == 0 ? 'Nueva Categoría' : 'Editar Categoría'),
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
                  DropdownButtonFormField<String>(
                    value: _state,
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: const [
                      DropdownMenuItem(value: 'Activa', child: Text('Activa')),
                      DropdownMenuItem(value: 'Inactiva', child: Text('Inactiva')),
                    ],
                    onChanged: (v) => setState(() => _state = v!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      c.categoryName = _nameCtrl.text.trim();
                      c.categoryState = _state;
                      await service.editOrCreateCategory(c);
                      Navigator.pop(context);
                    },
                  ),
                  if (c.categoryId != 0) ...[
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label:
                          const Text('Eliminar', style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Eliminar categoría'),
                            content: const Text(
                                '¿Seguro que quieres eliminar esta categoría?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await service.deleteCategory(c);
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