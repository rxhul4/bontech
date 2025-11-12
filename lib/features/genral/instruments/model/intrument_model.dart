import 'dart:convert';

class ListOfInstruments {
  List<InstrumentModel> productInfo;

  ListOfInstruments({required this.productInfo});

  factory ListOfInstruments.fromJson(Map<String, dynamic> json) {
    return ListOfInstruments(
      productInfo: (json['productInfo'] as List<dynamic>?)
          ?.map((e) => InstrumentModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productInfo': productInfo.map((e) => e.toJson()).toList(),
    };
  }
}

class InstrumentModel {
  final String name;
  final String code;
  final String quantity;
  final String price;
  final List<String> images; // base64 images

  InstrumentModel({
    required this.name,
    required this.code,
    required this.quantity,
    required this.price,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'quantity': quantity,
      'price': price,
      'images': images,
    };
  }

  factory InstrumentModel.fromMap(Map<String, dynamic> map) {
    return InstrumentModel(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      quantity: map['quantity'] ?? '',
      price: map['price'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory InstrumentModel.fromJson(String source) =>
      InstrumentModel.fromMap(json.decode(source));
}
