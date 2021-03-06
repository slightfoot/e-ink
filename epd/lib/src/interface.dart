typedef EPaperDebug = void Function(dynamic value);

class EpdDisplayInterface {
  factory EpdDisplayInterface.epd7in5v3({EpdMode? mode, EPaperDebug? debug}) {
    return EpdDisplayInterface(
      width: 800,
      height: 480,
      resetPin: 17,
      dataCommandPin: 25,
      chipSelectPin: 8,
      busyPin: 24,
      mode: mode ?? EpdMode.kwLut,
      debug: debug,
    );
  }

  EpdDisplayInterface({
    required this.width,
    required this.height,
    required this.resetPin,
    required this.dataCommandPin,
    required this.chipSelectPin,
    required this.busyPin,
    this.mode = EpdMode.kwLut,
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

  /// Center X of display in pixels
  int get cx => width ~/ 2;

  /// Center Y of display in pixels
  int get cy => height ~/ 2;

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

  /// Operating mode
  final EpdMode mode;
}

enum EpdMode {
  kwrOtp(0x00, false, false),
  kwOtp(0x10, true, false),
  kwrLut(0x20, false, true),
  kwLut(0x30, true, true);

  const EpdMode(this.registerValue, this.isBlackWhite, this.hasLut);

  final int registerValue;
  final bool isBlackWhite;
  final bool hasLut;
}
