import 'dart:convert';
import 'dart:typed_data';
import 'wind_model.dart';

class WindPacketParser {
  static WindData? parse(String rawData) {
    try {
      if (!rawData.startsWith(':')) return null;

      rawData = rawData.trim().substring(1);
      List<int> bytes = _asciiHexToBytes(rawData);

      int index = 4;

      int windDirectionRaw = (bytes[index] << 8) | bytes[index + 1];
      index += 2;

      List<int> windSpeedBytes = bytes.sublist(index, index + 4).reversed.toList();
      double windSpeed = ByteData.sublistView(Uint8List.fromList(windSpeedBytes)).getFloat32(0, Endian.big);
      index += 4;

      double awsKnots = windSpeed * 1.94384;

      return WindData(
        awa: windDirectionRaw.toDouble(),
        aws: awsKnots,
        twa: 0,
        tws: 0,
      );
    } catch (e) {
      return null;
    }
  }

  static List<int> _asciiHexToBytes(String hexStr) {
    List<int> result = [];
    for (int i = 0; i < hexStr.length; i += 2) {
      String byteStr = hexStr.substring(i, i + 2);
      result.add(int.parse(byteStr, radix: 16));
    }
    return result;
  }
}