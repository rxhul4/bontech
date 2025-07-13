import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/features/admin/home/provider/home_providerAD.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';
import 'package:sales_app_redesign/features/admin/user/provider/user_provider.dart';
import 'package:sales_app_redesign/features/auth/presentation/spash_screen.dart';
import 'package:sales_app_redesign/features/auth/provider/auth_provider.dart';
import 'package:sales_app_redesign/features/genral/cart/provider/cart_provider.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/genral/search/provider/search_provider.dart';
import 'package:sales_app_redesign/features/sales/category/provider/category_provider.dart';
import 'package:sales_app_redesign/features/sales/home/provider/home_provider.dart';
import 'package:sales_app_redesign/features/sales/hospital/provider/hospital_provider.dart';
import 'package:sales_app_redesign/features/sales/sales_order/sales_order_provider/SalesOrderProvider.dart';


List<SingleChildWidget> providers = [

  ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
  ChangeNotifierProvider<HomeProviderAd>(create: (_) => HomeProviderAd()),
  ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
  ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
  ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
  ChangeNotifierProvider<OrderProviderAd>(create: (_) => OrderProviderAd()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
  ChangeNotifierProvider<HospitalProvider>(create: (_) => HospitalProvider()),
  ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider()),
  ChangeNotifierProvider<SalesOrderProvider>(create: (_) => SalesOrderProvider()),
  ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),

];

int cartItemCount = 0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  PreferenceHelper.load().then((value) {
    cartItemCount = PreferenceHelper.getInt(PreferenceHelper.cartItem) ?? 0 ;
    print("loaded ${value}");
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(MultiProvider(providers: providers, child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorWhite),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.colorTransparent
        ),
        scaffoldBackgroundColor: AppColors.colorTransparent,
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
