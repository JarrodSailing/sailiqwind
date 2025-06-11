import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  /// Request all permissions required for BLE scan.
  Future<bool> requestBlePermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    // Check if all required permissions are granted
    return bluetoothScan.isGranted &&
        bluetoothConnect.isGranted &&
        location.isGranted;
  }

  /// Optional: Check if permissions already granted
  Future<bool> hasBlePermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final location = await Permission.locationWhenInUse.status;

    return bluetoothScan.isGranted &&
        bluetoothConnect.isGranted &&
        location.isGranted;
  }
}