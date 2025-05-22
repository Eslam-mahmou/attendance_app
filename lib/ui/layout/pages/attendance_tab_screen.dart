import 'dart:developer';

import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_state.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_view_model.dart';
import 'package:attend_app/ui/layout/widget/custom_card_attend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/Widget/custom_diaolg.dart';
import '../widget/custom_circle_progress.dart';
import '../widget/custom_show_bottom_sheet.dart';

class AttendanceTabScreen extends StatelessWidget {
  const AttendanceTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AttendanceViewModel>();
    return BlocConsumer<AttendanceViewModel, AttendanceState>(
      listener: (context, state) {
        if (state is ErrorAttendanceState) {
          DialogUtils.showMessage(
            context: context,
            message: state.errMessage,
            title: "Error",
            postActionName: "Cancel",
          );
        }
        if (state is UpdateAttendanceIndexState){
          viewModel.report = state.report;
          log("report ${viewModel.report!.present.toString()}");
        }
      },
        builder: (context, state) {
          final viewModel = context.read<AttendanceViewModel>();

          // عندما يكون الـ state هو LoadingAttendanceState أو UpdateLoadingState
          if (state is LoadingAttendanceState || state is UpdateLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primaryColor,
              ),
            );
          }

          // عندما يكون الـ state هو SuccessAttendanceState أو UpdateAttendanceIndexState
          if (state is SuccessAttendanceState || state is UpdateAttendanceIndexState) {
            final report = state is SuccessAttendanceState ? state.report : viewModel.report;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  SizedBox(height: 45.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    width: double.infinity,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: ColorsManager.grayColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Home",
                          style: getTextStyle(
                            FontSize.s18,
                            FontWeightManager.medium,
                            ColorsManager.blackColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showBottomSheet(
                              enableDrag: true,
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return CustomShowBottomSheet();
                              },
                            );
                          },
                          icon: const ImageIcon(
                            AssetImage(IconAssets.courseIcon),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCardAttend(
                        text: "Present",
                        value: report?.present?.toString() ?? "0",
                      ),
                      CustomCardAttend(
                        text: "Absent",
                        value: report?.absent?.toString() ?? "0",
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCardAttend(
                        text: "Attendance",
                        value: "30", // استبدال بما يناسبك
                      ),
                      CustomCardAttend(
                        text: "AVG",
                        value: "25", // استبدال بما يناسبك
                      ),
                    ],
                  ),
                  SizedBox(height: 35.h),
                  const CircleProgress(),
                ],
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        }
    );
  }
}
