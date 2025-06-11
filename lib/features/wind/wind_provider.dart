import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sensors/wind/wind_service.dart';
import '../../sensors/wind/wind_ble_service.dart';
import '../../sensors/wind/wind_model.dart';
import '../../core/ble/ble_manager.dart';
import 'dart:async';

/// Provide a single instance of BleManager
final bleManagerProvider = Provider<BleManager>((ref) => BleManager());

/// Provide a single instance of WindBleService using BleManager
final windBleServiceProvider = Provider<WindBleService>(
  (ref) => WindBleService(bleManager: ref.read(bleManagerProvider)),
);

/// Provide a single instance of WindService using WindBleService
final windServiceProvider = Provider<WindService>(
  (ref) => WindService(bleService: ref.read(windBleServiceProvider)),
);

/// Stream wind data and expose via FutureProvider
final windProvider = StreamProvider<WindData>((ref) {
  final windService = ref.read(windServiceProvider);
  return windService.dataStream;
});