class OrderByUserModel {
  int? userID;
  String? userName;
  int? qty;
  int? price;
  int? totalPrice;

  OrderByUserModel({this.userID, this.userName, this.price, this.qty}) {
    totalPrice = (price ?? 0) * (qty ?? 0);
  }
}


List<OrderByUserModel> userOrderList = [

  OrderByUserModel(
    userID: 1,
    userName: "User 1",
    qty: 5,
    price: 1500,
  ),
  OrderByUserModel(
    userID: 2,
    userName: "User 2",
    qty: 15,
    price: 1500,
  ),

  OrderByUserModel(
    userID: 3,
    userName: "User 3",
    qty: 10,
    price: 1500,
  ),
  OrderByUserModel(
    userID: 4,
    userName: "User 4",
    qty: 20,
    price: 1500,
  ),


];