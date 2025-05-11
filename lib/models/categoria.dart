import 'dart:convert';

class Category {
  List<Detalle> detalle;

  Category({
    required this.detalle,
  });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        detalle: json['detalle'] != null
            ? List<Detalle>.from(json['detalle'].map((x) => Detalle.fromJson(x)))
            : [],
    );
}

class Detalle {
  int categoryId;
  String categoryName;

  Detalle({
    required this.categoryId,
    required this.categoryName,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
      };
}
