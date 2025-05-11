import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/categoria.dart';

class CategoryService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Detalle> categories = [];
  Detalle? selectedCategory;
  bool isLoading = true;
  bool isEditCreate = true;

  CategoryService() {
    loadCategories();
  }

  Future loadCategories() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(
      _baseUrl,
      'ejemplos/category_list_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    try {
      final response = await http.get(url, headers: {'authorization': basicAuth});
      final categoriesMap = Category.fromJson(json.decode(response.body));
      categories = categoriesMap.detalle;
    } catch (e) {
      print('Error procesando categorías: $e');
      categories = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future editOrCreateCategory(Detalle category) async {
    isEditCreate = true;
    notifyListeners();
    if (category.categoryId == 0) {
      await createCategory(category);
    } else {
      await updateCategory(category);
    }
    isEditCreate = false;
    notifyListeners();
  }

  Future<String> updateCategory(Detalle category) async {
    final url = Uri.http(
      _baseUrl,
      'ejemplos/category_edit_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
      url,
      body: json.encode(category.toJson()),
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);

    final index = categories.indexWhere((c) => c.categoryId == category.categoryId);
    if (index != -1) {
      categories[index] = category;
    }

    return '';
  }

  Future createCategory(Detalle category) async {
    final url = Uri.http(
        _baseUrl,
        'ejemplos/category_add_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
        url,
        body: json.encode({
        'category_name': category.categoryName,
        }),
        headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
        },
    );

    print(response.body);
    await loadCategories();
    return '';
    }


  Future deleteCategory(Detalle category, BuildContext context) async {
    final url = Uri.http(
      _baseUrl,
      'ejemplos/category_del_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
      url,
      body: json.encode(category.toJson()),
      headers: {
        'authorization': basicAuth,
        'Content-type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    categories.clear();
    loadCategories();
    Navigator.of(context).pushNamed('category_list');
    return '';
  }
}