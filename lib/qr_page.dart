import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr/bloc/bloc.dart';
import 'package:qr/bloc/event.dart';
import 'package:qr/bloc/state.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final _bloc = QRBloc(QRInitial());
  final qrKey = GlobalKey();
  Barcode? value;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      setState(() {
        value = scanData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<QRBloc, QRState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is QRLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.8),
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: const CircularProgressIndicator(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is QRFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              Navigator.pop(context);
              setState(() {
                value = null;
                controller?.resumeCamera();
              });
            }
            if (state is QRSuccessful) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Амжилттай")));
              Navigator.pop(context);
              setState(() {
                value = null;
                controller?.resumeCamera();
              });
            }
          },
        )
      ],
      child: BlocBuilder<QRBloc, QRState>(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(value != null ? Colors.greenAccent : Colors.blueAccent),
                        ),
                        onPressed: () {
                          _bloc.add(QRSubmit(value?.code ?? ''));
                        },
                        child: const Text('Илгээх'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                        ),
                        onPressed: () {
                          setState(() {
                            value = null;
                            controller?.resumeCamera();
                          });
                        },
                        child: const Text('Болих'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
