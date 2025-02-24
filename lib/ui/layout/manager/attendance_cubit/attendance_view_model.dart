import 'dart:developer';

import 'package:attend_app/domain/use_case/layout_use_case.dart';
import 'package:attend_app/ui/layout/manager/attendance_cubit/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/ReportAttendanceReportEntity.dart';
@injectable
class AttendanceViewModel extends Cubit<AttendanceState> {
  AttendanceViewModel(this._layoutUseCase) : super(LoadingAttendanceState());
  List<Attendances> attendances=[];
final LayoutUseCase _layoutUseCase;
  void fetchAttendanceData() async {
    emit(LoadingAttendanceState());
    var result=await _layoutUseCase.call("67b8ff29b4dd631faf25136f");
    log("result: $result");
    result.fold((error) {
      emit(ErrorAttendanceState(error.errorMessage));

    }, (response) {
      attendances=response.attendances??[];
      emit(SuccessAttendanceState(response));
    },);
  }
}