import 'dart:ffi' as ffi;
import 'dart:math' as math;
import 'dart:io' as io;

import 'package:ffi/ffi.dart' as ffi;
import 'package:bcm2835/bcm2835.dart';

import 'interface.dart';

typedef EpdPartialGroupUpdate = void Function();

class EpdDisplay {
  EpdDisplay(this.interface) {
    _init();
  }

  final EpdDisplayInterface interface;
  late final ffi.Pointer<ffi.Uint8> _txBuffer;
  late final Bcm2835 _bcm2835;
  _LutSelection? _lutSelection;
  bool _sleeping = false;
  bool _disposed = false;

  //------------------------------------------------------------------------------------------------

  void _digitalWrite(int pin, bool value) => _bcm2835.gpio_write(pin, value ? HIGH : LOW);

  bool _digitalRead(int pin) => _bcm2835.gpio_lev(pin) != LOW;

  void _digitalMode(int pin, int mode) => _bcm2835.gpio_fsel(pin, mode);

  void delayMs(int milliseconds) => io.sleep(Duration(milliseconds: milliseconds));

  /// Writes a single byte to the SPI bus and asserts the CS pin.
  int _spiWriteByte(int value) {
    return _bcm2835.spi_transfer(value & 0xff);
  }

  /// Writes a series of byte to the SPI bus.
  /// The bcm2835 automatically asserts the CS pin for each transfer.
  void _spiWriteBytes(List<int> bytes) {
    final tx = _txBuffer.asTypedList(interface.bufferSize);
    for (int i = 0; i < bytes.length; i += interface.bufferSize) {
      final length = math.min(interface.bufferSize, bytes.length);
      tx.setAll(0, bytes.getRange(i, i + length));
      _bcm2835.spi_transfern(_txBuffer.cast(), length);
    }
  }

  /// Debug print messages
  void _debug(String message) => interface.debug?.call(message);

  //------------------------------------------------------------------------------------------------

  /// Initial setup of our class and access the device.
  void _init() {
    _debug('init');

    _txBuffer = ffi.malloc<ffi.Uint8>(interface.bufferSize);
    _bcm2835 = Bcm2835(ffi.DynamicLibrary.open('/usr/local/lib/libbcm2835.so'));

    if (_bcm2835.init() == 0) {
      throw Exception('bcm2835 init failed');
    } else {
      final major = _bcm2835.version() ~/ 10000;
      final minor = _bcm2835.version() % 10000;
      _debug('bcm2835 init success: $major.$minor');
    }

    _digitalMode(interface.resetPin, FunctionSelect.GPIO_FSEL_OUTP);
    _digitalMode(interface.dataCommandPin, FunctionSelect.GPIO_FSEL_OUTP);
    _digitalMode(interface.chipSelectPin, FunctionSelect.GPIO_FSEL_OUTP);
    _digitalMode(interface.busyPin, FunctionSelect.GPIO_FSEL_INPT);
    _digitalWrite(interface.chipSelectPin, true);

    if (_bcm2835.spi_begin() == 0) {
      // Start spi interface, set spi pin for the reuse function
      throw Exception('Failed to init spi');
    }
    _bcm2835.spi_setBitOrder(SPIBitOrder.SPI_BIT_ORDER_MSBFIRST);
    _bcm2835.spi_setDataMode(SPIMode.SPI_MODE0);
    _bcm2835.spi_set_speed_hz(16000000); // 16MHz
    _bcm2835.spi_chipSelect(SPIChipSelect.SPI_CS0);
    _bcm2835.spi_setChipSelectPolarity(SPIChipSelect.SPI_CS0, LOW);
  }

  /// Disposes of the display and its resources.
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;

    _bcm2835.spi_end();

    _digitalWrite(interface.chipSelectPin, false);
    _digitalWrite(interface.dataCommandPin, false);
    _digitalWrite(interface.resetPin, false);

    _bcm2835.close();

