import 'dart:convert';

Proveedor proveedorFromJson(String str) =>
    Proveedor.fromJson(json.decode(str));

String proveedorToJson(Proveedor data) => json.encode(data.toJson());

class Proveedor {
  int proveedorId;
  String providerName;

  Proveedor({
    required this.proveedorId,
    required this.providerName,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        proveedorId: json["proveedor_id"],
        providerName: json["provider_name"],
      );

  Map<String, dynamic> toJson() => {
        "proveedor_id": proveedorId,
        "provider_name": providerName,
      };
}