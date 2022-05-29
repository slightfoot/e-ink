import 'dart:async';
import 'dart:io' as io;
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:ffi/ffi.dart' as ffi;

import 'package:clock/rpi/gpio.dart';
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
const EPD_7IN5_V2_WIDTH = 800;

/// Display resolution height
const EPD_7IN5_V2_HEIGHT = 480;

class EPaperDisplay {
  EPaperDisplay() {
    _init();
  }

  late final ffi.Pointer<ffi.Uint8> txBuffer;
  late final ffi.Pointer<ffi.Uint8> rxBuffer;
  late final int bufferSize;
  late final Bcm2835 bcm2835;

  //------------------------------------------------------------------------------------------------

  void _init() {
    print('init');

    bufferSize = EPD_7IN5_V2_WIDTH ~/ 8;
    txBuffer = ffi.malloc<ffi.Uint8>(bufferSize);
    rxBuffer = ffi.malloc<ffi.Uint8>(bufferSize);

    bcm2835 = Bcm2835(ffi.DynamicLibrary.open('/usr/local/lib/libbcm2835.so'));

    bcm2835.set_debug(0);

    if (bcm2835.init() == 0) {
      throw Exception('bcm2835 init failed');
    } else {
      print('bcm2835 init success: ${bcm2835.version()}');
    }

    _digitalMode(EPD_RST_PIN, GpioDirection.dirOut);
    _digitalMode(EPD_DC_PIN, GpioDirection.dirOut);
    _digitalMode(EPD_CS_PIN, GpioDirection.dirOut);
    _digitalMode(EPD_BUSY_PIN, GpioDirection.dirIn);
    _digitalWrite(EPD_CS_PIN, true);

    if (bcm2835.spi_begin() == 0) {
      // Start spi interface, set spi pin for the reuse function
      throw Exception('Failed to init spi');
    }
    bcm2835.spi_setBitOrder(SPIBitOrder.SPI_BIT_ORDER_MSBFIRST); // High first transmission
    bcm2835.spi_setDataMode(SPIMode.SPI_MODE0); // spi mode 0
    bcm2835.spi_setClockDivider(
        SPIClockDivider.SPI_CLOCK_DIVIDER_128); //Frequency SPI_CLOCK_DIVIDER_32
    bcm2835.spi_chipSelect(SPIChipSelect.SPI_CS0); //set CE0
    bcm2835.spi_setChipSelectPolarity(SPIChipSelect.SPI_CS0, LOW); //enable cs0
  }

  void close() {
    _digitalWrite(EPD_CS_PIN, false);
    _digitalWrite(EPD_DC_PIN, false);
    _digitalWrite(EPD_RST_PIN, false);

    bcm2835.spi_end();
    bcm2835.close();

    ffi.malloc.free(rxBuffer);
    ffi.malloc.free(txBuffer);
  }

  void _digitalWrite(int pin, bool value) => bcm2835.gpio_write(pin, value ? 1 : 0);

  bool _digitalRead(int pin) => bcm2835.gpio_lev(pin) != 0;

  void _digitalMode(int pin, GpioDirection mode) {
    if (mode == GpioDirection.dirIn) {
      bcm2835.gpio_fsel(pin, FunctionSelect.GPIO_FSEL_INPT);
    } else {
      bcm2835.gpio_fsel(pin, FunctionSelect.GPIO_FSEL_OUTP);
    }
  }

  void delayMs(int ms) => bcm2835.delay(ms);

  Future<void> _spiWriteByte(int value) async {
    bcm2835.spi_transfer(value);
  }

  Future<void> _spiWriteBytes(List<int> bytes) async {
    final result = Uint8List(bytes.length);
    final tx = txBuffer.asTypedList(bufferSize);
    final rx = rxBuffer.asTypedList(bufferSize);
    for (int i = 0; i < bytes.length; i += bufferSize) {
      final length = math.min(bufferSize, bytes.length);
      tx.setAll(0, bytes.getRange(i, length));
      rx.fillRange(0, length, 0);
      bcm2835.spi_transfernb(txBuffer.cast(), rxBuffer.cast(), length);
      result.setRange(i, length, rx);
    }
  }

