import 'dart:async';
import 'wind_model.dart';
import 'wind_ble_service.dart';

class WindService {
  final WindBleService bleService;

  WindService({required this.bleService});

  Future<void> connect() async {
    await bleService.connect();
  }

  // Stream WindData from BLE
  Stream<WindData> get dataStream => bleService.dataStream;
}