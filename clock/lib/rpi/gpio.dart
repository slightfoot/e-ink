import 'dart:io';

enum GpioDirection {
  dirIn('in'),
  dirOut('out');

  final String value;

  const GpioDirection(this.value);
}

enum GpioValue {
  low(0),
  high(1);

  final int value;

  const GpioValue(this.value);
}

enum GpioPin {
  // General purpose I/O
  gpio0(0),
  gpio1(1),
  gpio2(2),
  gpio3(3),
  gpio4(4),
  gpio5(5),
  gpio6(6),
  gpio7(7),
  gpio8(8),
  gpio9(9),
  gpio10(10),
  gpio11(11),
  gpio12(12),
  gpio13(13),
  gpio14(14),
  gpio15(15),
  gpio16(16),
  gpio17(17),
  gpio18(18),
  gpio19(19),
  gpio20(20),
  gpio21(21),
  gpio22(22),
  gpio23(23),
  gpio24(24),
  gpio25(25),
  gpio26(26),
  gpio27(27),
  // Eeeprom :: Alternative Function
  eepromSda(0),
  eepromScl(1),
  // i2c :: Alternative Function
  i2c1Sda(2),
  i2c1Scl(3),
  // General Purpose Clock :: Alternative Function
  gpClk0(4),
  // Serial Peripheral Interface 0 :: Alternative Function
  spi0Cs1(7),
  spi0Cs0(8),
  spi0Miso(9),
  spi0Mosi(10),
  spi0Sck(11),
  // Serial Peripheral Interface 1 :: Alternative Function
  spi1Cs2(16),
  spi1Cs1(17),
  spi1Cs0(18),
  spi1Miso(19),
  spi1Mosi(20),
  spi1Sck(21),
  // Pulse Width Modulation :: Alternative Function
  pwm0(12),
  pwm1(13),
  // Universal Asynchronous Receiver Transmitter :: Alternative Function
  uartTx(14),
  uartRx(15),
  // Pulse Code Modulation :: Alternative Function
  pcmClk(18),
  pcmFs(19),
  pcmDin(20),
  pcmDout(21),
  ;

  final int value;

  const GpioPin(this.value);
}

void SYSFS_GPIO_Debug(String message) {
  // TODO: disable when not in debug mode
  print('GPIO $message');
}

void SYSFS_GPIO_Export(GpioPin pin) {
  final file = File('/sys/class/gpio/export') //
      .openSync(mode: FileMode.writeOnly);
  file.writeStringSync(pin.value.toString());
  SYSFS_GPIO_Debug('Export: Pin $pin');
  file.closeSync();
}

void SYSFS_GPIO_Unexport(GpioPin pin) {
  RandomAccessFile? file;
  try {
    file = File('/sys/class/gpio/unexport') //
        .openSync(mode: FileMode.writeOnly);
    file.writeStringSync(pin.value.toString());
    SYSFS_GPIO_Debug('Unexport: Pin $pin');
  } finally {
    file?.closeSync();
  }
}

void SYSFS_GPIO_Direction(GpioPin pin, GpioDirection dir) {
  RandomAccessFile? file;
  try {
    file = File('/sys/class/gpio/gpio${pin.value}/direction') //
        .openSync(mode: FileMode.writeOnly);
    file.writeStringSync(dir.value);
    SYSFS_GPIO_Debug('Direction: Pin $pin: $dir');
  } finally {
    file?.closeSync();
  }
}

GpioValue SYSFS_GPIO_Read(GpioPin pin) {
  RandomAccessFile? file;
  try {
    file = File('/sys/class/gpio/gpio${pin.value}/value') //
        .openSync(mode: FileMode.read);
    final data = String.fromCharCodes(file.readSync(3));
    final value = int.parse(data);
    if (value == GpioValue.low.value) {
      return GpioValue.low;
    } else if (value == GpioValue.high.value) {
      return GpioValue.high;
    } else {
      throw Exception('Bad data: $data -> $value');
    }
  } finally {
    file?.closeSync();
  }
}

void SYSFS_GPIO_Write(GpioPin pin, GpioValue value) {
  RandomAccessFile? file;
  try {
    file = File('/sys/class/gpio/gpio${pin.value}/value') //
        .openSync(mode: FileMode.writeOnly);
    final data = value.value.toString().codeUnitAt(0);
    file.writeByteSync(data);
  } finally {
    file?.closeSync();
  }
}
