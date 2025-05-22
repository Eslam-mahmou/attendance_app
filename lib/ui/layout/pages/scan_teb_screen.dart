import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/Widget/custom_diaolg.dart';
import '../manager/scan_qr_cubit/scan_qr_state.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import '../manager/scan_qr_cubit/scan_qr_view_model.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..startScanning(),
      child: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceErrorState) {
            DialogUtils.showMessage(
              context: context,
              message: state.errorMessage,
              title: "Error",
              postActionName: "Cancel",
            );
          }
        },
        builder: (context, state) {
          final viewModel = context.read<AttendanceCubit>();

          if (state is ScanningState || state is AttendanceInitial) {
            return MobileScanner(onDetect: (BarcodeCapture capture) {
              final barcode = capture.barcodes.first;
              final raw = barcode.rawValue;
              if (raw != null) {
                context.read<AttendanceCubit>().onQRScanned(raw);
              }
            });
          }

          if (state is QRDetectedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("QR Data: ${state.qrData}",
                      style:const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(), // Preparing to send
                ],
              ),
            );
          }

          if (state is SendingAttendanceState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceSuccessState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message,
                      style:
                          const TextStyle(color: Colors.green, fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => viewModel.retry(),
                    child: const Text("Scan Next"),
                  ),
                ],
              ),
            );
          }

          if (state is AttendanceErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.errorMessage}",
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => viewModel.retry(),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox(); // fallback
        },
      ),
    );
  }
}
