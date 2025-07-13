class OrderedProductModel {
  int? productId;
  String? productName;
  String? productCode;
  String? productCategory;
  int? quantity;
  String? side;
  String? material;
  String? size;
  int? price;

  OrderedProductModel({
    this.productId,
    this.productName,
    this.productCode,
    this.productCategory,
    this.quantity,
    this.side,
    this.material,
    this.size,
    this.price,
  });
}

List<OrderedProductModel> orderedProductList = [
  OrderedProductModel(
    productId: 1,
    productName: "Product 1",
    productCode: "B01",
    productCategory: "Truma",
    quantity: 2,
    material: "SS 316L",
    size: "3 Holes",
    side: "Left",
    price: 1560,
  ),

  OrderedProductModel(
    productId: 2,
    productName: "Product 2",
    productCategory: "Truma",
    productCode: "B02",
    quantity: 26,
    material: "TITANIUM",
    size: "5 Holes",
    side: "Right",
    price: 1500,
  ),

  OrderedProductModel(
    productId: 3,
    productName: "Product 3",
    productCategory: "Spine",
    productCode: "B03",
    quantity: 20,
    material: "TITANIUM",
    size: "8 Holes",
    side: "Left",
    price: 1800,
  ),
  OrderedProductModel(
    productId: 4,
    productName: "Product 4",
    productCategory: "Spine",
    productCode: "B04",
    quantity: 15,
    material: "TITANIUM",
    size: "10 Holes",
    side: "Left",
    price: 3000,
  ),
];
