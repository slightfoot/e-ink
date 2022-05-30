import 'dart:async';
import 'dart:io' as io;
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:ffi/ffi.dart' as ffi;

import 'package:bcm2835/bcm2835.dart';

/// Reset Pin
const EPD_RST_PIN = 17;

/// Data/Command Pin
const EPD_DC_PIN = 25;

/// Chip Select Pin
const EPD_CS_PIN = 8;

/// Busy/Wait Pin
const EPD_BUSY_PIN = 24;

/// Display resolution width
const EPD_WIDTH = 800;

/// Display resolution height
const EPD_HEIGHT = 480;

class EPaperDisplay {
  EPaperDisplay() {
    _init();
  }

  late final ffi.Pointer<ffi.Uint8> txBuffer;
  late final int bufferSize;
  late final Bcm2835 bcm2835;

  //------------------------------------------------------------------------------------------------

  /// Initial setup of our class and access the device.
  void _init() {
    print('init');

    bufferSize = EPD_WIDTH ~/ 8 * EPD_HEIGHT;
    txBuffer = ffi.malloc<ffi.Uint8>(bufferSize);

    bcm2835 = Bcm2835(ffi.DynamicLibrary.open('/usr/local/lib/libbcm2835.so'));

    bcm2835.set_debug(0);

    if (bcm2835.init() == 0) {
      throw Exception('bcm2835 init failed');
    } else {
      final major = bcm2835.version() ~/ 10000;
      final minor = bcm2835.version() % 10000;
      print('bcm2835 init success: $major.$minor');
    }

    _digitalMode(EPD_RST_PIN, FunctionSelect.GPIO_FSEL_OUTP);
    _digitalMode(EPD_DC_PIN, FunctionSelect.GPIO_FSEL_OUTP);
    _digitalMode(EPD_CS_PIN, FunctionSelect.GPIO_FSEL_OUTP);
    _digitalMode(EPD_BUSY_PIN, FunctionSelect.GPIO_FSEL_INPT);
    _digitalWrite(EPD_CS_PIN, true);

    if (bcm2835.spi_begin() == 0) {
      // Start spi interface, set spi pin for the reuse function
      throw Exception('Failed to init spi');
    }
    bcm2835.spi_setBitOrder(SPIBitOrder.SPI_BIT_ORDER_MSBFIRST);
    bcm2835.spi_setDataMode(SPIMode.SPI_MODE0);
    bcm2835.spi_set_speed_hz(16000000); // 16MHz
    bcm2835.spi_chipSelect(SPIChipSelect.SPI_CS0);
    bcm2835.spi_setChipSelectPolarity(SPIChipSelect.SPI_CS0, LOW);
  }

  /// Closes the connection to the device and cleans up.
  void close() {
    bcm2835.spi_end();

    _digitalWrite(EPD_CS_PIN, false);
    _digitalWrite(EPD_DC_PIN, false);
    _digitalWrite(EPD_RST_PIN, false);

    bcm2835.close();

    ffi.malloc.free(txBuffer);
    print('closed');
  }

  void _digitalWrite(int pin, bool value) => bcm2835.gpio_write(pin, value ? HIGH : LOW);

  bool _digitalRead(int pin) => bcm2835.gpio_lev(pin) != LOW;

  void _digitalMode(int pin, int mode) => bcm2835.gpio_fsel(pin, mode);

  void delayMs(int ms) => bcm2835.delay(ms);

  /// Writes a single byte to the SPI bus and asserts the CS pin.
  void _spiWriteByte(int value) {
    bcm2835.spi_transfer(value & 0xff);
  }

  /// Writes a series of byte to the SPI bus and asserts the CS pin for each.
  void _spiWriteBytes(List<int> bytes) {
    final tx = txBuffer.asTypedList(bufferSize);
    for (int i = 0; i < bytes.length; i += bufferSize) {
      final length = math.min(bufferSize, bytes.length);
      tx.setAll(0, bytes.getRange(i, i + length));
      bcm2835.spi_transfern(txBuffer.cast(), length);
    }
  }

  //------------------------------------------------------------------------------------------------

  /// Send command to the panel
  void sendCommand(EpdCommand command) {
    print('sendCommand $command');
    _digitalWrite(EPD_DC_PIN, false);
    // _digitalWrite(EPD_CS_PIN, false);
    _spiWriteByte(command.register);
    // _digitalWrite(EPD_CS_PIN, true);
  }

  /// Send single [data] byte to the panel
  void sendData(int data) {
    print('sendData ${data.toRadixString(16).padLeft(2, '0')}');
    _digitalWrite(EPD_DC_PIN, true);
    // _digitalWrite(EPD_CS_PIN, false);
    _spiWriteByte(data);
    // _digitalWrite(EPD_CS_PIN, true);
  }

  /// Send buffer of data filled with the same [data] value of [length] bytes.
  void sendDataFilled(int data, int length) {
    _digitalWrite(EPD_DC_PIN, true);
    _spiWriteBytes(List.filled(length, data));
  }

  /// Send multi bytes of [data]
  void sendDataMulti(List<int> data) {
    _digitalWrite(EPD_DC_PIN, true);
    _spiWriteBytes(data);
  }

