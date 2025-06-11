class BleConstants {
  static const String deviceName = "HB-WS25092";

  static const String serviceUuid = "0000fff0-0000-1000-8000-00805f9b34fb";
  static const String readCharUuid = "0000fff1-0000-1000-8000-00805f9b34fb";
  static const String writeCharUuid = "0000fff2-0000-1000-8000-00805f9b34fb";

  static const List<String> supportedServiceUuids = [
    serviceUuid,
  ];
}