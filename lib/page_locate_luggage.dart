import 'package:bag_back/luggage_scan_result.dart';
import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(const MaterialApp(home: LocatePage()));

class LocatePage extends StatefulWidget {
  const LocatePage({Key? key, this.mode = 0}) : super(key: key);

  final int mode;

  @override
  State<LocatePage> createState() => LocatePageState(mode: mode);
}

class LocatePageState extends State<LocatePage> {
  MobileScannerController cameraController = MobileScannerController();

  LocatePageState({this.mode = 0});

  final luggageScanResult = LuggageScanResult();
  final int mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Locate Luggage'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: Stack(children: <Widget>[
          MobileScanner(
              allowDuplicates: false,
              controller: cameraController,
              onDetect: (barcode, args) {
                final String code = barcode.rawValue!;
                final String format = barcode.format.name;
                final String type = barcode.type.name;

                setState(() {
                  luggageScanResult.add(barcode);

                  if (luggageScanResult.hasBaggage) {
                    exit();
                  }
                });
                debugPrint('Barcode found! $code : $format : $type}');
              }),
          Column(
              // padding: const EdgeInsets.all(5.0),
              children: <Widget>[
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  color: luggageScanResult.hasBaggage
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  border: Border.all(
                                      color: luggageScanResult.hasBaggage
                                          ? Colors.green.shade900
                                          : Colors.red.shade900)),
                              child: Center(
                                  heightFactor: 1,
                                  child: Text(luggageScanResult.baggageLabel,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: luggageScanResult.hasBaggage
                                              ? Colors.green.shade900
                                              : Colors.red.shade900))))),
                    ]),
                if (luggageScanResult.hasLocation)
                  Expanded(
                      child: Center(
                          heightFactor: 1,
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: TextButton.icon(
                                onPressed: exit,
                                style: TextButton.styleFrom(
                                     backgroundColor: Colors.green.shade100),
                                label: Text("Location: ${luggageScanResult.locationTag}",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.green.shade900)),
                                icon: const Icon(Icons.location_on, size: 40),
                              )))),
              ]),
        ]));
  }

  void exit() {
    debugPrint("Exit from ScanPage: $luggageScanResult");
    Navigator.of(context).pop(luggageScanResult);
  }
}
