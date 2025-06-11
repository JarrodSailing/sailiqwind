import 'dart:convert';
import 'dart:typed_data';
import 'wind_model.dart';

class WindPacketParser {
  static WindData? parse(String rawData) {
    try {
      if (!rawData.startsWith(':')) return null;

      // Strip off the starting ':' and trim trailing whitespace
      rawData = rawData.substring(1).trim();

      // Split CSV parts
      List<String> fields = rawData.split(',');

      if (fields.length < 3) return null;

      // Parse fields safely
      double? windDir = double.tryParse(fields[1]);  // 2nd field
      double? windSpeed = double.tryParse(fields[2]);  // 3rd field

      if (windDir == null || windSpeed == null) return null;

      // Convert m/s to knots
      double awsKnots = windSpeed * 1.94384;

      return WindData(
        awa: windDir,
        aws: awsKnots,
        twa: 0,
        tws: 0,
      );
    } catch (e) {
      print('[Parser Error]: $e');
      return null;
    }
  }
}
