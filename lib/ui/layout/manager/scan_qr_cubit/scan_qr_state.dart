abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class ScanningState extends AttendanceState {}

class QRDetectState extends AttendanceState {
  final String qrData;
  QRDetectState(this.qrData);
}

class SendingAttendanceState extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;
  AttendanceSuccess(this.message);
}

class AttendanceError extends AttendanceState {
  final String errorMessage;
  AttendanceError(this.errorMessage);
}