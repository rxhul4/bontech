import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/features/admin/category_ad/provider/category_provider_ad.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';
import 'package:sales_app_redesign/features/admin/pending_order/provider/pending_order_provider.dart';
import 'package:sales_app_redesign/features/admin/stock/provider/stock_provider.dart';
import 'package:sales_app_redesign/features/admin/user/provider/user_provider.dart';
import 'package:sales_app_redesign/features/auth/presentation/spash_screen.dart';
import 'package:sales_app_redesign/features/auth/provider/auth_provider.dart';
import 'package:sales_app_redesign/features/genral/cart/provider/cart_provider.dart';
import 'package:sales_app_redesign/features/genral/home/provider/home_provider.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/genral/search/provider/search_provider.dart';
import 'package:sales_app_redesign/features/sales/category/provider/category_provider.dart';
import 'package:sales_app_redesign/features/sales/hospital/provider/hospital_provider.dart';
import 'package:sales_app_redesign/features/sales/sales_order/sales_order_provider/SalesOrderProvider.dart';

import 'features/sales/dashboard/dashboard.dart';

int cartItemCount = 0;

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
  ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
  ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
  ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
  ChangeNotifierProvider<OrderProviderAd>(create: (_) => OrderProviderAd()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
  ChangeNotifierProvider<HospitalProvider>(create: (_) => HospitalProvider()),
  ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider()),
  ChangeNotifierProvider<SalesOrderProvider>(
    create: (_) => SalesOrderProvider(),
  ),
  ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
  ChangeNotifierProvider<StockProvider>(create: (_) => StockProvider()),
  ChangeNotifierProvider<PendingOrderProvider>(
    create: (_) => PendingOrderProvider(),
  ),ChangeNotifierProvider<CategoryProviderAD>(
    create: (_) => CategoryProviderAD(),
  ),
];



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  PreferenceHelper.load().then((value) {
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
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.colorTransparent
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(
          primary: AppColors.bgDark,
          seedColor: AppColors.colorWhite,
          background: AppColors.bgDark,
          onPrimary: AppColors.colorWhite,
          secondary: const Color(0xFF82A7FF),
          onSecondary: Colors.white,
          surface: AppColors.bgDark,
          onSurface: Colors.white.withOpacity(.92),
          outline: Colors.white.withOpacity(.10),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            final selected = states.contains(MaterialState.selected);
            return TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: selected ? Colors.white : Colors.white.withOpacity(.72),
              fontFamily: "Poppins",
            );
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            final selected = states.contains(MaterialState.selected);
            return IconThemeData(
              color:
                  selected
                      ? AppColors.colorWhite
                      : Colors.white.withOpacity(.72),
              size: 22,
            );
          }),
          indicatorColor: AppColors.colorSecondary.withOpacity(0.15),
          backgroundColor: Colors.transparent, // glass wraps it
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.colorTransparent,
        ),
        scaffoldBackgroundColor: AppColors.bgDark,
        useMaterial3: false,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
