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
  StreamController<WindData> _windDataController = StreamController.broadcast();

  Stream<WindData> get dataStream => _windDataController.stream;

  Future<void> connect() async {
    // Scan for devices
    final scanStream = bleManager.scanForDevices();

    await for (var result in scanStream) {
      if (result.name == 'HB-WS25092') {
        _connectedDeviceId = result.id;

        // Establish connection (stream-based)
        final connectionStream = bleManager.connectToDevice(result.id);

        await for (var update in connectionStream) {
          if (update.connectionState == DeviceConnectionState.connected) {
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

    // Insert controlled delay before subscribing
    await Future.delayed(const Duration(seconds: 3));

    final serviceUuid = BleConstants.serviceUuid;
    final characteristicUuid = BleConstants.readCharUuid;

    final dataStream = bleManager.subscribeToCharacteristic(
      _connectedDeviceId!,
      serviceUuid,
      characteristicUuid,
    );

    dataStream.listen((data) {
      final rawString = utf8.decode(data);
      final windData = WindPacketParser.parse(rawString);
      if (windData != null) {
        _windDataController.add(windData);
      }
    });
  }

  Future<void> disconnect() async {
    _connectedDeviceId = null;
  }
}