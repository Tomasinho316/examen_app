import 'dart:convert';

Listado listadoFromJson(String str) =>
    Listado.fromJson(json.decode(str));

String listadoToJson(Listado data) => json.encode(data.toJson());

class Listado {
  int productId;
  String productName;
  double productPrice;
  String productImage;
  String productState;

  Listado({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productState,
  });

  factory Listado.fromJson(Map<String, dynamic> json) => Listado(
        productId: json["product_id"] as int,
        productName: json["product_name"] as String,
        productPrice: (json["product_price"] as num).toDouble(),
        productImage: json["product_image"] as String,
        productState: json["product_state"] as String,
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_image": productImage,
        "product_state": productState,
      };
}