    ffi.malloc.free(_txBuffer);
    _debug('closed');
  }

  //------------------------------------------------------------------------------------------------

  /// Send command to the panel
  void sendCommand(EpdCommand command) {
    _debug('sendCommand $command');
    _digitalWrite(interface.dataCommandPin, false);
    _spiWriteByte(command.register);
  }

  /// Send single [data] byte to the panel
  void sendData(int data, {bool debug = true}) {
    if (debug) _debug('sendData(0x${data.toHex()})');
    _digitalWrite(interface.dataCommandPin, true);
    _spiWriteByte(data);
  }

  /// Send buffer of data filled with the same [data] value of [length] bytes.
  void sendDataFilled(int data, int length) {
    _debug('sendDataFilled(0x${data.toHex()}, $length)');
    _digitalWrite(interface.dataCommandPin, true);
    _spiWriteBytes(List.filled(length, data));
  }

  /// Send multi bytes of [data]
  void sendDataMulti(List<int> data) {
    _debug('sendDataMulti(${data.length})');
    _digitalWrite(interface.dataCommandPin, true);
    _spiWriteBytes(data);
  }

  /// Wait until the panel is not busy
  int waitUntilIdle() {
    _debug('waitUntilIdle');
    int waited = 0;
    while (!_digitalRead(interface.busyPin)) {
      delayMs(1);
      waited++;
    }
    // if (retries == 0) {
    //   throw Exception('Timed out waiting');
    // }
    _debug('e-Paper ready: ${waited}ms');
    return waited;
  }

  //------------------------------------------------------------------------------------------------

  /// Software reset the panel
  void reset() {
    _debug('reset');
    _digitalWrite(interface.resetPin, false);
    delayMs(200);
    _digitalWrite(interface.resetPin, true);
    delayMs(200);
    _sleeping = false;
  }

  /// Wake up and access the E-Paper display
  void wake() {
    _debug('wake');
    reset();

    sendCommand(EpdCommand.BOOSTER_SOFT_START);
    sendData(0x17); // BT_PHA (Start Period A 10mS, Driving Strength A 3/8, Min Off GDR A 6.58uS)
    sendData(0x17); // BT_PHB (Start Period B 10mS, Driving Strength B 3/8, Min Off GDR B 6.58uS)
    sendData(0x2F); // BT_PHC1(Driving Strength C1 6/8, Min Off GDR C1 6.58uS)
    sendData(0x17); // BT_PHC2(Driving Strength C2 3/8, Min Off GDR C2 6.58uS), PHC2EN(OFF)

    sendCommand(EpdCommand.POWER_SETTING);
    sendData(0x07); // BD_EN(OFF), VSR_EN(INT), VS_EN(INT), VG_EN(INT)
    sendData(0x17); // VCOM_SLEW(FAST), VG_LVL(VHG=20v, VGL=-20v)
    sendData(0x3f); // VDH_LVL(15v)
    sendData(0x3f); // VDL_LVL(-15v)
    sendData(0x12); // VDHR_LVL(6v)

    sendCommand(EpdCommand.POWER_ON);
    waitUntilIdle();

    // 0x0f = KWR-OTP, 0x1f = KW-OTP, 0x2f = KWR-LUT, 0x3f = KW-OTP
    sendCommand(EpdCommand.PANEL_SETTING);
    // LUT(REG), KWR, UD(UP), SHL(RIGHT), SHD_N(ON), RST_N(OFF)
    sendData(interface.mode.registerValue | 0x0f);

    sendCommand(EpdCommand.PLL_CONTROL);
    sendData(0x0c); // 110Hz

    setResolution(interface.width, interface.height);

    sendCommand(EpdCommand.DUAL_SPI);
    sendData(0x00); // MM_EN(OFF), DUSPI_EN(OFF) [SINGLE MODE]

    sendCommand(EpdCommand.TCON_SETTING);
    sendData(0x22); // S2G(8uS), G2S(8uS),

    // sendCommand(EpdCommand.VCM_DC_SETTING);
    // sendData(0x26); // VDCS(-2v)

    sendCommand(EpdCommand.VCOM_AND_DATA_INTERVAL_SETTING);
    sendData(0x11); // BDZ(OFF), BDV(LUTW), N2OCP(OFF) DDX(1)
    sendData(0x07); // CDI(10 hsync)

    setLutNormal();
  }

  /// Set the Look-Up-Tables
  void setLutNormal() {
    if (!interface.mode.hasLut) {
      return;
    }
    if (_lutSelection == _LutSelection.Normal) {
      return;
    }
    _lutSelection = _LutSelection.Normal;
    sendCommand(EpdCommand.LUT_FOR_VCOM);
    sendDataMulti(lut_vcom0);
    sendCommand(EpdCommand.LUT_WHITE_TO_WHITE);
    sendDataMulti(lut_ww);
    sendCommand(EpdCommand.LUT_BLACK_TO_WHITE);
    sendDataMulti(lut_bw);
    sendCommand(EpdCommand.LUT_WHITE_TO_BLACK);
    sendDataMulti(lut_wb);
    sendCommand(EpdCommand.LUT_BLACK_TO_BLACK);
    sendDataMulti(lut_bb);
  }

  /// Set the Look-Up-Tables for quick display (partial refresh)
  void setLutQuick() {
    if (!interface.mode.hasLut) {
      return;
    }
    if (_lutSelection == _LutSelection.Quick) {
      return;
    }
    _lutSelection = _LutSelection.Quick;
    sendCommand(EpdCommand.LUT_FOR_VCOM);
    sendDataMulti(lut_vcom0_quick);
    sendCommand(EpdCommand.LUT_WHITE_TO_WHITE);
    sendDataMulti(lut_ww_quick);
    sendCommand(EpdCommand.LUT_BLACK_TO_WHITE);
    sendDataMulti(lut_bw_quick);
    sendCommand(EpdCommand.LUT_WHITE_TO_BLACK);
    sendDataMulti(lut_wb_quick);
    sendCommand(EpdCommand.LUT_BLACK_TO_BLACK);
    sendDataMulti(lut_bb_quick);
  }

  /// Set the resolution
  void setResolution(int width, int height) {
    sendCommand(EpdCommand.RESOLUTION_SETTING);
    sendData(width >> 8);
    sendData(width & 0xf8); // Nearest 8 pixels
    sendData(height >> 8);
    sendData(height & 0xff);
  }

  /// Refresh and displays a frame
  void displayFrameBuffer(List<int> frameBuffer, [List<int>? backBuffer]) {
    if (frameBuffer.length != interface.bufferSize) {
      throw Exception('Invalid frame buffer size: ${frameBuffer.length}');
    }

    setResolution(interface.width, interface.height);
    sendCommand(EpdCommand.VCM_DC_SETTING);
    sendData(0x12);

    sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
    if (backBuffer != null) {
      sendDataMulti(frameBuffer);
    } else {
      sendDataFilled(0xff, interface.bufferSize);
    }
    delayMs(2);
    sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
    if (backBuffer != null) {
      sendDataMulti(backBuffer);
    } else {
      sendDataMulti(frameBuffer);
    }
    delayMs(2);
    displayFrame();
  }

  // Clear the frame data from the SRAM (this won't refresh the display!)
  void clearFrame({bool colored = false}) {
    setResolution(interface.width, interface.height);
    sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
    delayMs(2);
    sendDataFilled(colored ? 0x00 : 0xff, interface.bufferSize);
    delayMs(2);
    sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
    delayMs(2);
    sendDataFilled(colored ? 0x00 : 0xff, interface.bufferSize);
    delayMs(2);
  }

  ///
  void groupPartialUpdate(EpdPartialGroupUpdate update) {
    try {
      sendCommand(EpdCommand.PARTIAL_IN);
      update();
    } finally {
      sendCommand(EpdCommand.PARTIAL_OUT);
    }
  }

  void setPartialWindow(List<int> data, int x, int y, int w, int h, EpdPartialMode mode) {
    sendCommand(EpdCommand.PARTIAL_IN);
    doPartialWindow(data, x, y, w, h, mode);
    sendCommand(EpdCommand.PARTIAL_OUT);
  }

  void clearPartialWindow(int x, int y, int w, int h, EpdPartialMode mode) {
    sendCommand(EpdCommand.PARTIAL_IN);
    doPartialWindow(null, x, y, w, h, mode);
    sendCommand(EpdCommand.PARTIAL_OUT);
  }

  void doPartialWindow(List<int>? data, int x, int y, int w, int h, EpdPartialMode mode) {
    final length = w ~/ 8 * h;
    // _setPartialRamArea(x, y, w, h);
    // sendCommand(mode != EpdPartialMode.buffer1
    //     ? EpdCommand.DATA_START_TRANSMISSION_1
    //     : EpdCommand.DATA_START_TRANSMISSION_2);
    // sendDataFilled(0xff, length);
    // delayMs(2);
    _setPartialRamArea(x, y, w, h);
    sendCommand(mode == EpdPartialMode.buffer1
        ? EpdCommand.DATA_START_TRANSMISSION_1
        : EpdCommand.DATA_START_TRANSMISSION_2);
    if (data != null) {
      if (data.length == length) {
        sendDataMulti(data);
      } else {
        sendDataMulti(data.sublist(0, length));
      }
    } else {
      sendDataFilled(0x00, length);
    }
    delayMs(2);
  }

  void _setPartialRamArea(int x, int y, int w, int h) {
    int xe = (x + w - 1) | 0x07;
    int ye = y + h - 1;
    x &= 0xFFF8;
    xe |= 0x07;

    /// FIXME: this is currently buggy when doing partial updates to a non-8pixel aligned x
    // print('ram area: $x -> $xe = ${xe - x} == $w');

    sendCommand(EpdCommand.PARTIAL_WINDOW); // partial window
    sendData(x ~/ 256);
    sendData(x % 256);
    sendData(xe ~/ 256);
    sendData(xe % 256);
    sendData(y ~/ 256);
    sendData(y % 256);
    sendData(ye ~/ 256);
    sendData(ye % 256);
    sendData(0x00); // 0x00 = Scan only partial window, 0x01 = Scan all pixels
  }

  /// This displays the frame data from SRAM
  void displayFrame() {
    _debug('displayFrame');
    setLutNormal();
    sendCommand(EpdCommand.DISPLAY_REFRESH);
    delayMs(100);
    waitUntilIdle();
  }

  void displayFrameQuick() {
    _debug('displayFrameQuick');
    setLutQuick();
    sendCommand(EpdCommand.DISPLAY_REFRESH);
    // delayMs(100);
    // waitUntilIdle();
  }

  /// After this command is transmitted, the chip would enter the deep-sleep mode to save power.
  /// The deep sleep mode would return to standby by hardware reset. The only one parameter is a
  /// check code, the command would be executed if check code = 0xA5.
  /// You can use [reset] to awaken and use [wake] to initialize.
  void sleep() {
    _debug('sleep');
    if (_sleeping) {
      return;
    }
    _sleeping = true;
    sendCommand(EpdCommand.VCOM_AND_DATA_INTERVAL_SETTING);
    sendData(0x17); // border floating
    sendCommand(EpdCommand.VCM_DC_SETTING); // VCOM to 0V
    sendCommand(EpdCommand.PANEL_SETTING);
    delayMs(100);

    sendCommand(EpdCommand.POWER_SETTING); // VG&VS to 0V fast
    sendData(0x00);
    sendData(0x00);
    sendData(0x00);
    sendData(0x00);
    sendData(0x00);
    delayMs(100);

    sendCommand(EpdCommand.POWER_OFF);
    final waited = waitUntilIdle();
    if (waited < 500) {
      delayMs(500 - waited);
    }
    sendCommand(EpdCommand.DEEP_SLEEP);
    sendData(0xa5);
  }
}