  //------------------------------------------------------------------------------------------------

  /// Software reset the panel
  void reset() {
    _digitalWrite(EPD_RST_PIN, true);
    delayMs(20);
    _digitalWrite(EPD_RST_PIN, false);
    delayMs(2);
    _digitalWrite(EPD_RST_PIN, true);
    delayMs(20);
  }

  /// Send command to the panel
  void sendCommand(int register) {
    _digitalWrite(EPD_DC_PIN, false);
    _digitalWrite(EPD_CS_PIN, false);
    _spiWriteByte(register);
    _digitalWrite(EPD_CS_PIN, true);
  }

  /// Send data to the panel
  void sendData(int data) {
    _digitalWrite(EPD_DC_PIN, true);
    _digitalWrite(EPD_CS_PIN, false);
    _spiWriteByte(data);
    _digitalWrite(EPD_CS_PIN, true);
  }

  /// Wait until the panel is not busy
  void waitUntilIdle() {
    print("e-Paper busy");
    do {
      delayMs(5);
    } while (!_digitalRead(EPD_BUSY_PIN));
    delayMs(5);
    print("e-Paper busy release");
  }

  /// Send LUT
  void _sendLut(List<int> vcom, List<int> ww, List<int> bw, List<int> wb, List<int> bb) {
    sendCommand(0x20); // VCOM
    for (int count = 0; count < 42; count++) {
      sendData(vcom[count]);
    }
    sendCommand(0x21); // LUTBW
    for (int count = 0; count < 42; count++) {
      sendData(ww[count]);
    }
    sendCommand(0x22); // LUTBW
    for (int count = 0; count < 42; count++) {
      sendData(bw[count]);
    }
    sendCommand(0x23); // LUTWB
    for (int count = 0; count < 42; count++) {
      sendData(wb[count]);
    }
    sendCommand(0x24); // LUTBB
    for (int count = 0; count < 42; count++) {
      sendData(bb[count]);
    }
  }

  // Turn on the display
  void turnOnDisplay() {
    sendCommand(0x12); // DISPLAY REFRESH
    delayMs(100); // The delay here is necessary for at least 200uS!!!
    waitUntilIdle();
  }

  /// Initialize the e-Paper registers
  void init() {
    reset();

    // sendCommand(0x01);			//POWER SETTING
    // EPD_SendData(0x07);
    // EPD_SendData(0x07);		//VGH=20V,VGL=-20V
    // EPD_SendData(0x3f);		//VDH=15V
    // EPD_SendData(0x3f);		//VDL=-15V

    sendCommand(0x01); // power setting
    sendData(0x17); // 1-0=11: internal power
    sendData(Voltage_Frame_7IN5_V2[6]); // VGH&VGL
    sendData(Voltage_Frame_7IN5_V2[1]); // VSH
    sendData(Voltage_Frame_7IN5_V2[2]); //  VSL
    sendData(Voltage_Frame_7IN5_V2[3]); //  VSHR

    sendCommand(0x82); // VCOM DC Setting
    sendData(Voltage_Frame_7IN5_V2[4]); // VCOM

    sendCommand(0x06); // Booster Setting
    sendData(0x27);
    sendData(0x27);
    sendData(0x2F);
    sendData(0x17);

    sendCommand(0x30); // OSC Setting
    sendData(Voltage_Frame_7IN5_V2[0]); // 2-0=100: N=4  ; 5-3=111: M=7  ;  3C=50Hz     3A=100HZ

    sendCommand(0x04); // POWER ON
    delayMs(100);
    waitUntilIdle();

    sendCommand(0x00); // PANEL SETTING
    sendData(0x3F); //KW-3f   KWR-2F	BWR-OTP 0f	BW-OTP 1f

    sendCommand(0x61); //tres
    sendData(0x03); //source 800
    sendData(0x20);
    sendData(0x01); //gate 480
    sendData(0xE0);

    sendCommand(0x15);
    sendData(0x00);

    sendCommand(0x50); //VCOM AND DATA INTERVAL SETTING
    sendData(0x10);
    sendData(0x00);

    sendCommand(0x60); //TCON SETTING
    sendData(0x22);

    sendCommand(0x65); // Resolution setting
    sendData(0x00);
    sendData(0x00); //800*480
    sendData(0x00);
    sendData(0x00);

    _sendLut(LUT_VCOM_7IN5_V2, LUT_WW_7IN5_V2, LUT_BW_7IN5_V2, LUT_WB_7IN5_V2, LUT_BB_7IN5_V2);
  }

