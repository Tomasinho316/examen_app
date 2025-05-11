import 'dart:convert';

class Product {
  List<Listado> listado;

  Product({required this.listado});

  factory Product.fromJson(String str) =>
      Product.fromMap(json.decode(str));

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        listado: List<Listado>.from(
            json["listado"].map((x) => Listado.fromMap(x))),
      );
}

class Listado {
  int productId;
  String productName;
  double price;
  int stock;

  Listado({
    required this.productId,
    required this.productName,
    required this.price,
    required this.stock,
  });

  factory Listado.fromMap(Map<String, dynamic> json) => Listado(
        productId: int.parse(json["product_id"].toString()),
        productName: json["product_name"],
        price: double.parse(json["price"].toString()),
        stock: int.parse(json["stock"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "price": price,
        "stock": stock,
      };
}