enum EpdPartialMode {
  buffer1,
  buffer2,
}

enum EpdCommand {
  PANEL_SETTING(0x00),
  POWER_SETTING(0x01),
  POWER_OFF(0x02),
  POWER_OFF_SEQUENCE_SETTING(0x03),
  POWER_ON(0x04),
  POWER_ON_MEASURE(0x05),
  BOOSTER_SOFT_START(0x06),
  DEEP_SLEEP(0x07),
  DATA_START_TRANSMISSION_1(0x10),
  DATA_STOP(0x11),
  DISPLAY_REFRESH(0x12),
  DATA_START_TRANSMISSION_2(0x13),
  DUAL_SPI(0x15),
  LUT_FOR_VCOM(0x20),
  LUT_WHITE_TO_WHITE(0x21),
  LUT_BLACK_TO_WHITE(0x22),
  LUT_WHITE_TO_BLACK(0x23),
  LUT_BLACK_TO_BLACK(0x24),
  PLL_CONTROL(0x30),
  TEMPERATURE_SENSOR_COMMAND(0x40),
  TEMPERATURE_SENSOR_ENABLE(0x41),
  TEMPERATURE_SENSOR_WRITE(0x42),
  TEMPERATURE_SENSOR_READ(0x43),
  VCOM_AND_DATA_INTERVAL_SETTING(0x50),
  LOW_POWER_DETECTION(0x51),
  TCON_SETTING(0x60),
  RESOLUTION_SETTING(0x61),
  GSST_SETTING(0x65),
  GET_VERSION(0x70),
  GET_STATUS(0x71),
  AUTO_MEASUREMENT_VCOM(0x80),
  READ_VCOM_VALUE(0x81),
  VCM_DC_SETTING(0x82),
  PARTIAL_WINDOW(0x90),
  PARTIAL_IN(0x91),
  PARTIAL_OUT(0x92),
  PROGRAM_MODE(0xa0),
  ACTIVE_PROGRAMMING(0xa1),
  READ_OTP(0xa2),
  POWER_SAVING(0xe3),
  UNKNOWN_97(0x97),
  UNKNOWN_FLASH_MODE(0xe5);

