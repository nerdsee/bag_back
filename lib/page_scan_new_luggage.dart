import 'package:bag_back/luggage_scan_result.dart';
import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(const MaterialApp(home: MobileScanPage()));

class MobileScanPage extends StatefulWidget {
  const MobileScanPage({Key? key, this.mode=0}) : super(key: key);

  final int mode;

  @override
  State<MobileScanPage> createState() => MobileScanPageState(mode: mode);
}

class MobileScanPageState extends State<MobileScanPage> {
  MobileScannerController cameraController = MobileScannerController();

  MobileScanPageState({this.mode=0});

  final luggageScanResult = LuggageScanResult();
  final int mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Scanner'),
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
                      if (mode==0)
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  color: luggageScanResult.hasLocation
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  border: Border.all(
                                      color: luggageScanResult.hasLocation
                                          ? Colors.green.shade900
                                          : Colors.red.shade900)),
                              child: Center(
                                  heightFactor: 1,
                                  child: Text(luggageScanResult.locationTag,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: luggageScanResult.hasLocation
                                              ? Colors.green.shade900
                                              : Colors.red.shade900))))),
                    ]),
                if (mode==0 && luggageScanResult.isValid)
                  Expanded(
                      child: Center(
                          heightFactor: 1,
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: TextButton.icon(
                                onPressed: exit,
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.green.shade100),
                                label: Text("SAVE",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.green.shade900)),
                                icon: const Icon(Icons.save, size: 40),
                              )))),
                if ((mode==1) && luggageScanResult.hasBaggage)
                  Expanded(
                      child: Center(
                          heightFactor: 1,
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: TextButton.icon(
                                onPressed: exit,
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.green.shade100),
                                label: Text("SEARCH",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.green.shade900)),
                                icon: const Icon(Icons.search, size: 40),
                              ))))
              ]),
        ]));
  }

  void exit() {
    debugPrint("Exit from ScanPage: $luggageScanResult");
    Navigator.of(context).pop(luggageScanResult);
  }
}
