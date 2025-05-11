import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/categoria.dart';

class CategoryService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Categoria> _categories = [];
  Categoria? selectedCategory;
  bool isLoading = true;

  CategoryService() {
    loadCategories();
  }

  List<Categoria> get categories => _categories;

  Future<void> loadCategories() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, 'ejemplos/category_list_rest/');
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    try {
      final response =
          await http.get(url, headers: {'authorization': basicAuth});
      print('Response categorias: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> list =
            decoded['Listado Categorias'] as List<dynamic>;

        _categories = list
            .map((item) => Categoria.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('Error cargando categorías: ${response.statusCode}');
        _categories = [];
      }
    } catch (e) {
      debugPrint('Error cargando categorías: $e');
      _categories = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> editOrCreateCategory(Categoria category) async {
    final path = category.categoryId == 0
        ? 'ejemplos/category_add_rest/'
        : 'ejemplos/category_edit_rest/';
    final url = Uri.http(_baseUrl, path);
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    final body = {
      'category_id': category.categoryId,
      'category_name': category.categoryName,
      'category_state': category.categoryState,
    };

    debugPrint('→ BODY category edit/add: ${json.encode(body)}');

    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );

    debugPrint('← STATUS: ${response.statusCode}  BODY: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Error guardando categoría: ${response.statusCode}');
    }
    await loadCategories();
  }

  Future<void> deleteCategory(Categoria category) async {
    final url = Uri.http(_baseUrl, 'ejemplos/category_del_rest/');
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
    final body = {'category_id': category.categoryId};

    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );

    debugPrint(
        '← STATUS delete category: ${response.statusCode}  BODY: ${response.body}');
    if (response.statusCode == 200) {
      await loadCategories();
    } else {
      throw Exception('Error borrando categoría: ${response.statusCode}');
    }
  }
}