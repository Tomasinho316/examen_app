import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/proveedor.dart';

// class ProviderService extends ChangeNotifier {
//   final String _baseUrl = '143.198.118.203:8100';
//   final String _user = 'test';
//   final String _pass = 'test2023';

//   List<Proveedor> proveedores = [];
//   Proveedor? selectedProvider;
//   bool isLoading = true;
//   bool isEditCreate = true;

//   ProviderService() {
//     loadProviders();
//   }

//   Future<void> loadProviders() async {
//     isLoading = true;
//     notifyListeners();

//     final url = Uri.http(_baseUrl, 'ejemplos/provider_list_rest/');
//     final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

//     try {
//       final res = await http.get(url, headers: {'authorization': basicAuth});
//       final List<dynamic> jsonList = json.decode(res.body)['detalle'] ?? [];
//       proveedores = jsonList.map((e) => Proveedor.fromJson(e)).toList();
//     } catch (e) {
//       debugPrint('Error cargando proveedores: $e');
//     }

//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> editOrCreateProvider(Proveedor proveedor) async {
//     isEditCreate = true;
//     notifyListeners();
//     if (proveedor.proveedorId == 0) {
//       await createProvider(proveedor);
//     } else {
//       await updateProvider(proveedor);
//     }
//     isEditCreate = false;
//     notifyListeners();
//   }

//   Future<void> createProvider(Proveedor proveedor) async {
//     final url = Uri.http(_baseUrl, 'ejemplos/provider_add_rest/');
//     final headers = {
//       'authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//     final body = jsonEncode({'provider_name': proveedor.nombre});

//     final res = await http.post(url, headers: headers, body: body);
//     debugPrint(res.body);
//     loadProviders();
//   }

//   Future<void> updateProvider(Proveedor proveedor) async {
//     final url = Uri.http(_baseUrl, 'ejemplos/provider_edit_rest/');
//     final headers = {
//       'authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//     final body = jsonEncode(proveedor.toJson());

//     final res = await http.post(url, headers: headers, body: body);
//     debugPrint(res.body);
//     loadProviders();
//   }

//   Future<void> deleteProvider(Proveedor proveedor, BuildContext context) async {
//     final url = Uri.http(_baseUrl, 'ejemplos/provider_del_rest/');
//     final headers = {
//       'authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//     final body = jsonEncode(proveedor.toJson());

//     final res = await http.post(url, headers: headers, body: body);
//     debugPrint(res.body);
//     loadProviders();
//     Navigator.pushNamed(context, 'proveedores');
//   }
// }

class ProviderService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Proveedor> providers = [];
  Proveedor? selectedProvider;
  bool isLoading = true;
  bool isEditCreate = true;

  ProviderService() {
    loadProviders();
  }

  List<Proveedor> get proveedores => _proveedores;

    List<Proveedor> _proveedores = [];

    Future<void> loadProviders() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, 'ejemplos/provider_list_rest/');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    try {
        final response = await http.get(url, headers: {'authorization': basicAuth});
        final List decoded = json.decode(response.body);
        _proveedores = decoded.map((json) => Proveedor.fromJson(json)).toList();
    } catch (e) {
        print('Error al cargar proveedores: $e');
        _proveedores = [];
    }

    isLoading = false;
    notifyListeners();
    }


    Future<void> editOrCreateProvider(Proveedor proveedor) async {
        final url = Uri.http(_baseUrl,
            proveedor.proveedorId == 0 ? 'ejemplos/provider_add_rest/' : 'ejemplos/provider_edit_rest/');
        String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

        final response = await http.post(
            url,
            body: json.encode(proveedor.toJson()),
            headers: {
            'authorization': basicAuth,
            'Content-Type': 'application/json; charset=UTF-8',
            },
        );
        print(response.body);
        loadProviders();
    }


  Future<void> createProvider(Proveedor provider) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_add_rest/');
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(provider.toJson()),
    );

    print(response.body);
    await loadProviders(); // <-- esto es clave para refrescar la lista
  }

  Future<void> updateProvider(Proveedor proveedor) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_edit_rest/');
    final headers = {
      'authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(proveedor.toJson());

    final res = await http.post(url, headers: headers, body: body);
    debugPrint(res.body);
    loadProviders();
  }

  Future<void> deleteProvider(Proveedor proveedor, BuildContext context) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_del_rest/');
    final headers = {
      'authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(proveedor.toJson());

    final res = await http.post(url, headers: headers, body: body);
    debugPrint(res.body);
    loadProviders();
    Navigator.pushNamed(context, 'proveedores');
  }
}
