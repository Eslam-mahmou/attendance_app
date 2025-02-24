

import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/domain/entity/ReportAttendanceReportEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Utils/font_manager.dart';
import '../../../core/Utils/style_manager.dart';

class CustomShowBottomSheet extends StatelessWidget {
 const  CustomShowBottomSheet({super.key,});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.grayColor
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            color: ColorsManager.primaryColor,
            endIndent: 10.w,
            thickness: 3,
          );
        },
        itemBuilder: (context, index) {
          return Text(
            "subject",
            style: getTextStyle(FontSize.s18, FontWeightManager.medium,
                ColorsManager.blackColor),
          );
        },
        itemCount:6,
      ),
    );
  }
}
