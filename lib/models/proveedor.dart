import 'dart:convert';

Proveedor proveedorFromJson(String str) =>
    Proveedor.fromJson(json.decode(str));

String proveedorToJson(Proveedor data) => json.encode(data.toJson());

class Proveedor {
  int proveedorId;
  String providerName;
  String providerLastName;
  String providerMail;
  String providerState;

  Proveedor({
    required this.proveedorId,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        proveedorId: json["providerid"] as int,
        providerName: json["provider_name"] as String,
        providerLastName: json["provider_last_name"] as String,
        providerMail: json["provider_mail"] as String,
        providerState: json["provider_state"] as String,
      );

  Map<String, dynamic> toJson() => {
        "provider_id": proveedorId,
        "provider_name": providerName,
        "provider_last_name": providerLastName,
        "provider_mail": providerMail,
        "provider_state": providerState,
      };
}
