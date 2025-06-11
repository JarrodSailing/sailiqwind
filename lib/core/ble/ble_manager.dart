import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleManager {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // Scan with no filtering to avoid discovery failures
  Stream<DiscoveredDevice> scanForDevices() {
    return _ble.scanForDevices(
      withServices: [],  // ← No service filtering
      scanMode: ScanMode.lowLatency,
    );
  }

  // Connect to selected device
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  // Subscribe directly to characteristic
  Stream<List<int>> subscribeToCharacteristic({
    required String deviceId,
    required String serviceUuid,
    required String characteristicUuid,
  }) {
    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(serviceUuid),
      characteristicId: Uuid.parse(characteristicUuid),
    );

    return _ble.subscribeToCharacteristic(characteristic);
  }

  // ✅ Expose _ble safely
  FlutterReactiveBle get ble => _ble;
}