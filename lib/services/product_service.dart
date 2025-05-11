import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/productos.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Listado> _products = [];
  Listado? SelectProduct;
  bool isLoading = true;

  ProductService() {
    loadProducts();
  }

  List<Listado> get products => _products;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, 'ejemplos/product_list_rest/');
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    try {
      final response = await http.get(
        url,
        headers: {'authorization': basicAuth},
      );

      // aquí ya imprimimos para confirmar
      print('Response productos: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
            json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> lista = decoded['Listado'] as List<dynamic>;
        _products = lista
            .map((item) =>
                Listado.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint(
            'Error cargando productos: ${response.statusCode}');
        _products = [];
      }
    } catch (e) {
      debugPrint('Error cargando productos: $e');
      _products = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> editOrCreateProduct(Listado product) async {
    final path = product.productId == 0
        ? 'ejemplos/product_add_rest/'
        : 'ejemplos/product_edit_rest/';
    final url = Uri.http(_baseUrl, path);
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    // construimos el cuerpo con las claves que espera el servidor
    final body = {
      'product_id': product.productId,
      'product_name': product.productName,
      'product_price': product.productPrice,
      'product_image': product.productImage,
      'product_state': product.productState,
    };

    debugPrint('→ BODY EDIT/CREATE: ${json.encode(body)}');

    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );

    debugPrint(
        '← STATUS: ${response.statusCode}  BODY: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception(
          'Error guardando producto: ${response.statusCode}');
    }
    await loadProducts();
  }

  Future<void> deleteProduct(Listado product) async {
    final url = Uri.http(_baseUrl, 'ejemplos/product_del_rest/');
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    final body = {'product_id': product.productId};
    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );
    debugPrint(
        '← STATUS delete: ${response.statusCode}  BODY: ${response.body}');
    if (response.statusCode == 200) {
      await loadProducts();
    } else {
      throw Exception(
          'Error borrando producto: ${response.statusCode}');
    }
  }
}