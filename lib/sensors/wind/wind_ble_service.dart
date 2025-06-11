class WindBleService {
  // Future: BLE device address / UUIDs
  // static const String deviceName = "Anemometer";
  // static const String serviceUUID = "...";
  // static const String characteristicUUID = "...";

  // Constructor
  WindBleService();

  // Future: Initialize BLE connection
  Future<void> connect() async {
    // BLE initialization will go here
  }

  // Future: Disconnect BLE
  Future<void> disconnect() async {
    // BLE disconnection logic will go here
  }

  // Future: Stream WindData from BLE
  Stream<String> get rawDataStream {
    // Placeholder: emit mock raw BLE data stream for now
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => "MOCK_BLE_DATA_$count",
    );
  }
}