import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import '../widgets/provider_card.dart';
import '../models/proveedor.dart';

class ListProviderScreen extends StatelessWidget {
  const ListProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ProviderService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: service.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: service.loadProviders,
              child: ListView.builder(
                itemCount: service.proveedores.length,
                itemBuilder: (_, i) {
                  final p = service.proveedores[i];
                  return GestureDetector(
                    onTap: () {
                      service.selectedProvider = p;
                      Navigator.pushNamed(context, 'proveedor_edit');
                    },
                    child: ProviderCard(
                      nombre: p.providerName,
                      apellido: p.providerLastName,
                      correo: p.providerMail,
                      estado: p.providerState,
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          service.selectedProvider = Proveedor(
            proveedorId: 0,
            providerName: '',
            providerLastName: '',
            providerMail: '',
            providerState: 'Activo',
          );
          Navigator.pushNamed(context, 'proveedor_edit');
        },
      ),
    );
  }
}