  /// Clear screen
  void clear() {
    int width =
        (EPD_7IN5_V2_WIDTH % 8 == 0) ? (EPD_7IN5_V2_WIDTH ~/ 8) : (EPD_7IN5_V2_WIDTH ~/ 8 + 1);
    int height = EPD_7IN5_V2_HEIGHT;
    sendCommand(0x10);
    for (int i = 0; i < height * width; i++) {
      sendData(0xFF);
    }
    sendCommand(0x13);
    for (int i = 0; i < height * width; i++) {
      sendData(0x00);
    }
    turnOnDisplay();
  }

  /// Clear Black screen
  void clearBlack() {
    int width =
        (EPD_7IN5_V2_WIDTH % 8 == 0) ? (EPD_7IN5_V2_WIDTH ~/ 8) : (EPD_7IN5_V2_WIDTH ~/ 8 + 1);
    int height = EPD_7IN5_V2_HEIGHT;
    sendCommand(0x10);
    for (int i = 0; i < height * width; i++) {
      sendData(0x00);
    }
    sendCommand(0x13);
    for (int i = 0; i < height * width; i++) {
      sendData(0xFF);
    }
    turnOnDisplay();
  }

  /// Sends the image buffer in RAM to e-Paper and displays
  void display(List<int> black, List<int> red) {
    int width =
        (EPD_7IN5_V2_WIDTH % 8 == 0) ? (EPD_7IN5_V2_WIDTH ~/ 8) : (EPD_7IN5_V2_WIDTH ~/ 8 + 1);
    int height = EPD_7IN5_V2_HEIGHT;
    sendCommand(0x10);
    for (int j = 0; j < height; j++) {
      for (int i = 0; i < width; i++) {
        sendData(black[i + j * width]);
      }
    }
    sendCommand(0x13);
    for (int j = 0; j < height; j++) {
      for (int i = 0; i < width; i++) {
        sendData(red[i + j * width]);
      }
    }
    turnOnDisplay();
  }

  void sleep() {
    sendCommand(0X02); // power off
    waitUntilIdle();
    sendCommand(0X07); // deep sleep
    sendData(0xA5);
  }
}

// @formatter:off

const Voltage_Frame_7IN5_V2 = <int>[
	0x6, 0x3F, 0x3F, 0x11, 0x24, 0x7, 0x17,
];

const LUT_VCOM_7IN5_V2 = <int>[
	0x0,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x0,	0xF,	0x1,	0xF,	0x1,	0x2,
	0x0,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
];

const LUT_WW_7IN5_V2 = <int>[
	0x10,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x84,	0xF,	0x1,	0xF,	0x1,	0x2,
	0x20,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
];

const LUT_BW_7IN5_V2 = <int>[
	0x10,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x84,	0xF,	0x1,	0xF,	0x1,	0x2,
	0x20,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
];

const LUT_WB_7IN5_V2 = <int>[
	0x80,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x84,	0xF,	0x1,	0xF,	0x1,	0x2,
	0x40,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
];

const LUT_BB_7IN5_V2 = <int>[
	0x80,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x84,	0xF,	0x1,	0xF,	0x1,	0x2,
	0x40,	0xF,	0xF,	0x0,	0x0,	0x1,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
	0x0,	0x0,	0x0,	0x0,	0x0,	0x0,
];

// @formatter:on
