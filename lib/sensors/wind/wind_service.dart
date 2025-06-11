import 'dart:async';
import 'wind_model.dart';
import 'wind_ble_service.dart';

class WindService {
  final WindBleService bleService;

  WindService({required this.bleService});

  // For now: use mock stream
  Stream<WindData> get dataStream => Stream.periodic(
    const Duration(seconds: 1),
    (count) {
      return WindData(
        awa: 45.0 + (count % 5),
        aws: 12.0 + (count % 3),
        twa: 50.0,
        tws: 13.0,
      );
    },
  );

  // Future: this method will map BLE raw data to WindData
  Stream<WindData> get bleDataStream {
    return bleService.rawDataStream.map((raw) {
      // Parse raw BLE data string into WindData
      // Placeholder: still returning mock values
      return WindData(
        awa: 42.0,
        aws: 10.0,
        twa: 45.0,
        tws: 12.0,
      );
    });
  }
}