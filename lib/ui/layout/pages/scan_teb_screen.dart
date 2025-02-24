import 'dart:developer';

import 'package:attend_app/core/Widget/custom_diaolg.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import 'package:attend_app/ui/layout/manager/scan_qr_cubit/scan_qr_state.dart';
import 'package:attend_app/ui/layout/manager/scan_qr_cubit/scan_qr_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanTebScreen extends StatelessWidget {
 const ScanTebScreen({super.key,});


  @override
  Widget build(BuildContext context) {
    AttendanceCubit viewModel = getIt.get<AttendanceCubit>();
    return BlocProvider(
      create: (context) => viewModel,
      child: BlocBuilder<AttendanceCubit, AttendanceState>(

        builder: (context, state) {
          if (state is ScanningState || state is AttendanceInitial) {
            return MobileScanner(
              onDetect: (barcode) {
                if (barcode.raw != null) {
                  viewModel.onQRScanned(
                      barcode.raw.toString());
                  log(barcode.raw.toString());
                }

              },
            );
          }
          else if (state is QRDetectState) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("QR Data: ${state.qrData}",
                        style:const TextStyle(fontSize: 18)),
                 const   SizedBox(height: 20),
                   const CircularProgressIndicator(), // Waiting for API
                  ],
                ),
              ),
            );
          }
          else if (state is SendingAttendanceState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AttendanceSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message,
                      style:const TextStyle(color: Colors.green, fontSize: 18)),
                 const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => viewModel.retry(),
                    child:const Text("Scan Next Student"),
                  ),
                ],
              ),
            );
          } else if (state is AttendanceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.errorMessage}",
                      style: TextStyle(color: Colors.red)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => viewModel.retry(),
                    child: Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
    // return BlocProvider(
    //   create: (context) => viewModel,
    //   child: BlocConsumer<QRScanViewModel, QRScanState>(
    //     listener: (context, state) {
    //       if (state is QRErrorState) {
    //         DialogUtils.showMessage(
    //             context: context,
    //             message: state.errorMessage,
    //             title: "Error",
    //             postActionName: "Cancel");
    //       }
    //     },
    //     builder: (context, state) {
    //        if (state is QRScanningState || state is QRInitialState) {
    //         return Center(
    //                   child: SizedBox(
    //                     height: 250.h,
    //                     width: 250.w,
    //                     child: MobileScanner(
    //                       controller: viewModel.scannerController,
    //                       onDetect: (barcode) {
    //                        if(barcode.raw != null){
    //                          viewModel.sendCode();
    //                        }
    //                       },
    //                     ),
    //                   ),
    //                 );
    //       }
    //       // Column(
    //       //   mainAxisAlignment: MainAxisAlignment.center,
    //       //   children: [
    //       //     SizedBox(
    //       //       height: 150.h,
    //       //     ),
    //       //     Center(
    //       //       child: SizedBox(
    //       //         height: 250.h,
    //       //         width: 250.w,
    //       //         child: MobileScanner(
    //       //           controller: viewModel.cameraController,
    //       //           fit: BoxFit.cover,
    //       //           scanWindow: Rect.zero,
    //       //           onDetect: (barcode) {
    //       //             viewModel.cameraController.stop();
    //       //           },
    //       //         ),
    //       //       ),
    //       //     ),
    //       //     SizedBox(
    //       //       height: 150.h,
    //       //     ),
    //       //     Padding(
    //       //       padding: const EdgeInsets.all(16.0),
    //       //       child: FilledButton.icon(
    //       //         onPressed: () {
    //       //           viewModel.cameraController.start();
    //       //           viewModel.sendCode();
    //       //         },
    //       //         icon: Icon(Icons.qr_code_scanner),
    //       //         label: Text("Scan QR Code"),
    //       //       ),
    //       //     ),
    //       //     SizedBox(
    //       //       height: 30.h,
    //       //     ),
    //       //   ],
    //       // );
    //     },
    //   ),
    // );
  }
}
