import 'dart:convert';

class InstrumentModel {
   String?  description;
   String?  code;
  int? quantity;
   String?  size;
   List<String?>? images; // base64 images

  InstrumentModel({
    required this.description,
    required this.code,
    required this.quantity,
    required this.size,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'code': code,
      'quantity': quantity,
      'size': size,
      'images': images,
    };
  }

  factory InstrumentModel.fromMap(Map<String, dynamic> map) {
    return InstrumentModel(
      description: map['description'] ?? '',
      code: map['code'] ?? '',
      quantity: map['quantity'] ?? '',
      size: map['size'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory InstrumentModel.fromJson(dynamic source) {
    if (source is String) {
      return InstrumentModel.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return InstrumentModel.fromMap(source);
    } else {
      throw Exception('Invalid source type for InstrumentModel');
    }
  }
}