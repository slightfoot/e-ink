typedef EPaperDebug = void Function(dynamic value);

class EPaperDisplayInterface {
  factory EPaperDisplayInterface.epd7in5v3([EPaperDebug? debug]) {
    return EPaperDisplayInterface(
      width: 800,
      height: 480,
      resetPin: 17,
      dataCommandPin: 25,
      chipSelectPin: 8,
      busyPin: 24,
      debug: debug,
    );
  }

  EPaperDisplayInterface({
    required this.width,
    required this.height,
    required this.resetPin,
    required this.dataCommandPin,
    required this.chipSelectPin,
    required this.busyPin,
    this.debug,
  }) {
    if (width % 8 != 0) {
      throw Exception('Width must be a multiple of 8 pixels.');
    }
    bufferSize = (width ~/ 8) * height;
  }

  /// Width of display in pixels
  final int width;

  /// Height of display in pixels
  final int height;

  /// Frame buffer size in bytes
  late final int bufferSize;

  /// Reset pin
  final int resetPin;

  /// Data/Command pin
  final int dataCommandPin;

  /// Chip Select pin
  final int chipSelectPin;

  /// Busy pin
  final int busyPin;

  /// Outputs debug values
  final EPaperDebug? debug;
}
