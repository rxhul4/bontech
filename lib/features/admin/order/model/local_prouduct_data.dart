import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';

class LocalProductData {
  final double totalAmount;
  final List<SalesOrderProductList> productList;

  LocalProductData({required this.totalAmount, required this.productList});
}
