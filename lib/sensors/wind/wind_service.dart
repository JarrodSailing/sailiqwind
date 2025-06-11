import 'dart:async';
import 'wind_model.dart';

class WindService {
  // Mock data stream for development
  Stream<WindData> get dataStream => Stream.periodic(
    const Duration(seconds: 1),
    (count) {
      return WindData(
        awa: 45.0 + (count % 5),  // Simulate small angle variation
        aws: 12.0 + (count % 3),  // Simulate small speed variation
        twa: 50.0,
        tws: 13.0,
      );
    },
  );
}