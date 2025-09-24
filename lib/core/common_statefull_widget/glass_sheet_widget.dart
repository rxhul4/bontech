import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';

class GlassSheet extends StatelessWidget {
   String? title;
   Widget? child;
   GlassSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Frost(

        blur: 24,
        opacity: .20,
        radius: 18,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  "$title".textWidget(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.white
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  Icon(Icons.close,color: AppColors.colorWhite,),
                  )
                ],
              ),
              const Divider(height: 10),
               child ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
