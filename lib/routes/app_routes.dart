import 'package:flutter/material.dart';
import '../screens/screen.dart';

class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'list': (BuildContext context) => const ListProductScreen(),
    'edit': (BuildContext context) => const EditProductScreen(),
    'add_user': (BuildContext context) => const RegisterScreen(),
    'home': (BuildContext context) => const LoadingScreen(),
    'list_category': (BuildContext context) => const ListCategoryScreen(),
    'edit_category': (BuildContext context) => const EditCategoryScreen(),
    'proveedores': (BuildContext context) => const ListProviderScreen(),
    'proveedor_edit': (BuildContext context) => const EditProviderScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