  final int register;

  const EpdCommand(this.register);

  @override
  String toString() => '$name(0x${register.toHex()})';
}

enum _LutSelection {
  Normal,
  Quick,
}

extension _HexInt on int {
  String toHex() => toRadixString(16).padLeft(2, '0');
}

// @formatter:off

// LVL
// 0b00 VCOM_DC  0x00
// 0b01 VCOM_H   0x40
// 0b10 VCOM_L   0x80
// 0b11 Floating 0xC0

/// VCOM Look-up-table (Normal)
const lut_vcom0 = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x40, 0x17, 0x00, 0x00, 0x00, 0x02, //  1
  0x00, 0x17, 0x17, 0x00, 0x00, 0x02, //  2
  0x00, 0x0A, 0x01, 0x00, 0x00, 0x01, //  3
  0x00, 0x0E, 0x0E, 0x00, 0x00, 0x02, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  7
];

/// VCOM Look-up-table (Quick)
const lut_vcom0_quick = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x00, 0x0E, 0x00, 0x00, 0x00, 0x01, //  1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  3
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  7
];

// LVL
// 0b00 GND  0x00
// 0b01 VDH  0x40
// 0b10 VDL  0x80
// 0b11 VDHR 0xC0

/// Normal White-to-White Look-up-table (KW Mode Only)
const lut_ww = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x40, 0x17, 0x00, 0x00, 0x00, 0x02, //  1
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02, //  2
  0x40, 0x0A, 0x01, 0x00, 0x00, 0x01, //  3
  0xA0, 0x0E, 0x0E, 0x00, 0x00, 0x02, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  7
];

