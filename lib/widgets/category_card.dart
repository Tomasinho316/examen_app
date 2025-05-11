import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoryCard extends StatelessWidget {
  final Categoria category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.category, color: Colors.indigo),
        title: Text(
          category.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Estado: ${category.categoryState}'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
