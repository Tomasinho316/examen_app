import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import '../models/proveedor.dart';

class EditProviderScreen extends StatefulWidget {
  const EditProviderScreen({super.key});

  @override
  State<EditProviderScreen> createState() => _EditProviderScreenState();
}

class _EditProviderScreenState extends State<EditProviderScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<ProviderService>(context, listen: false).selectedProvider!;
    _nameController = TextEditingController(text: provider.providerName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final proveedor = providerService.selectedProvider!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Proveedor'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del proveedor'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () async {
                proveedor.providerName = _nameController.text.trim();
                await providerService.editOrCreateProvider(proveedor);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            if (proveedor.proveedorId != 0)
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Eliminar',
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await providerService.deleteProvider(proveedor, context);
                },
              ),
          ],
        ),
      ),
    );
  }
}