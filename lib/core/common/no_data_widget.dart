import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';

import '../utils/app_colors.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    this.msg,
  });

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: (msg ?? 'No data available').textWidget(fontWeight: FontWeight.bold, color: AppColors.colorWhite),
      ),
    );
  }
}
