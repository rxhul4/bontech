class PartiallyDeliverReqModel {
  String? productId;
  String? productSkuId;
  int? deliveredQuantity;

  PartiallyDeliverReqModel({this.productId,this.productSkuId,this.deliveredQuantity});
}


Map<String, dynamic> buildPartialDeliveryRequest(List<PartiallyDeliverReqModel> items) {
  return {
    "items": items.map((item) => {
      "ProductId": item.productId,
      "ProductSkuId": item.productSkuId,
      "DeliveredQuantity": item.deliveredQuantity,
    }).toList()
  };
}
