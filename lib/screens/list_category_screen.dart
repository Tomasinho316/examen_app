import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import '../widgets/category_card.dart';
import '../models/categoria.dart';

class ListCategoryScreen extends StatelessWidget {
  const ListCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    final categories = categoryService.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Categorías'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: categoryService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final Detalle category = categories[i];
                return GestureDetector(
                  onTap: () {
                    categoryService.selectedCategory = Detalle(
                      categoryId: category.categoryId,
                      categoryName: category.categoryName,
                    );
                    Navigator.pushNamed(context, 'edit_category');
                  },
                  child: CategoryCard(category: category),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          categoryService.selectedCategory = Detalle(categoryId: 0, categoryName: '');
          Navigator.pushNamed(context, 'edit_category');
        },
      ),
    );
  }
}