/// Quick White-to-White Look-up-table (KW Mode Only)
const lut_ww_quick = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0xA0, 0x0E, 0x00, 0x00, 0x00, 0x01, //  1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  3
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  7
];

/// Normal Black-to-White Look-up-table
const lut_bw = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x40, 0x17, 0x00, 0x00, 0x00, 0x02, //  1
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02, //  2
  0x40, 0x0A, 0x01, 0x00, 0x00, 0x01, //  3
  0xA0, 0x0E, 0x0E, 0x00, 0x00, 0x02, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
];

/// Quick Black-to-White Look-up-table
const lut_bw_quick = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0xA0, 0x0E, 0x00, 0x00, 0x00, 0x01, //  1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  3
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
];

/// Normal White-to-Black Look-up-table
const lut_wb = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x80, 0x17, 0x00, 0x00, 0x00, 0x02, //  1
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02, //  2
  0x80, 0x0A, 0x01, 0x00, 0x00, 0x01, //  3
  0x50, 0x0E, 0x0E, 0x00, 0x00, 0x02, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
];

/// Quick White-to-Black Look-up-table
const lut_wb_quick = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x50, 0x0E, 0x00, 0x00, 0x00, 0x01, //  1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  3
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
];

/// Normal Black-to-Black Look-up-table
const lut_bb = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x80, 0x17, 0x00, 0x00, 0x00, 0x02, //  1
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02, //  2
  0x80, 0x0A, 0x01, 0x00, 0x00, 0x01, //  3
  0x50, 0x0E, 0x0E, 0x00, 0x00, 0x02, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
];

/// Quick Black-to-Black Look-up-table
const lut_bb_quick = <int>[
  // LVL, F1, F2, F3, F4, REPEAT
  0x50, 0x0E, 0x00, 0x00, 0x00, 0x01, //  1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  3
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  4
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  5
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //  6
];

// @formatter:on
