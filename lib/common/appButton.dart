
import 'package:flutter/material.dart';

import 'dynamicFontSize.dart';
import 'AppColors.dart';

class AppButton extends StatelessWidget {

  final String label;
  final String colorText;

  const AppButton({Key key, this.label, this.colorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width/ 1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors().colorFromHex(context, colorText)
      ),
      child: Center(
        child: DynamicFontSize(label: label,
          fontSize: 20,
          color: AppColors.scaffoldBackgroundColor,),
      ),
    );

  }
}
