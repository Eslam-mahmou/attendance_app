import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/ui/layout/manager/layout_cubit/layout_state.dart';
import 'package:attend_app/ui/layout/manager/layout_cubit/layout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/modals/course_list_model.dart';
import '../../di/injectable_initializer.dart';
import 'manager/attendance_cubit/attendance_view_model.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LayoutViewModel viewModel = LayoutViewModel();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => viewModel,),
        BlocProvider(  create: (context) {
          final viewModel = getIt<AttendanceViewModel>();
          final courseId = CourseListModel().coursesList[0].id;
          if (courseId != null) {
            viewModel.fetchAttendanceData(courseId);
          }
          return viewModel;
        },)
      ],
      child: BlocBuilder<LayoutViewModel, LayoutState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: ColorsManager.whiteColor,
              body: viewModel.tabs[viewModel.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: viewModel.currentIndex,
                  onTap: (value) {
                    viewModel.changeTab(value);
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: ColorsManager.whiteColor,
                  showUnselectedLabels: false,
                  unselectedIconTheme: const IconThemeData(
                      color: ColorsManager.blackColor, size: 28),
                  selectedIconTheme: const IconThemeData(
                      color: ColorsManager.primaryColor, size: 35),
                  selectedLabelStyle: getTextStyle(FontSize.s16,
                      FontWeightManager.medium, ColorsManager.primaryColor),
                  selectedItemColor: ColorsManager.primaryColor,
                  items: const [
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage(IconAssets.scanIcon)),
                      label: "Scan",
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage(IconAssets.profileIcon)),
                      label: "Profile",
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage(IconAssets.attendIcon)),
                      label: "Attendance",
                    ),
                  ]),
            );
          }),
    );
  }
}
