import 'dart:developer';
import 'package:attend_app/domain/entity/QRCodeResponseEntity.dart';
import 'package:attend_app/domain/use_case/layout_use_case.dart';
import 'package:attend_app/ui/layout/manager/scan_qr_cubit/scan_qr_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  final LayoutUseCase _layoutUseCase;

  AttendanceCubit(this._layoutUseCase) : super(AttendanceInitial());
  QrCodeResponseEntity? code;

  void startScanning() {
    emit(ScanningState());
  }

  Future<void> onQRScanned(String qrCode) async {
    emit(QRDetectState(qrCode));
    String status = "Present";
  var data = await _layoutUseCase.sendQR(
      "67b8ff29b4dd631faf25136f" ,
       "67bcc7bb03d9c2da990becac",
        "absent");
    log("qrCode: ${qrCode}");
    // log(code?.studentAttendance?.student?.id.toString()??"");
    // log(code?.studentAttendance?.sessionID.toString()??"");
    log("rdfghjkyerdfh ${data.toString()}");
    emit(SendingAttendanceState());
    data.fold(
      (l) {
        emit(AttendanceError(l.errorMessage.toString()));
      },
      (r) {

        emit(AttendanceSuccess(r.message.toString()));
      },
    );

    // try {
    //   bool success = await repository.sendAttendance(studentId, sessionId, status);
    //   if (success) {
    //     emit(AttendanceSuccess("Attendance marked successfully!"));
    //   } else {
    //     emit(AttendanceError("Failed to mark attendance"));
    //   }
    // } catch (e) {
    //   emit(AttendanceError(e.toString()));
    // }
  }

  void retry() {
    emit(ScanningState());
  }

  String extractStudentId(String qrData) {
    return qrData; // Modify if QR contains extra info
  }
}
