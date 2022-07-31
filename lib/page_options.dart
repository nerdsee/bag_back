import 'package:bag_back/luggage_scan_result.dart';
import 'package:bag_back/page_scan_new_luggage.dart';
import 'package:bag_back/services.dart';
import 'package:flutter/material.dart';

import 'page_locate_luggage.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  LuggageScanResult? luggageScanResult;

  exit() {
    print('Exit');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final luggageScanResult = this.luggageScanResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options2'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          RaisedButton(
            onPressed: () {
              setState(() {
                scanNew();
              });
            },
            child: const Text('Scan New Luggage (M1)'),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                findLuggage();
              });
            },
            child: const Text('Locate Luggage'),
          ),
          if (luggageScanResult != null)
            if (luggageScanResult.isValid)
              Text(
                  "Luggage ${luggageScanResult.airlineID} ${luggageScanResult.airline} ${luggageScanResult.luggageID} is in ${luggageScanResult.locationTag}")
            else
              Text("The scanned code is unknown")
        ]),
      ),
    );
  }

  void scanNew() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MobileScanPage(mode: 0);
        },
      ),
    );
  }

  void findLuggage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LocatePage(mode: 1);
        },
      ),
    );

    debugPrint("Receive Result: $result");

    final LuggageScanResult luggage =
        await Services().getLuggage("${result.baggageTag}");

    debugPrint("LuggageFound: $luggage");

    setState(() {
      luggageScanResult = luggage;
    });
  }

  saveResult(LuggageScanResult result) {
    Services services = Services();

    services.saveResult(result);
  }
}
