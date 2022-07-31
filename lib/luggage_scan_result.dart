import 'package:bag_back/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LuggageScanResult {
  /// Creates a new scan result
  add(Barcode barcode) {
    String? rawValue = barcode.rawValue;
    String format = barcode.format.name;
    print("Check Scan Result: $format ${rawValue}");

    switch (format) {
      case "itf":
        if (rawValue != null) {
          generateITFData(rawValue);
        }
        break;
      case "qrCode":
        locationTag = "HAM";
        break;
      case "dataMatrix":
        if (rawValue != null) {
          locationTag = rawValue;
        }
        break;
    }
  }

  LuggageScanResult({this.locationTag = "", this.baggageTag = ""});

  factory LuggageScanResult.fromJson(Map<String, dynamic> json) {
    print("Geerate LuggageScanResult from Json");
    return LuggageScanResult(
      locationTag: json['locationID'],
      baggageTag: json['luggageID'],
    );
  }

  String get baggageLabel => "$airlineID $airline $luggageID";

  // the complete identifier of the current location
  String locationTag = "";

  var barcodes = <Barcode>[];
  String airlineID = "";
  String luggageID = "";

  // the complete 10 digit ITF code
  String baggageTag = "";

  // airline 3LC
  String airline = "";

  bool get hasLocation => locationTag != "";

  bool get hasBaggage => airlineID != "";

  bool get isValid => hasLocation & hasBaggage;

  void generateITFData(String rawValue) {
    print("Length: ${rawValue.length}");

    if (rawValue.length == 10) {
      // length 10, might be a luggage ID
      baggageTag = rawValue;
      airlineID = baggageTag.substring(1, 4);
      luggageID = baggageTag.substring(4);

      // check if baggage Tag is already known
      checkBaggageTag(baggageTag);

      // convert code to 3LC airline code
      print("Airline ID: $airlineID");
      if (airlineID == "220") {
        airline = "LH";
      }
      if (airlineID == "724") {
        airline = "LX";
      }
    }
  }

  void checkBaggageTag(String baggageTag) async {
    LuggageScanResult? service = await Services().getLuggage(baggageTag);

    if (service != null) {
      locationTag = service.locationTag;
      print("Location for $baggageTag found: $locationTag ");
    }
  }
}
