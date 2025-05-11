import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoryCard extends StatelessWidget {
  final Detalle category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const Icon(Icons.category, color: Colors.blueAccent),
        title: Text(
          category.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: const Icon(Icons.edit, color: Colors.grey),
      ),
    );
  }
}