import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import '../widgets/category_card.dart';
import '../models/categoria.dart';

class ListCategoryScreen extends StatelessWidget {
  const ListCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<CategoryService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: service.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: service.loadCategories,
              child: ListView.builder(
                itemCount: service.categories.length,
                itemBuilder: (_, i) {
                  final c = service.categories[i];
                  return GestureDetector(
                    onTap: () {
                      service.selectedCategory = c;
                      Navigator.pushNamed(context, 'edit_category');
                    },
                    child: CategoryCard(category: c),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          service.selectedCategory =
              Categoria(categoryId: 0, categoryName: '', categoryState: 'Activa');
          Navigator.pushNamed(context, 'edit_category');
        },
      ),
    );
  }
}