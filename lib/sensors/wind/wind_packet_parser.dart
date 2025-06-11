import 'wind_model.dart';

class WindPacketParser {
  // Parse raw BLE CSV string into WindData
  static WindData? parse(String rawData) {
    try {
      final parts = rawData.split(',');

      // Validate expected packet structure (at least enough fields present)
      if (parts.length < 3) {
        return null;
      }

      // Extract AWS and AWA from appropriate fields
      // Right now we're just taking safe placeholders for AWS and AWA:
      // Update the indexes based on your actual packet spec later if needed
      final awa = double.tryParse(parts[1]) ?? 0.0;
      final aws = double.tryParse(parts[2]) ?? 0.0;

      return WindData(
        awa: awa,
        aws: aws,
        twa: 0.0, // placeholder
        tws: 0.0, // placeholder
      );
    } catch (e) {
      // Parsing failed
      return null;
    }
  }
}
