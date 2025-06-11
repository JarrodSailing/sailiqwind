class WindData {
  final double awa; // Apparent Wind Angle (°)
  final double aws; // Apparent Wind Speed (knots)
  final double twa; // True Wind Angle (°)
  final double tws; // True Wind Speed (knots)

  WindData({
    required this.awa,
    required this.aws,
    required this.twa,
    required this.tws,
  });
}