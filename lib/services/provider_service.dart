import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/proveedor.dart';

class ProviderService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Proveedor> _proveedores = [];
  Proveedor? selectedProvider;
  bool isLoading = true;
  bool isEditCreate = true;

  ProviderService() {
    loadProviders();
  }

  List<Proveedor> get proveedores => _proveedores;

  Future<void> loadProviders() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, 'ejemplos/provider_list_rest/');
    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    try {
      final response = await http.get(url, headers: {
        'authorization': basicAuth,
      });

      // Verificar status y parsear JSON
      if (response.statusCode == 200) {
        // Decodifica como Map para extraer la lista interna
        final Map<String, dynamic> decoded =
            json.decode(response.body) as Map<String, dynamic>;

        // Extrae la lista que está bajo "Proveedores Listado"
        final List<dynamic> lista =
            decoded['Proveedores Listado'] as List<dynamic>;

        // Mapea cada elemento al modelo
        _proveedores = lista
            .map((item) => Proveedor.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        // Si no es 200, limpiar lista y reportar
        debugPrint(
            'Error cargando proveedores. Status code: ${response.statusCode}');
        _proveedores = [];
      }
    } catch (e) {
      debugPrint('Error al cargar proveedores: $e');
      _proveedores = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> editOrCreateProvider(Proveedor proveedor) async {
    final path = proveedor.proveedorId == 0
        ? 'ejemplos/provider_add_rest/'
        : 'ejemplos/provider_edit_rest/';
    final url = Uri.http(_baseUrl, path);
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    // 1) Muestra lo que vas a enviar
    final bodyJson = proveedor.toJson();
    debugPrint('→ EDIT POST $url');
    debugPrint('→ BODY: ${json.encode(bodyJson)}');

    // 2) Llama al endpoint
    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(bodyJson),
    );

    // 3) Muestra el status y la respuesta
    debugPrint('← STATUS: ${response.statusCode}');
    debugPrint('← BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
          'Error guardando proveedor: ${response.statusCode}');
    }

    // 4) Refresca la lista
    await loadProviders();
  }

  Future<void> deleteProvider(Proveedor proveedor, BuildContext context) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_del_rest/');
    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(proveedor.toJson()),
    );

    debugPrint(response.body);
    await loadProviders();
    Navigator.pushNamed(context, 'proveedores');
  }
}