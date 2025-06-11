import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sensors/wind/wind_service.dart';
import '../../sensors/wind/wind_model.dart';

// Provider for the WindService itself
final windServiceProvider = Provider<WindService>((ref) => WindService());

// Stream provider exposing the WindData stream
final windDataProvider = StreamProvider<WindData>((ref) {
  final service = ref.watch(windServiceProvider);
  return service.dataStream;
});