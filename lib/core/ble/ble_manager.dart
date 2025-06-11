import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../sensors/wind/ble_constants.dart';

class BleManager {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // Start BLE scan as stream
  Stream<DiscoveredDevice> scanForDevices() {
    return _ble.scanForDevices(
      withServices: BleConstants.supportedServiceUuids.map((uuid) => Uuid.parse(uuid)).toList(),
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

  // Read services after connection
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    return await _ble.discoverServices(deviceId);
  }

  // Subscribe to characteristic notifications (string-based version only)
  Stream<List<int>> subscribeToCharacteristic(String deviceId, String serviceUuid, String characteristicUuid) {
    return _ble.subscribeToCharacteristic(
      QualifiedCharacteristic(
        serviceId: Uuid.parse(serviceUuid),
        characteristicId: Uuid.parse(characteristicUuid),
        deviceId: deviceId,
      ),
    );
  }
}