  /// Wait until the panel is not busy
  void waitUntilIdle() {
    print('waitUntilIdle');
    int waited = 0;
    while (!_digitalRead(EPD_BUSY_PIN)) {
      delayMs(1);
      waited++;
    }
    // if (retries == 0) {
    //   throw Exception('Timed out waiting');
    // }
    print('e-Paper ready: ${waited}ms');
  }

  //------------------------------------------------------------------------------------------------

  /// Software reset the panel
  void reset() {
    _digitalWrite(EPD_RST_PIN, false);
    delayMs(200);
    _digitalWrite(EPD_RST_PIN, true);
    delayMs(200);
  }

  /// Initialize the e-Paper registers
  void init() {
    print('init');

    reset();

    // sendCommand(EpdCommand.POWER_SETTING);
    // sendData(0x07);
    // sendData(0x07); // VGH =  20V, VGL = -20V
    // sendData(0x3f); // VDH =  15V
    // sendData(0x3f); // VDL = -15V
    // sendData(0x11); // VSHR

    // sendCommand(EpdCommand.POWER_SETTING);
    // sendData(0x17); // 1-0=11: internal power
    // sendData(0x17); // VGH & VGL
    // sendData(0x3f); // VSH
    // sendData(0x3f); // VSL
    // sendData(0x11); // VSHR

    sendCommand(EpdCommand.POWER_SETTING);
    sendData(0x03); // VDS_EN, VDG_EN
    sendData(0x00); // VCOM_HV, VGHL_LV[1], VGHL_LV[0]
    sendData(0x2b); // VDH
    sendData(0x2b); // VDL
    sendData(0xff); // VDHR

    // sendCommand(EpdCommand.VCM_DC_SETTING);
    // sendData(0x24); // VCOM

    // sendCommand(EpdCommand.BOOSTER_SOFT_START);
    // sendData(0x27);
    // sendData(0x27);
    // sendData(0x2F);
    // sendData(0x17);

    sendCommand(EpdCommand.BOOSTER_SOFT_START);
    sendData(0x17);
    sendData(0x17);
    sendData(0x17);

    sendCommand(EpdCommand.POWER_ON);
    // delayMs(100);
    waitUntilIdle();

    sendCommand(EpdCommand.PANEL_SETTING);
    sendData(0x3f); //KW-3f   KWR-2F	BWR-OTP 0f	BW-OTP 1f

    sendCommand(EpdCommand.PLL_CONTROL);
    sendData(0x3c); // 2-0 = 100: N=4; 5-3 = 111: M=7;  3C = 50Hz 3A = 100HZ

    // sendCommand(EpdCommand.DUAL_SPI);
    // sendData(0x00);

    // sendCommand(EpdCommand.VCOM_AND_DATA_INTERVAL_SETTING);
    // sendData(0x10);
    // sendData(0x00);

    // sendCommand(EpdCommand.TCON_SETTING);
    // sendData(0x22);

    // sendCommand(EpdCommand.GSST_SETTING);
    // sendData(0x00);
    // sendData(0x00); //800*480
    // sendData(0x00);
    // sendData(0x00);

    setLut();
  }

  /// Set the Look-Up-Tables
  void setLut() {
    // sendCommand(EpdCommand.LUT_FOR_VCOM);
    // sendDataMulti(lut_vcom0);
    // sendCommand(EpdCommand.LUT_WHITE_TO_WHITE);
    // sendDataMulti(lut_ww);
    // sendCommand(EpdCommand.LUT_BLACK_TO_WHITE);
    // sendDataMulti(lut_bw);
    // sendCommand(EpdCommand.LUT_WHITE_TO_BLACK);
    // sendDataMulti(lut_wb);
    // sendCommand(EpdCommand.LUT_BLACK_TO_BLACK);
    // sendDataMulti(lut_bb);
  }

  /// Set the Look-Up-Tables for quick display (partial refresh)
  void setLutQuick() {
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
    sendData(width & 0xff);
    sendData(height >> 8);
    sendData(height & 0xff);
  }

  /// Refresh and displays a frame
  void displayFrameBuffer([List<int>? frameBuffer]) {
    setResolution(EPD_WIDTH, EPD_HEIGHT);

    sendCommand(EpdCommand.VCM_DC_SETTING);
    sendData(0x12);

    // sendCommand(EpdCommand.VCOM_AND_DATA_INTERVAL_SETTING);
    // sendData(0x97);    //VBDF 17|D7 VBDW 97  VBDB 57  VBDF F7  VBDW 77  VBDB 37  VBDR B7

    if (frameBuffer != null) {
      sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
      int length = (EPD_WIDTH / 8).ceil() * EPD_HEIGHT;
      sendDataFilled(0xff, length); // bit set: white, bit reset: black
      delayMs(2);
      sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
      sendDataMulti(frameBuffer);
      delayMs(2);
    }

    displayFrame();
  }

