import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String correo;
  final String estado;

  const ProviderCard({
    Key? key,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.estado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.local_shipping, color: Colors.indigo),
        title: Text(
          '$nombre $apellido',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(correo),
            Text('Estado: $estado'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}