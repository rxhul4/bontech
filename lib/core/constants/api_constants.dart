class ApiConstants{
  // static String baseUrl = "http://www.bontechadminapi.epistic.net";
  static String baseUrl = "https://distributorapi.bonetechmedisys.com";
  // static String baseUrl = "http://192.168.1.3:1592";



//Genral
  static String getAllCountry = "$baseUrl/General/Country/GetAll";
  static String getAllState = "$baseUrl/General/State/GetByCountryId";
  static String getAllCity = "$baseUrl/General/City/GetCityByStateId";
  static String getAllOrderStatus = "$baseUrl/General/OrderStatus/GetAll";

  //auth
  static String logIn = "$baseUrl/Auth/User/Login";
  static String getUserById = "$baseUrl/Auth/User/GetById";
  static String getSalesManList = "$baseUrl/Mobile/User/GetAll";
  static String addUser = "$baseUrl/Mobile/Salesman/Create";
  static String updateUser = "$baseUrl/Mobile/Salesman/Update";
  static String deleteUser = "$baseUrl/Auth/User/Delete";
  static String changePassword = "$baseUrl/Auth/User/ResetPassword";

  //homeScreen
  static String getHomeView = "$baseUrl/Mobile/Home/GetAll";
  static String searchApi = "$baseUrl/Mobile/Home/Seach";
  static String getHomeViewById = "$baseUrl/Mobile/Home/GetById";

  //catagory
  static String allCategory = "$baseUrl/SuperAdmin/Category/GetAll";
  static String getProductByCategory = "$baseUrl/SuperAdmin/Category/GetProductByCategoryId";
  static String getAssignedCategory = "$baseUrl/Mobile/Salesman/GetAssignedCategories";

  //product
  static String getProductById = "$baseUrl/SuperAdmin/Product/GetById";
  static String getProductSkuByProductId = "$baseUrl/Mobile/Product/GetById";
  static String getProductSkuIdByProductVariants = "$baseUrl/Mobile/Product/GetProductSkuIdByProductVariants";

  //order
  static String getAllSalesmanOrders = "$baseUrl/Mobile/SalesOrder/GetAllPaging";
  static String getSalesmanOrderDetails = "$baseUrl/Mobile/SalesOrder/GetById";

  static String getAllMyOrders = "$baseUrl/Mobile/DistributorOrder/GetAll";
  static String getMyOrderDetails = "$baseUrl/Mobile/Distributor/GetById";

  static String addOrderAD = "$baseUrl/Mobile/DealerOrder/Create";
  static String addSalesOrder = "$baseUrl/Mobile/SalesOrder/Create";
  static String changeOrderStatus = "$baseUrl/Mobile/SalesOrderStatus/ChangeStatus";

  //hospital
  static String addHospital = "$baseUrl/Mobile/Hospital/Create";
  static String updateHospital = "$baseUrl/Mobile/Hospital/Update";
  static String getAllHospital = "$baseUrl/Mobile/Hospital/GetAll";
  static String deleteHospital = "$baseUrl/Mobile/Hospital/Delete";
  static String getHospitalById = "$baseUrl/Mobile/Hospital/GetById";

  static String searchFilter = "$baseUrl/General/SearchFilter";

  static String updateOrder = "$baseUrl/Admin/UpdateOrder";

  static String getProductByProductView = "$baseUrl/Salesman/GetProductByProductView";
  static String getFavouriteProducts = "$baseUrl/Salesman/GetFavouriteProducts";

  static String getOrderHistory = "$baseUrl/Salesman/GetOrderHistory";



}