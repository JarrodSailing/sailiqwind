import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sensors/wind/wind_service.dart';
import '../../sensors/wind/wind_model.dart';
import '../../sensors/wind/wind_ble_service.dart';

// Provide WindBleService instance
final windBleServiceProvider = Provider<WindBleService>((ref) => WindBleService());

// Provide WindService instance with BLE injected
final windServiceProvider = Provider<WindService>((ref) {
  final bleService = ref.watch(windBleServiceProvider);
  return WindService(bleService: bleService);
});

// Stream provider exposing the WindData stream (still using mock stream)
final windDataProvider = StreamProvider<WindData>((ref) {
  final service = ref.watch(windServiceProvider);
  return service.dataStream;
});