import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final String nombre;

  const ProviderCard({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.local_shipping, color: Colors.indigo),
        title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}