  // /// Sends the image buffer in RAM to e-Paper and displays
  // void display(List<int> black, List<int> red) {
  //   print('display');
  //   int length = (EPD_WIDTH / 8).ceil() * EPD_HEIGHT;
  //   if (black.length != length || red.length != length) {
  //     throw Exception();
  //   }
  //   sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
  //   sendDataMulti(black);
  //   sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
  //   sendDataMulti(red);
  //   displayFrame();
  // }

  // Clear the frame data from the SRAM (this won't refresh the display!)
  void clearFrame() {
    setResolution(EPD_WIDTH, EPD_HEIGHT);
    int length = (EPD_WIDTH / 8).ceil() * EPD_HEIGHT;
    sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
    delayMs(2);
    sendDataFilled(0xff, length);
    delayMs(2);
    sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
    delayMs(2);
    sendDataFilled(0xff, length);
    delayMs(2);
  }

  // /// Clear screen
  // void clear() {
  //   print('clear');
  //   int length = (EPD_WIDTH / 8).ceil() * EPD_HEIGHT;
  //   sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
  //   sendDataFilled(0xFF, length);
  //   sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
  //   sendDataFilled(0x00, length);
  //   displayFrame();
  // }
  //
  // /// Clear Black screen
  // void clearBlack() {
  //   print('clearBlack');
  //   int length = (EPD_WIDTH / 8).ceil() * EPD_HEIGHT;
  //   sendCommand(EpdCommand.DATA_START_TRANSMISSION_1);
  //   sendDataFilled(0x00, length);
  //   sendCommand(EpdCommand.DATA_START_TRANSMISSION_2);
  //   sendDataFilled(0xFF, length);
  //   displayFrame();
  // }

  /// This displays the frame data from SRAM
  void displayFrame() {
    setLut();
    sendCommand(EpdCommand.DISPLAY_REFRESH);
    delayMs(100);
    waitUntilIdle();
  }

  void displayFrameQuick() {
    setLutQuick();
    sendCommand(EpdCommand.DISPLAY_REFRESH);
    // delayMs(100);
    // waitUntilIdle();
  }

  /// After this command is transmitted, the chip would enter the deep-sleep mode to save power.
  /// The deep sleep mode would return to standby by hardware reset. The only one parameter is a
  /// check code, the command would be executed if check code = 0xA5.
  /// You can use [reset] to awaken and use [init] to initialize.
  void sleep() {
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
    waitUntilIdle();
    sendCommand(EpdCommand.DEEP_SLEEP);
    sendData(0xa5);
  }
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
  TEMPERATURE_SENSOR_SELECTION(0x41),
  TEMPERATURE_SENSOR_WRITE(0x42),
  TEMPERATURE_SENSOR_READ(0x43),
  VCOM_AND_DATA_INTERVAL_SETTING(0x50),
  LOW_POWER_DETECTION(0x51),
  TCON_SETTING(0x60),
  RESOLUTION_SETTING(0x61),
  GSST_SETTING(0x65),
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
  ;

  final int register;

  const EpdCommand(this.register);

  @override
  String toString() => '$name(0x${register.toRadixString(16).padLeft(2, '0')})';
}

// @formatter:off

const lut_vcom0 = <int>[
  0x40, 0x17, 0x00, 0x00, 0x00, 0x02,
  0x00, 0x17, 0x17, 0x00, 0x00, 0x02,
  0x00, 0x0A, 0x01, 0x00, 0x00, 0x01,
  0x00, 0x0E, 0x0E, 0x00, 0x00, 0x02,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_vcom0_quick = <int>[
  0x00, 0x0E, 0x00, 0x00, 0x00, 0x01,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_ww = <int>[
  0x40, 0x17, 0x00, 0x00, 0x00, 0x02,
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02,
  0x40, 0x0A, 0x01, 0x00, 0x00, 0x01,
  0xA0, 0x0E, 0x0E, 0x00, 0x00, 0x02,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_ww_quick = <int>[
  0xA0, 0x0E, 0x00, 0x00, 0x00, 0x01,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_bw = <int>[
  0x40, 0x17, 0x00, 0x00, 0x00, 0x02,
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02,
  0x40, 0x0A, 0x01, 0x00, 0x00, 0x01,
  0xA0, 0x0E, 0x0E, 0x00, 0x00, 0x02,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_bw_quick = <int>[
  0xA0, 0x0E, 0x00, 0x00, 0x00, 0x01,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_bb = <int>[
  0x80, 0x17, 0x00, 0x00, 0x00, 0x02,
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02,
  0x80, 0x0A, 0x01, 0x00, 0x00, 0x01,
  0x50, 0x0E, 0x0E, 0x00, 0x00, 0x02,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_bb_quick = <int>[
  0x50, 0x0E, 0x00, 0x00, 0x00, 0x01,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_wb = <int>[
  0x80, 0x17, 0x00, 0x00, 0x00, 0x02,
  0x90, 0x17, 0x17, 0x00, 0x00, 0x02,
  0x80, 0x0A, 0x01, 0x00, 0x00, 0x01,
  0x50, 0x0E, 0x0E, 0x00, 0x00, 0x02,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

const lut_wb_quick = <int>[
  0x50, 0x0E, 0x00, 0x00, 0x00, 0x01,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
];

// @formatter:on
