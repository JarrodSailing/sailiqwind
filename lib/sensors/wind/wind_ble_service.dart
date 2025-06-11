import 'dart:async';
import 'dart:convert';
import '../../core/ble/ble_manager.dart';
import 'ble_constants.dart';
import 'wind_packet_parser.dart';
import 'wind_model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class WindBleService {
  final BleManager bleManager;

  WindBleService({required this.bleManager});

  String? _connectedDeviceId;
  final StreamController<WindData> _windDataController = StreamController.broadcast();

  Stream<WindData> get dataStream => _windDataController.stream;

  Future<void> connect() async {
    final scanStream = bleManager.scanForDevices();

    await for (var result in scanStream) {
      if (result.name == BleConstants.deviceName) {
        _connectedDeviceId = result.id;

        final connectionStream = bleManager.connectToDevice(result.id);
        await for (var update in connectionStream) {
          if (update.connectionState == DeviceConnectionState.connected) {

            // ✅ Added stabilizer delay here:
            await Future.delayed(const Duration(seconds: 2));

            await _subscribeToWindData();
            break;
          }
        }
        break;
      }
    }
  }

  Future<void> _subscribeToWindData() async {
    if (_connectedDeviceId == null) return;

    final dataStream = bleManager.subscribeToCharacteristic(
      deviceId: _connectedDeviceId!,
      serviceUuid: BleConstants.serviceUuid,
      characteristicUuid: BleConstants.readCharUuid,
    );

    dataStream.listen((data) {
      final rawString = asciiDecoder(data);
      print('[BLE] Incoming data: $rawString');
      final windData = WindPacketParser.parse(rawString);
      if (windData != null) {
        _windDataController.add(windData);
      }
    });
  }

  String asciiDecoder(List<int> data) {
    return data.map((b) => String.fromCharCode(b)).join();
  }

  Future<void> disconnect() async {
    _connectedDeviceId = null;
  }
}