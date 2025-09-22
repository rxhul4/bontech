import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final BottomSheet? bottomSheet;
  final Widget? floatingActionButton;
  final double? bgHeight;
  final Color? bgColor;
  final Color? bgGradient; // ✅ gradient supported

  const AppScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.appBar,
    this.bgHeight,
    this.bottomSheet,
    this.bgColor,
    this.bgGradient,
    this.floatingActionButton,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [

            Container(
              color: AppColors.bgDark,
              width: double.infinity,
              height: double.infinity,
            ),

            // ✅ Radial gradient overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -1.2),
                  radius: 1.4,
                  colors: [
                    AppColors.grad1.withOpacity(.24),
                    Colors.transparent,
                  ],
                ),
              ),
            ),


            Scaffold(
              backgroundColor: AppColors.colorTransparent,

              // Transparent to show background
              bottomSheet: widget.bottomSheet,
              bottomNavigationBar: widget.bottomNavigationBar,
              appBar: widget.appBar,
              body: SafeArea(child: widget.body),
              floatingActionButton: widget.floatingActionButton,
            ),

            // ✅ Background Layer
            // Container(
            //   width: double.infinity,
            //   height: double.infinity,
            //   decoration: BoxDecoration(
            //     color: AppColors.bgDark,
            //     gradient:
            //   ),
            // ),

            // ✅ Foreground Scaffold

          ],
        ),
      ),
    );
  }
}
