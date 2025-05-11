import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import '../widgets/provider_card.dart';
import '../models/proveedor.dart';

class ListProviderScreen extends StatelessWidget {
  const ListProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: providerService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: providerService.proveedores.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  providerService.selectedProvider =
                      providerService.proveedores[i];
                  Navigator.pushNamed(context, 'proveedor_edit');
                },
                child: ProviderCard(
                  nombre: providerService.proveedores[i].providerName,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          providerService.selectedProvider =
              Proveedor(proveedorId: 0, providerName: '');
          Navigator.pushNamed(context, 'proveedor_edit');
        },
      ),
    );
  }
}