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
            // 🔧 Stabilizer patch applied here:
            await Future.delayed(const Duration(seconds: 3));
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

    final characteristic = QualifiedCharacteristic(
      deviceId: _connectedDeviceId!,
      serviceId: Uuid.parse(BleConstants.serviceUuid),
      characteristicId: Uuid.parse(BleConstants.readCharUuid),
    );

    final dataStream = bleManager.ble.subscribeToCharacteristic(characteristic);

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