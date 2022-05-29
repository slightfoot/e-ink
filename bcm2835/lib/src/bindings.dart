import 'dart:ffi' as ffi;

/// BCM2835 Library
class Bcm2835 {
  Bcm2835(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName) _lookup;

  /// Physical address and size of the peripherals block
  /// May be overridden on RPi2
  late final ffi.Pointer<off_t> _peripheralsBase = _lookup<off_t>('bcm2835_peripherals_base');
  int get peripheralsBase => _peripheralsBase.value;
  set peripheralsBase(int value) => _peripheralsBase.value = value;

  /// Size of the peripherals block to be mapped
  late final ffi.Pointer<ffi.Size> _bcm2835PeripheralsSize = _lookup<ffi.Size>('bcm2835_peripherals_size');
  int get peripheralsSize => _bcm2835PeripheralsSize.value;
  set peripheralsSize(int value) => _bcm2835PeripheralsSize.value = value;

  /// ! Virtual memory address of the mapped peripherals block
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835Peripherals = _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_peripherals');
  ffi.Pointer<ffi.Uint32> get peripherals => _bcm2835Peripherals.value;
  set peripherals(ffi.Pointer<ffi.Uint32> value) => _bcm2835Peripherals.value = value;

  /// ! Base of the ST (System Timer) registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_st =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_st');

  ffi.Pointer<ffi.Uint32> get bcm2835_st => _bcm2835_st.value;

  set bcm2835_st(ffi.Pointer<ffi.Uint32> value) => _bcm2835_st.value = value;

  /// ! Base of the GPIO registers.
  /// Available after bcm2835_init has been called
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_gpio =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_gpio');

  ffi.Pointer<ffi.Uint32> get bcm2835_gpio => _bcm2835_gpio.value;

  set bcm2835_gpio(ffi.Pointer<ffi.Uint32> value) =>
      _bcm2835_gpio.value = value;

  /// ! Base of the PWM registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_pwm =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_pwm');

  ffi.Pointer<ffi.Uint32> get bcm2835_pwm => _bcm2835_pwm.value;

  set bcm2835_pwm(ffi.Pointer<ffi.Uint32> value) => _bcm2835_pwm.value = value;

  /// ! Base of the CLK registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_clk =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_clk');

  ffi.Pointer<ffi.Uint32> get bcm2835_clk => _bcm2835_clk.value;

  set bcm2835_clk(ffi.Pointer<ffi.Uint32> value) => _bcm2835_clk.value = value;

  /// ! Base of the PADS registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_pads =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_pads');

  ffi.Pointer<ffi.Uint32> get bcm2835_pads => _bcm2835_pads.value;

  set bcm2835_pads(ffi.Pointer<ffi.Uint32> value) =>
      _bcm2835_pads.value = value;

  /// ! Base of the SPI0 registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_spi0 =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_spi0');

  ffi.Pointer<ffi.Uint32> get bcm2835_spi0 => _bcm2835_spi0.value;

  set bcm2835_spi0(ffi.Pointer<ffi.Uint32> value) =>
      _bcm2835_spi0.value = value;

  /// ! Base of the BSC0 registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_bsc0 =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_bsc0');

  ffi.Pointer<ffi.Uint32> get bcm2835_bsc0 => _bcm2835_bsc0.value;

  set bcm2835_bsc0(ffi.Pointer<ffi.Uint32> value) =>
      _bcm2835_bsc0.value = value;

  /// ! Base of the BSC1 registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_bsc1 =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_bsc1');

  ffi.Pointer<ffi.Uint32> get bcm2835_bsc1 => _bcm2835_bsc1.value;

  set bcm2835_bsc1(ffi.Pointer<ffi.Uint32> value) =>
      _bcm2835_bsc1.value = value;

  /// ! Base of the AUX registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_aux =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_aux');

  ffi.Pointer<ffi.Uint32> get bcm2835_aux => _bcm2835_aux.value;

  set bcm2835_aux(ffi.Pointer<ffi.Uint32> value) => _bcm2835_aux.value = value;

  /// ! Base of the SPI1 registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_spi1 =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_spi1');

  ffi.Pointer<ffi.Uint32> get bcm2835_spi1 => _bcm2835_spi1.value;

  set bcm2835_spi1(ffi.Pointer<ffi.Uint32> value) =>
      _bcm2835_spi1.value = value;

  /// ! Base of SMI registers.
  /// Available after bcm2835_init has been called (as root)
  late final ffi.Pointer<ffi.Pointer<ffi.Uint32>> _bcm2835_smi =
      _lookup<ffi.Pointer<ffi.Uint32>>('bcm2835_smi');

  ffi.Pointer<ffi.Uint32> get bcm2835_smi => _bcm2835_smi.value;

  set bcm2835_smi(ffi.Pointer<ffi.Uint32> value) => _bcm2835_smi.value = value;

  /// ! Initialise the library by opening /dev/mem (if you are root)
  /// or /dev/gpiomem (if you are not)
  /// and getting pointers to the
  /// internal memory for BCM 2835 device registers. You must call this (successfully)
  /// before calling any other
  /// functions in this library (except bcm2835_set_debug).
  /// If bcm2835_init() fails by returning 0,
  /// calling any other function may result in crashes or other failures.
  /// If bcm2835_init() succeeds but you are not running as root, then only gpio operations
  /// are permitted, and calling any other functions may result in crashes or other failures. .
  /// Prints messages to stderr in case of errors.
  /// \return 1 if successful else 0
  int bcm2835_init() {
    return _bcm2835_init();
  }

  late final _bcm2835_initPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('bcm2835_init');
  late final _bcm2835_init = _bcm2835_initPtr.asFunction<int Function()>();

  /// ! Close the library, deallocating any allocated memory and closing /dev/mem
  /// \return 1 if successful else 0
  int bcm2835_close() {
    return _bcm2835_close();
  }

  late final _bcm2835_closePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('bcm2835_close');
  late final _bcm2835_close = _bcm2835_closePtr.asFunction<int Function()>();

  /// ! Sets the debug level of the library.
  /// A value of 1 prevents mapping to /dev/mem, and makes the library print out
  /// what it would do, rather than accessing the GPIO registers.
  /// A value of 0, the default, causes normal operation.
  /// Call this before calling bcm2835_init();
  /// \param[in] debug The new debug level. 1 means debug
  void bcm2835_set_debug(
    int debug,
  ) {
    return _bcm2835_set_debug(
      debug,
    );
  }

  late final _bcm2835_set_debugPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_set_debug');
  late final _bcm2835_set_debug =
      _bcm2835_set_debugPtr.asFunction<void Function(int)>();

  /// ! Returns the version number of the library, same as BCM2835_VERSION
  /// \return the current library version number
  int bcm2835_version() {
    return _bcm2835_version();
  }

  late final _bcm2835_versionPtr =
      _lookup<ffi.NativeFunction<ffi.UnsignedInt Function()>>(
          'bcm2835_version');
  late final _bcm2835_version =
      _bcm2835_versionPtr.asFunction<int Function()>();

  /// ! Gets the base of a register
  /// \param[in] regbase You can use one of the common values BCM2835_REGBASE_*
  /// in \ref bcm2835RegisterBase
  /// \return the register base
  /// \sa Physical Addresses
  ffi.Pointer<ffi.Uint32> bcm2835_regbase(
    int regbase,
  ) {
    return _bcm2835_regbase(
      regbase,
    );
  }

  late final _bcm2835_regbasePtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint32> Function(ffi.Uint8)>>(
          'bcm2835_regbase');
  late final _bcm2835_regbase =
      _bcm2835_regbasePtr.asFunction<ffi.Pointer<ffi.Uint32> Function(int)>();

  /// ! Reads 32 bit value from a peripheral address WITH a memory barrier before and after each read.
  /// This is safe, but slow.  The MB before protects this read from any in-flight reads that didn't
  /// use a MB.  The MB after protects subsequent reads from another peripheral.
  ///
  /// \param[in] paddr Physical address to read from. See BCM2835_GPIO_BASE etc.
  /// \return the value read from the 32 bit register
  /// \sa Physical Addresses
  int bcm2835_peri_read(
    ffi.Pointer<ffi.Uint32> paddr,
  ) {
    return _bcm2835_peri_read(
      paddr,
    );
  }

  late final _bcm2835_peri_readPtr =
      _lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Uint32>)>>(
          'bcm2835_peri_read');
  late final _bcm2835_peri_read =
      _bcm2835_peri_readPtr.asFunction<int Function(ffi.Pointer<ffi.Uint32>)>();

  /// ! Reads 32 bit value from a peripheral address WITHOUT the read barriers
  /// You should only use this when:
  /// o your code has previously called bcm2835_peri_read() for a register
  /// within the same peripheral, and no read or write to another peripheral has occurred since.
  /// o your code has called bcm2835_memory_barrier() since the last access to ANOTHER peripheral.
  ///
  /// \param[in] paddr Physical address to read from. See BCM2835_GPIO_BASE etc.
  /// \return the value read from the 32 bit register
  /// \sa Physical Addresses
  int bcm2835_peri_read_nb(
    ffi.Pointer<ffi.Uint32> paddr,
  ) {
    return _bcm2835_peri_read_nb(
      paddr,
    );
  }

  late final _bcm2835_peri_read_nbPtr =
      _lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Uint32>)>>(
          'bcm2835_peri_read_nb');
  late final _bcm2835_peri_read_nb = _bcm2835_peri_read_nbPtr
      .asFunction<int Function(ffi.Pointer<ffi.Uint32>)>();

  /// ! Writes 32 bit value from a peripheral address WITH a memory barrier before and after each write
  /// This is safe, but slow.  The MB before ensures that any in-flight write to another peripheral
  /// completes before this write is issued.  The MB after ensures that subsequent reads and writes
  /// to another peripheral will see the effect of this write.
  ///
  /// This is a tricky optimization; if you aren't sure, use the barrier version.
  ///
  /// \param[in] paddr Physical address to read from. See BCM2835_GPIO_BASE etc.
  /// \param[in] value The 32 bit value to write
  /// \sa Physical Addresses
  void bcm2835_peri_write(
    ffi.Pointer<ffi.Uint32> paddr,
    int value,
  ) {
    return _bcm2835_peri_write(
      paddr,
      value,
    );
  }

  late final _bcm2835_peri_writePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Uint32>, ffi.Uint32)>>('bcm2835_peri_write');
  late final _bcm2835_peri_write = _bcm2835_peri_writePtr
      .asFunction<void Function(ffi.Pointer<ffi.Uint32>, int)>();

  /// ! Writes 32 bit value from a peripheral address without the write barrier
  /// You should only use this when:
  /// o your code has previously called bcm2835_peri_write() for a register
  /// within the same peripheral, and no other peripheral access has occurred since.
  /// o your code has called bcm2835_memory_barrier() since the last access to ANOTHER peripheral.
  ///
  /// This is a tricky optimization; if you aren't sure, use the barrier version.
  ///
  /// \param[in] paddr Physical address to read from. See BCM2835_GPIO_BASE etc.
  /// \param[in] value The 32 bit value to write
  /// \sa Physical Addresses
  void bcm2835_peri_write_nb(
    ffi.Pointer<ffi.Uint32> paddr,
    int value,
  ) {
    return _bcm2835_peri_write_nb(
      paddr,
      value,
    );
  }

  late final _bcm2835_peri_write_nbPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Uint32>, ffi.Uint32)>>('bcm2835_peri_write_nb');
  late final _bcm2835_peri_write_nb = _bcm2835_peri_write_nbPtr
      .asFunction<void Function(ffi.Pointer<ffi.Uint32>, int)>();

  /// ! Alters a number of bits in a 32 peripheral regsiter.
  /// It reads the current valu and then alters the bits defines as 1 in mask,
  /// according to the bit value in value.
  /// All other bits that are 0 in the mask are unaffected.
  /// Use this to alter a subset of the bits in a register.
  /// Memory barriers are used.  Note that this is not atomic; an interrupt
  /// routine can cause unexpected results.
  /// \param[in] paddr Physical address to read from. See BCM2835_GPIO_BASE etc.
  /// \param[in] value The 32 bit value to write, masked in by mask.
  /// \param[in] mask Bitmask that defines the bits that will be altered in the register.
  /// \sa Physical Addresses
  void bcm2835_peri_set_bits(
    ffi.Pointer<ffi.Uint32> paddr,
    int value,
    int mask,
  ) {
    return _bcm2835_peri_set_bits(
      paddr,
      value,
      mask,
    );
  }

  late final _bcm2835_peri_set_bitsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Uint32>, ffi.Uint32,
              ffi.Uint32)>>('bcm2835_peri_set_bits');
  late final _bcm2835_peri_set_bits = _bcm2835_peri_set_bitsPtr
      .asFunction<void Function(ffi.Pointer<ffi.Uint32>, int, int)>();

  /// ! Sets the Function Select register for the given pin, which configures
  /// the pin as Input, Output or one of the 6 alternate functions.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \param[in] mode Mode to set the pin to, one of BCM2835_GPIO_FSEL_* from \ref bcm2835FunctionSelect
  void bcm2835_gpio_fsel(
    int pin,
    int mode,
  ) {
    return _bcm2835_gpio_fsel(
      pin,
      mode,
    );
  }

  late final _bcm2835_gpio_fselPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint8)>>(
          'bcm2835_gpio_fsel');
  late final _bcm2835_gpio_fsel =
      _bcm2835_gpio_fselPtr.asFunction<void Function(int, int)>();

  /// ! Sets the specified pin output to
  /// HIGH.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \sa bcm2835_gpio_write()
  void bcm2835_gpio_set(
    int pin,
  ) {
    return _bcm2835_gpio_set(
      pin,
    );
  }

  late final _bcm2835_gpio_setPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_set');
  late final _bcm2835_gpio_set =
      _bcm2835_gpio_setPtr.asFunction<void Function(int)>();

  /// ! Sets the specified pin output to
  /// LOW.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \sa bcm2835_gpio_write()
  void bcm2835_gpio_clr(
    int pin,
  ) {
    return _bcm2835_gpio_clr(
      pin,
    );
  }

  late final _bcm2835_gpio_clrPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr');
  late final _bcm2835_gpio_clr =
      _bcm2835_gpio_clrPtr.asFunction<void Function(int)>();

  /// ! Sets any of the first 32 GPIO output pins specified in the mask to
  /// HIGH.
  /// \param[in] mask Mask of pins to affect. Use eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  /// \sa bcm2835_gpio_write_multi()
  void bcm2835_gpio_set_multi(
    int mask,
  ) {
    return _bcm2835_gpio_set_multi(
      mask,
    );
  }

  late final _bcm2835_gpio_set_multiPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32)>>(
          'bcm2835_gpio_set_multi');
  late final _bcm2835_gpio_set_multi =
      _bcm2835_gpio_set_multiPtr.asFunction<void Function(int)>();

  /// ! Sets any of the first 32 GPIO output pins specified in the mask to
  /// LOW.
  /// \param[in] mask Mask of pins to affect. Use eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  /// \sa bcm2835_gpio_write_multi()
  void bcm2835_gpio_clr_multi(
    int mask,
  ) {
    return _bcm2835_gpio_clr_multi(
      mask,
    );
  }

  late final _bcm2835_gpio_clr_multiPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32)>>(
          'bcm2835_gpio_clr_multi');
  late final _bcm2835_gpio_clr_multi =
      _bcm2835_gpio_clr_multiPtr.asFunction<void Function(int)>();

  /// ! Reads the current level on the specified
  /// pin and returns either HIGH or LOW. Works whether or not the pin
  /// is an input or an output.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \return the current level  either HIGH or LOW
  int bcm2835_gpio_lev(
    int pin,
  ) {
    return _bcm2835_gpio_lev(
      pin,
    );
  }

  late final _bcm2835_gpio_levPtr =
      _lookup<ffi.NativeFunction<ffi.Uint8 Function(ffi.Uint8)>>(
          'bcm2835_gpio_lev');
  late final _bcm2835_gpio_lev =
      _bcm2835_gpio_levPtr.asFunction<int Function(int)>();

  /// ! Event Detect Status.
  /// Tests whether the specified pin has detected a level or edge
  /// as requested by bcm2835_gpio_ren(), bcm2835_gpio_fen(), bcm2835_gpio_hen(),
  /// bcm2835_gpio_len(), bcm2835_gpio_aren(), bcm2835_gpio_afen().
  /// Clear the flag for a given pin by calling bcm2835_gpio_set_eds(pin);
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \return HIGH if the event detect status for the given pin is true.
  int bcm2835_gpio_eds(
    int pin,
  ) {
    return _bcm2835_gpio_eds(
      pin,
    );
  }

  late final _bcm2835_gpio_edsPtr =
      _lookup<ffi.NativeFunction<ffi.Uint8 Function(ffi.Uint8)>>(
          'bcm2835_gpio_eds');
  late final _bcm2835_gpio_eds =
      _bcm2835_gpio_edsPtr.asFunction<int Function(int)>();

  /// ! Same as bcm2835_gpio_eds() but checks if any of the pins specified in
  /// the mask have detected a level or edge.
  /// \param[in] mask Mask of pins to check. Use eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  /// \return Mask of pins HIGH if the event detect status for the given pin is true.
  int bcm2835_gpio_eds_multi(
    int mask,
  ) {
    return _bcm2835_gpio_eds_multi(
      mask,
    );
  }

  late final _bcm2835_gpio_eds_multiPtr =
      _lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.Uint32)>>(
          'bcm2835_gpio_eds_multi');
  late final _bcm2835_gpio_eds_multi =
      _bcm2835_gpio_eds_multiPtr.asFunction<int Function(int)>();

  /// ! Sets the Event Detect Status register for a given pin to 1,
  /// which has the effect of clearing the flag. Use this afer seeing
  /// an Event Detect Status on the pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_set_eds(
    int pin,
  ) {
    return _bcm2835_gpio_set_eds(
      pin,
    );
  }

  late final _bcm2835_gpio_set_edsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_set_eds');
  late final _bcm2835_gpio_set_eds =
      _bcm2835_gpio_set_edsPtr.asFunction<void Function(int)>();

  /// ! Same as bcm2835_gpio_set_eds() but clears the flag for any pin which
  /// is set in the mask.
  /// \param[in] mask Mask of pins to clear. Use eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  void bcm2835_gpio_set_eds_multi(
    int mask,
  ) {
    return _bcm2835_gpio_set_eds_multi(
      mask,
    );
  }

  late final _bcm2835_gpio_set_eds_multiPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32)>>(
          'bcm2835_gpio_set_eds_multi');
  late final _bcm2835_gpio_set_eds_multi =
      _bcm2835_gpio_set_eds_multiPtr.asFunction<void Function(int)>();

  /// ! Enable Rising Edge Detect Enable for the specified pin.
  /// When a rising edge is detected, sets the appropriate pin in Event Detect Status.
  /// The GPRENn registers use
  /// synchronous edge detection. This means the input signal is sampled using the
  /// system clock and then it is looking for a ?011? pattern on the sampled signal. This
  /// has the effect of suppressing glitches.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_ren(
    int pin,
  ) {
    return _bcm2835_gpio_ren(
      pin,
    );
  }

  late final _bcm2835_gpio_renPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_ren');
  late final _bcm2835_gpio_ren =
      _bcm2835_gpio_renPtr.asFunction<void Function(int)>();

  /// ! Disable Rising Edge Detect Enable for the specified pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_clr_ren(
    int pin,
  ) {
    return _bcm2835_gpio_clr_ren(
      pin,
    );
  }

  late final _bcm2835_gpio_clr_renPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr_ren');
  late final _bcm2835_gpio_clr_ren =
      _bcm2835_gpio_clr_renPtr.asFunction<void Function(int)>();

  /// ! Enable Falling Edge Detect Enable for the specified pin.
  /// When a falling edge is detected, sets the appropriate pin in Event Detect Status.
  /// The GPRENn registers use
  /// synchronous edge detection. This means the input signal is sampled using the
  /// system clock and then it is looking for a ?100? pattern on the sampled signal. This
  /// has the effect of suppressing glitches.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_fen(
    int pin,
  ) {
    return _bcm2835_gpio_fen(
      pin,
    );
  }

  late final _bcm2835_gpio_fenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_fen');
  late final _bcm2835_gpio_fen =
      _bcm2835_gpio_fenPtr.asFunction<void Function(int)>();

  /// ! Disable Falling Edge Detect Enable for the specified pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_clr_fen(
    int pin,
  ) {
    return _bcm2835_gpio_clr_fen(
      pin,
    );
  }

  late final _bcm2835_gpio_clr_fenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr_fen');
  late final _bcm2835_gpio_clr_fen =
      _bcm2835_gpio_clr_fenPtr.asFunction<void Function(int)>();

  /// ! Enable High Detect Enable for the specified pin.
  /// When a HIGH level is detected on the pin, sets the appropriate pin in Event Detect Status.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_hen(
    int pin,
  ) {
    return _bcm2835_gpio_hen(
      pin,
    );
  }

  late final _bcm2835_gpio_henPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_hen');
  late final _bcm2835_gpio_hen =
      _bcm2835_gpio_henPtr.asFunction<void Function(int)>();

  /// ! Disable High Detect Enable for the specified pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_clr_hen(
    int pin,
  ) {
    return _bcm2835_gpio_clr_hen(
      pin,
    );
  }

  late final _bcm2835_gpio_clr_henPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr_hen');
  late final _bcm2835_gpio_clr_hen =
      _bcm2835_gpio_clr_henPtr.asFunction<void Function(int)>();

  /// ! Enable Low Detect Enable for the specified pin.
  /// When a LOW level is detected on the pin, sets the appropriate pin in Event Detect Status.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_len(
    int pin,
  ) {
    return _bcm2835_gpio_len(
      pin,
    );
  }

  late final _bcm2835_gpio_lenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_len');
  late final _bcm2835_gpio_len =
      _bcm2835_gpio_lenPtr.asFunction<void Function(int)>();

  /// ! Disable Low Detect Enable for the specified pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_clr_len(
    int pin,
  ) {
    return _bcm2835_gpio_clr_len(
      pin,
    );
  }

  late final _bcm2835_gpio_clr_lenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr_len');
  late final _bcm2835_gpio_clr_len =
      _bcm2835_gpio_clr_lenPtr.asFunction<void Function(int)>();

  /// ! Enable Asynchronous Rising Edge Detect Enable for the specified pin.
  /// When a rising edge is detected, sets the appropriate pin in Event Detect Status.
  /// Asynchronous means the incoming signal is not sampled by the system clock. As such
  /// rising edges of very short duration can be detected.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_aren(
    int pin,
  ) {
    return _bcm2835_gpio_aren(
      pin,
    );
  }

  late final _bcm2835_gpio_arenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_aren');
  late final _bcm2835_gpio_aren =
      _bcm2835_gpio_arenPtr.asFunction<void Function(int)>();

  /// ! Disable Asynchronous Rising Edge Detect Enable for the specified pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_clr_aren(
    int pin,
  ) {
    return _bcm2835_gpio_clr_aren(
      pin,
    );
  }

  late final _bcm2835_gpio_clr_arenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr_aren');
  late final _bcm2835_gpio_clr_aren =
      _bcm2835_gpio_clr_arenPtr.asFunction<void Function(int)>();

  /// ! Enable Asynchronous Falling Edge Detect Enable for the specified pin.
  /// When a falling edge is detected, sets the appropriate pin in Event Detect Status.
  /// Asynchronous means the incoming signal is not sampled by the system clock. As such
  /// falling edges of very short duration can be detected.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_afen(
    int pin,
  ) {
    return _bcm2835_gpio_afen(
      pin,
    );
  }

  late final _bcm2835_gpio_afenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_afen');
  late final _bcm2835_gpio_afen =
      _bcm2835_gpio_afenPtr.asFunction<void Function(int)>();

  /// ! Disable Asynchronous Falling Edge Detect Enable for the specified pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  void bcm2835_gpio_clr_afen(
    int pin,
  ) {
    return _bcm2835_gpio_clr_afen(
      pin,
    );
  }

  late final _bcm2835_gpio_clr_afenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_clr_afen');
  late final _bcm2835_gpio_clr_afen =
      _bcm2835_gpio_clr_afenPtr.asFunction<void Function(int)>();

  /// ! Sets the Pull-up/down register for the given pin. This is
  /// used with bcm2835_gpio_pudclk() to set the  Pull-up/down resistor for the given pin.
  /// However, it is usually more convenient to use bcm2835_gpio_set_pud().
  /// \param[in] pud The desired Pull-up/down mode. One of BCM2835_GPIO_PUD_* from bcm2835PUDControl
  /// On the RPI 4, although this function and bcm2835_gpio_pudclk() are supported for backward
  /// compatibility, new code should always use bcm2835_gpio_set_pud().
  /// \sa bcm2835_gpio_set_pud()
  void bcm2835_gpio_pud(
    int pud,
  ) {
    return _bcm2835_gpio_pud(
      pud,
    );
  }

  late final _bcm2835_gpio_pudPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_gpio_pud');
  late final _bcm2835_gpio_pud =
      _bcm2835_gpio_pudPtr.asFunction<void Function(int)>();

  /// ! Clocks the Pull-up/down value set earlier by bcm2835_gpio_pud() into the pin.
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \param[in] on HIGH to clock the value from bcm2835_gpio_pud() into the pin.
  /// LOW to remove the clock.
  ///
  /// On the RPI 4, although this function and bcm2835_gpio_pud() are supported for backward
  /// compatibility, new code should always use bcm2835_gpio_set_pud().
  ///
  /// \sa bcm2835_gpio_set_pud()
  void bcm2835_gpio_pudclk(
    int pin,
    int on1,
  ) {
    return _bcm2835_gpio_pudclk(
      pin,
      on1,
    );
  }

  late final _bcm2835_gpio_pudclkPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint8)>>(
          'bcm2835_gpio_pudclk');
  late final _bcm2835_gpio_pudclk =
      _bcm2835_gpio_pudclkPtr.asFunction<void Function(int, int)>();

  /// ! Reads and returns the Pad Control for the given GPIO group.
  /// Caution: requires root access.
  /// \param[in] group The GPIO pad group number, one of BCM2835_PAD_GROUP_GPIO_*
  /// \return Mask of bits from BCM2835_PAD_* from \ref bcm2835PadGroup
  int bcm2835_gpio_pad(
    int group,
  ) {
    return _bcm2835_gpio_pad(
      group,
    );
  }

  late final _bcm2835_gpio_padPtr =
      _lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.Uint8)>>(
          'bcm2835_gpio_pad');
  late final _bcm2835_gpio_pad =
      _bcm2835_gpio_padPtr.asFunction<int Function(int)>();

  /// ! Sets the Pad Control for the given GPIO group.
  /// Caution: requires root access.
  /// \param[in] group The GPIO pad group number, one of BCM2835_PAD_GROUP_GPIO_*
  /// \param[in] control Mask of bits from BCM2835_PAD_* from \ref bcm2835PadGroup. Note
  /// that it is not necessary to include BCM2835_PAD_PASSWRD in the mask as this
  /// is automatically included.
  void bcm2835_gpio_set_pad(
    int group,
    int control,
  ) {
    return _bcm2835_gpio_set_pad(
      group,
      control,
    );
  }

  late final _bcm2835_gpio_set_padPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint32)>>(
          'bcm2835_gpio_set_pad');
  late final _bcm2835_gpio_set_pad =
      _bcm2835_gpio_set_padPtr.asFunction<void Function(int, int)>();

  /// ! Delays for the specified number of milliseconds.
  /// Uses nanosleep(), and therefore does not use CPU until the time is up.
  /// However, you are at the mercy of nanosleep(). From the manual for nanosleep():
  /// If the interval specified in req is not an exact multiple of the granularity
  /// underlying  clock  (see  time(7)),  then the interval will be
  /// rounded up to the next multiple. Furthermore, after the sleep completes,
  /// there may still be a delay before the CPU becomes free to once
  /// again execute the calling thread.
  /// \param[in] millis Delay in milliseconds
  void bcm2835_delay(
    int millis,
  ) {
    return _bcm2835_delay(
      millis,
    );
  }

  late final _bcm2835_delayPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UnsignedInt)>>(
          'bcm2835_delay');
  late final _bcm2835_delay =
      _bcm2835_delayPtr.asFunction<void Function(int)>();

  /// ! Delays for the specified number of microseconds.
  /// Uses a combination of nanosleep() and a busy wait loop on the BCM2835 system timers,
  /// However, you are at the mercy of nanosleep(). From the manual for nanosleep():
  /// If the interval specified in req is not an exact multiple of the granularity
  /// underlying  clock  (see  time(7)),  then the interval will be
  /// rounded up to the next multiple. Furthermore, after the sleep completes,
  /// there may still be a delay before the CPU becomes free to once
  /// again execute the calling thread.
  /// For times less than about 450 microseconds, uses a busy wait on the System Timer.
  /// It is reported that a delay of 0 microseconds on RaspberryPi will in fact
  /// result in a delay of about 80 microseconds. Your mileage may vary.
  /// \param[in] micros Delay in microseconds
  void bcm2835_delayMicroseconds(
    int micros,
  ) {
    return _bcm2835_delayMicroseconds(
      micros,
    );
  }

  late final _bcm2835_delayMicrosecondsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint64)>>(
          'bcm2835_delayMicroseconds');
  late final _bcm2835_delayMicroseconds =
      _bcm2835_delayMicrosecondsPtr.asFunction<void Function(int)>();

  /// ! Sets the output state of the specified pin
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \param[in] on HIGH sets the output to HIGH and LOW to LOW.
  void bcm2835_gpio_write(
    int pin,
    int on1,
  ) {
    return _bcm2835_gpio_write(
      pin,
      on1,
    );
  }

  late final _bcm2835_gpio_writePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint8)>>(
          'bcm2835_gpio_write');
  late final _bcm2835_gpio_write =
      _bcm2835_gpio_writePtr.asFunction<void Function(int, int)>();

  /// ! Sets any of the first 32 GPIO output pins specified in the mask to the state given by on
  /// \param[in] mask Mask of pins to affect. Use eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  /// \param[in] on HIGH sets the output to HIGH and LOW to LOW.
  void bcm2835_gpio_write_multi(
    int mask,
    int on1,
  ) {
    return _bcm2835_gpio_write_multi(
      mask,
      on1,
    );
  }

  late final _bcm2835_gpio_write_multiPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32, ffi.Uint8)>>(
          'bcm2835_gpio_write_multi');
  late final _bcm2835_gpio_write_multi =
      _bcm2835_gpio_write_multiPtr.asFunction<void Function(int, int)>();

  /// ! Sets the first 32 GPIO output pins specified in the mask to the value given by value
  /// \param[in] value values required for each bit masked in by mask, eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  /// \param[in] mask Mask of pins to affect. Use eg: (1 << RPI_GPIO_P1_03) | (1 << RPI_GPIO_P1_05)
  void bcm2835_gpio_write_mask(
    int value,
    int mask,
  ) {
    return _bcm2835_gpio_write_mask(
      value,
      mask,
    );
  }

  late final _bcm2835_gpio_write_maskPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32, ffi.Uint32)>>(
          'bcm2835_gpio_write_mask');
  late final _bcm2835_gpio_write_mask =
      _bcm2835_gpio_write_maskPtr.asFunction<void Function(int, int)>();

  /// ! Sets the Pull-up/down mode for the specified pin. This is more convenient than
  /// clocking the mode in with bcm2835_gpio_pud() and bcm2835_gpio_pudclk().
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  /// \param[in] pud The desired Pull-up/down mode. One of BCM2835_GPIO_PUD_* from bcm2835PUDControl
  void bcm2835_gpio_set_pud(
    int pin,
    int pud,
  ) {
    return _bcm2835_gpio_set_pud(
      pin,
      pud,
    );
  }

  late final _bcm2835_gpio_set_pudPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint8)>>(
          'bcm2835_gpio_set_pud');
  late final _bcm2835_gpio_set_pud =
      _bcm2835_gpio_set_pudPtr.asFunction<void Function(int, int)>();

  /// ! On the BCM2711 based RPI 4, gets the current Pull-up/down mode for the specified pin.
  /// Returns one of BCM2835_GPIO_PUD_* from bcm2835PUDControl.
  /// On earlier RPI versions not based on the BCM2711, returns BCM2835_GPIO_PUD_ERROR
  /// \param[in] pin GPIO number, or one of RPI_GPIO_P1_* from \ref RPiGPIOPin.
  int bcm2835_gpio_get_pud(
    int pin,
  ) {
    return _bcm2835_gpio_get_pud(
      pin,
    );
  }

  late final _bcm2835_gpio_get_pudPtr =
      _lookup<ffi.NativeFunction<ffi.Uint8 Function(ffi.Uint8)>>(
          'bcm2835_gpio_get_pud');
  late final _bcm2835_gpio_get_pud =
      _bcm2835_gpio_get_pudPtr.asFunction<int Function(int)>();

  /// ! Start SPI operations.
  /// Forces RPi SPI0 pins P1-19 (MOSI), P1-21 (MISO), P1-23 (CLK), P1-24 (CE0) and P1-26 (CE1)
  /// to alternate function ALT0, which enables those pins for SPI interface.
  /// You should call bcm2835_spi_end() when all SPI funcitons are complete to return the pins to
  /// their default functions.
  /// \sa  bcm2835_spi_end()
  /// \return 1 if successful, 0 otherwise (perhaps because you are not running as root)
  int bcm2835_spi_begin() {
    return _bcm2835_spi_begin();
  }

  late final _bcm2835_spi_beginPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('bcm2835_spi_begin');
  late final _bcm2835_spi_begin =
      _bcm2835_spi_beginPtr.asFunction<int Function()>();

  /// ! End SPI operations.
  /// SPI0 pins P1-19 (MOSI), P1-21 (MISO), P1-23 (CLK), P1-24 (CE0) and P1-26 (CE1)
  /// are returned to their default INPUT behaviour.
  void bcm2835_spi_end() {
    return _bcm2835_spi_end();
  }

  late final _bcm2835_spi_endPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('bcm2835_spi_end');
  late final _bcm2835_spi_end =
      _bcm2835_spi_endPtr.asFunction<void Function()>();

  /// ! Sets the SPI bit order
  /// Set the bit order to be used for transmit and receive. The bcm2835 SPI0 only supports BCM2835_SPI_BIT_ORDER_MSB,
  /// so if you select BCM2835_SPI_BIT_ORDER_LSB, the bytes will be reversed in software.
  /// The library defaults to BCM2835_SPI_BIT_ORDER_MSB.
  /// \param[in] order The desired bit order, one of BCM2835_SPI_BIT_ORDER_*,
  /// see \ref bcm2835SPIBitOrder
  void bcm2835_spi_setBitOrder(
    int order,
  ) {
    return _bcm2835_spi_setBitOrder(
      order,
    );
  }

  late final _bcm2835_spi_setBitOrderPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_spi_setBitOrder');
  late final _bcm2835_spi_setBitOrder =
      _bcm2835_spi_setBitOrderPtr.asFunction<void Function(int)>();

  /// ! Sets the SPI clock divider and therefore the
  /// SPI clock speed.
  /// \param[in] divider The desired SPI clock divider, one of BCM2835_SPI_CLOCK_DIVIDER_*,
  /// see \ref bcm2835SPIClockDivider
  void bcm2835_spi_setClockDivider(
    int divider,
  ) {
    return _bcm2835_spi_setClockDivider(
      divider,
    );
  }

  late final _bcm2835_spi_setClockDividerPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint16)>>(
          'bcm2835_spi_setClockDivider');
  late final _bcm2835_spi_setClockDivider =
      _bcm2835_spi_setClockDividerPtr.asFunction<void Function(int)>();

  /// ! Sets the SPI clock divider by converting the speed parameter to
  /// the equivalent SPI clock divider. ( see \sa bcm2835_spi_setClockDivider)
  /// \param[in] speed_hz The desired SPI clock speed in Hz
  void bcm2835_spi_set_speed_hz(
    int speed_hz,
  ) {
    return _bcm2835_spi_set_speed_hz(
      speed_hz,
    );
  }

  late final _bcm2835_spi_set_speed_hzPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32)>>(
          'bcm2835_spi_set_speed_hz');
  late final _bcm2835_spi_set_speed_hz =
      _bcm2835_spi_set_speed_hzPtr.asFunction<void Function(int)>();

  /// ! Sets the SPI data mode
  /// Sets the clock polariy and phase
  /// \param[in] mode The desired data mode, one of BCM2835_SPI_MODE*,
  /// see \ref bcm2835SPIMode
  void bcm2835_spi_setDataMode(
    int mode,
  ) {
    return _bcm2835_spi_setDataMode(
      mode,
    );
  }

  late final _bcm2835_spi_setDataModePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_spi_setDataMode');
  late final _bcm2835_spi_setDataMode =
      _bcm2835_spi_setDataModePtr.asFunction<void Function(int)>();

  /// ! Sets the chip select pin(s)
  /// When an bcm2835_spi_transfer() is made, the selected pin(s) will be asserted during the
  /// transfer.
  /// \param[in] cs Specifies the CS pins(s) that are used to activate the desired slave.
  /// One of BCM2835_SPI_CS*, see \ref bcm2835SPIChipSelect
  void bcm2835_spi_chipSelect(
    int cs,
  ) {
    return _bcm2835_spi_chipSelect(
      cs,
    );
  }

  late final _bcm2835_spi_chipSelectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_spi_chipSelect');
  late final _bcm2835_spi_chipSelect =
      _bcm2835_spi_chipSelectPtr.asFunction<void Function(int)>();

  /// ! Sets the chip select pin polarity for a given pin
  /// When an bcm2835_spi_transfer() occurs, the currently selected chip select pin(s)
  /// will be asserted to the
  /// value given by active. When transfers are not happening, the chip select pin(s)
  /// return to the complement (inactive) value.
  /// \param[in] cs The chip select pin to affect
  /// \param[in] active Whether the chip select pin is to be active HIGH
  void bcm2835_spi_setChipSelectPolarity(
    int cs,
    int active,
  ) {
    return _bcm2835_spi_setChipSelectPolarity(
      cs,
      active,
    );
  }

  late final _bcm2835_spi_setChipSelectPolarityPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint8)>>(
          'bcm2835_spi_setChipSelectPolarity');
  late final _bcm2835_spi_setChipSelectPolarity =
      _bcm2835_spi_setChipSelectPolarityPtr
          .asFunction<void Function(int, int)>();

  /// ! Transfers one byte to and from the currently selected SPI slave.
  /// Asserts the currently selected CS pins (as previously set by bcm2835_spi_chipSelect)
  /// during the transfer.
  /// Clocks the 8 bit value out on MOSI, and simultaneously clocks in data from MISO.
  /// Returns the read data byte from the slave.
  /// Uses polled transfer as per section 10.6.1 of the BCM 2835 ARM Peripherls manual
  /// \param[in] value The 8 bit data byte to write to MOSI
  /// \return The 8 bit byte simultaneously read from  MISO
  /// \sa bcm2835_spi_transfern()
  int bcm2835_spi_transfer(
    int value,
  ) {
    return _bcm2835_spi_transfer(
      value,
    );
  }

  late final _bcm2835_spi_transferPtr =
      _lookup<ffi.NativeFunction<ffi.Uint8 Function(ffi.Uint8)>>(
          'bcm2835_spi_transfer');
  late final _bcm2835_spi_transfer =
      _bcm2835_spi_transferPtr.asFunction<int Function(int)>();

  /// ! Transfers any number of bytes to and from the currently selected SPI slave.
  /// Asserts the currently selected CS pins (as previously set by bcm2835_spi_chipSelect)
  /// during the transfer.
  /// Clocks the len 8 bit bytes out on MOSI, and simultaneously clocks in data from MISO.
  /// The data read read from the slave is placed into rbuf. rbuf must be at least len bytes long
  /// Uses polled transfer as per section 10.6.1 of the BCM 2835 ARM Peripherls manual
  /// \param[in] tbuf Buffer of bytes to send.
  /// \param[out] rbuf Received bytes will by put in this buffer
  /// \param[in] len Number of bytes in the tbuf buffer, and the number of bytes to send/received
  /// \sa bcm2835_spi_transfer()
  void bcm2835_spi_transfernb(
    ffi.Pointer<ffi.Char> tbuf,
    ffi.Pointer<ffi.Char> rbuf,
    int len,
  ) {
    return _bcm2835_spi_transfernb(
      tbuf,
      rbuf,
      len,
    );
  }

  late final _bcm2835_spi_transfernbPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Uint32)>>('bcm2835_spi_transfernb');
  late final _bcm2835_spi_transfernb = _bcm2835_spi_transfernbPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers any number of bytes to and from the currently selected SPI slave
  /// using bcm2835_spi_transfernb.
  /// The returned data from the slave replaces the transmitted data in the buffer.
  /// \param[in,out] buf Buffer of bytes to send. Received bytes will replace the contents
  /// \param[in] len Number of bytes int eh buffer, and the number of bytes to send/received
  /// \sa bcm2835_spi_transfer()
  void bcm2835_spi_transfern(
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_spi_transfern(
      buf,
      len,
    );
  }

  late final _bcm2835_spi_transfernPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_spi_transfern');
  late final _bcm2835_spi_transfern = _bcm2835_spi_transfernPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers any number of bytes to the currently selected SPI slave.
  /// Asserts the currently selected CS pins (as previously set by bcm2835_spi_chipSelect)
  /// during the transfer.
  /// \param[in] buf Buffer of bytes to send.
  /// \param[in] len Number of bytes in the buf buffer, and the number of bytes to send
  void bcm2835_spi_writenb(
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_spi_writenb(
      buf,
      len,
    );
  }

  late final _bcm2835_spi_writenbPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_spi_writenb');
  late final _bcm2835_spi_writenb = _bcm2835_spi_writenbPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers half-word to the currently selected SPI slave.
  /// Asserts the currently selected CS pins (as previously set by bcm2835_spi_chipSelect)
  /// during the transfer.
  /// Clocks the 8 bit value out on MOSI, and simultaneously clocks in data from MISO.
  /// Uses polled transfer as per section 10.6.1 of the BCM 2835 ARM Peripherls manual
  /// \param[in] data The 8 bit data byte to write to MOSI
  /// \sa bcm2835_spi_writenb()
  void bcm2835_spi_write(
    int data,
  ) {
    return _bcm2835_spi_write(
      data,
    );
  }

  late final _bcm2835_spi_writePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint16)>>(
          'bcm2835_spi_write');
  late final _bcm2835_spi_write =
      _bcm2835_spi_writePtr.asFunction<void Function(int)>();

  /// ! Start AUX SPI operations.
  /// Forces RPi AUX SPI pins P1-38 (MOSI), P1-38 (MISO), P1-40 (CLK) and P1-36 (CE2)
  /// to alternate function ALT4, which enables those pins for SPI interface.
  /// \return 1 if successful, 0 otherwise (perhaps because you are not running as root)
  int bcm2835_aux_spi_begin() {
    return _bcm2835_aux_spi_begin();
  }

  late final _bcm2835_aux_spi_beginPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('bcm2835_aux_spi_begin');
  late final _bcm2835_aux_spi_begin =
      _bcm2835_aux_spi_beginPtr.asFunction<int Function()>();

  /// ! End AUX SPI operations.
  /// SPI1 pins P1-38 (MOSI), P1-38 (MISO), P1-40 (CLK) and P1-36 (CE2)
  /// are returned to their default INPUT behaviour.
  void bcm2835_aux_spi_end() {
    return _bcm2835_aux_spi_end();
  }

  late final _bcm2835_aux_spi_endPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('bcm2835_aux_spi_end');
  late final _bcm2835_aux_spi_end =
      _bcm2835_aux_spi_endPtr.asFunction<void Function()>();

  /// ! Sets the AUX SPI clock divider and therefore the AUX SPI clock speed.
  /// \param[in] divider The desired AUX SPI clock divider.
  void bcm2835_aux_spi_setClockDivider(
    int divider,
  ) {
    return _bcm2835_aux_spi_setClockDivider(
      divider,
    );
  }

  late final _bcm2835_aux_spi_setClockDividerPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint16)>>(
          'bcm2835_aux_spi_setClockDivider');
  late final _bcm2835_aux_spi_setClockDivider =
      _bcm2835_aux_spi_setClockDividerPtr.asFunction<void Function(int)>();

  /// !
  /// Calculates the input for \sa bcm2835_aux_spi_setClockDivider
  /// @param speed_hz A value between \sa BCM2835_AUX_SPI_CLOCK_MIN and \sa BCM2835_AUX_SPI_CLOCK_MAX
  /// @return Input for \sa bcm2835_aux_spi_setClockDivider
  int bcm2835_aux_spi_CalcClockDivider(
    int speed_hz,
  ) {
    return _bcm2835_aux_spi_CalcClockDivider(
      speed_hz,
    );
  }

  late final _bcm2835_aux_spi_CalcClockDividerPtr =
      _lookup<ffi.NativeFunction<ffi.Uint16 Function(ffi.Uint32)>>(
          'bcm2835_aux_spi_CalcClockDivider');
  late final _bcm2835_aux_spi_CalcClockDivider =
      _bcm2835_aux_spi_CalcClockDividerPtr.asFunction<int Function(int)>();

  /// ! Transfers half-word to the AUX SPI slave.
  /// Asserts the currently selected CS pins during the transfer.
  /// \param[in] data The 8 bit data byte to write to MOSI
  /// \return The 16 bit byte simultaneously read from  MISO
  /// \sa bcm2835_spi_transfern()
  void bcm2835_aux_spi_write(
    int data,
  ) {
    return _bcm2835_aux_spi_write(
      data,
    );
  }

  late final _bcm2835_aux_spi_writePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint16)>>(
          'bcm2835_aux_spi_write');
  late final _bcm2835_aux_spi_write =
      _bcm2835_aux_spi_writePtr.asFunction<void Function(int)>();

  /// ! Transfers any number of bytes to the AUX SPI slave.
  /// Asserts the CE2 pin during the transfer.
  /// \param[in] buf Buffer of bytes to send.
  /// \param[in] len Number of bytes in the tbuf buffer, and the number of bytes to send
  void bcm2835_aux_spi_writenb(
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_aux_spi_writenb(
      buf,
      len,
    );
  }

  late final _bcm2835_aux_spi_writenbPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_aux_spi_writenb');
  late final _bcm2835_aux_spi_writenb = _bcm2835_aux_spi_writenbPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers any number of bytes to and from the AUX SPI slave
  /// using bcm2835_aux_spi_transfernb.
  /// The returned data from the slave replaces the transmitted data in the buffer.
  /// \param[in,out] buf Buffer of bytes to send. Received bytes will replace the contents
  /// \param[in] len Number of bytes in the buffer, and the number of bytes to send/received
  /// \sa bcm2835_aux_spi_transfer()
  void bcm2835_aux_spi_transfern(
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_aux_spi_transfern(
      buf,
      len,
    );
  }

  late final _bcm2835_aux_spi_transfernPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_aux_spi_transfern');
  late final _bcm2835_aux_spi_transfern = _bcm2835_aux_spi_transfernPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers any number of bytes to and from the AUX SPI slave.
  /// Asserts the CE2 pin during the transfer.
  /// Clocks the len 8 bit bytes out on MOSI, and simultaneously clocks in data from MISO.
  /// The data read read from the slave is placed into rbuf. rbuf must be at least len bytes long
  /// \param[in] tbuf Buffer of bytes to send.
  /// \param[out] rbuf Received bytes will by put in this buffer
  /// \param[in] len Number of bytes in the tbuf buffer, and the number of bytes to send/received
  void bcm2835_aux_spi_transfernb(
    ffi.Pointer<ffi.Char> tbuf,
    ffi.Pointer<ffi.Char> rbuf,
    int len,
  ) {
    return _bcm2835_aux_spi_transfernb(
      tbuf,
      rbuf,
      len,
    );
  }

  late final _bcm2835_aux_spi_transfernbPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Uint32)>>('bcm2835_aux_spi_transfernb');
  late final _bcm2835_aux_spi_transfernb =
      _bcm2835_aux_spi_transfernbPtr.asFunction<
          void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers one byte to and from the AUX SPI slave.
  /// Clocks the 8 bit value out on MOSI, and simultaneously clocks in data from MISO.
  /// Returns the read data byte from the slave.
  /// \param[in] value The 8 bit data byte to write to MOSI
  /// \return The 8 bit byte simultaneously read from MISO
  /// \sa bcm2835_aux_spi_transfern()
  int bcm2835_aux_spi_transfer(
    int value,
  ) {
    return _bcm2835_aux_spi_transfer(
      value,
    );
  }

  late final _bcm2835_aux_spi_transferPtr =
      _lookup<ffi.NativeFunction<ffi.Uint8 Function(ffi.Uint8)>>(
          'bcm2835_aux_spi_transfer');
  late final _bcm2835_aux_spi_transfer =
      _bcm2835_aux_spi_transferPtr.asFunction<int Function(int)>();

  /// ! Start I2C operations.
  /// Forces RPi I2C pins P1-03 (SDA) and P1-05 (SCL)
  /// to alternate function ALT0, which enables those pins for I2C interface.
  /// You should call bcm2835_i2c_end() when all I2C functions are complete to return the pins to
  /// their default functions
  /// \return 1 if successful, 0 otherwise (perhaps because you are not running as root)
  /// \sa  bcm2835_i2c_end()
  int bcm2835_i2c_begin() {
    return _bcm2835_i2c_begin();
  }

  late final _bcm2835_i2c_beginPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('bcm2835_i2c_begin');
  late final _bcm2835_i2c_begin =
      _bcm2835_i2c_beginPtr.asFunction<int Function()>();

  /// ! End I2C operations.
  /// I2C pins P1-03 (SDA) and P1-05 (SCL)
  /// are returned to their default INPUT behaviour.
  void bcm2835_i2c_end() {
    return _bcm2835_i2c_end();
  }

  late final _bcm2835_i2c_endPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('bcm2835_i2c_end');
  late final _bcm2835_i2c_end =
      _bcm2835_i2c_endPtr.asFunction<void Function()>();

  /// ! Sets the I2C slave address.
  /// \param[in] addr The I2C slave address.
  void bcm2835_i2c_setSlaveAddress(
    int addr,
  ) {
    return _bcm2835_i2c_setSlaveAddress(
      addr,
    );
  }

  late final _bcm2835_i2c_setSlaveAddressPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8)>>(
          'bcm2835_i2c_setSlaveAddress');
  late final _bcm2835_i2c_setSlaveAddress =
      _bcm2835_i2c_setSlaveAddressPtr.asFunction<void Function(int)>();

  /// ! Sets the I2C clock divider and therefore the I2C clock speed.
  /// \param[in] divider The desired I2C clock divider, one of BCM2835_I2C_CLOCK_DIVIDER_*,
  /// see \ref bcm2835I2CClockDivider
  void bcm2835_i2c_setClockDivider(
    int divider,
  ) {
    return _bcm2835_i2c_setClockDivider(
      divider,
    );
  }

  late final _bcm2835_i2c_setClockDividerPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint16)>>(
          'bcm2835_i2c_setClockDivider');
  late final _bcm2835_i2c_setClockDivider =
      _bcm2835_i2c_setClockDividerPtr.asFunction<void Function(int)>();

  /// ! Sets the I2C clock divider by converting the baudrate parameter to
  /// the equivalent I2C clock divider. ( see \sa bcm2835_i2c_setClockDivider)
  /// For the I2C standard 100khz you would set baudrate to 100000
  /// The use of baudrate corresponds to its use in the I2C kernel device
  /// driver. (Of course, bcm2835 has nothing to do with the kernel driver)
  void bcm2835_i2c_set_baudrate(
    int baudrate,
  ) {
    return _bcm2835_i2c_set_baudrate(
      baudrate,
    );
  }

  late final _bcm2835_i2c_set_baudratePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32)>>(
          'bcm2835_i2c_set_baudrate');
  late final _bcm2835_i2c_set_baudrate =
      _bcm2835_i2c_set_baudratePtr.asFunction<void Function(int)>();

  /// ! Transfers any number of bytes to the currently selected I2C slave.
  /// (as previously set by \sa bcm2835_i2c_setSlaveAddress)
  /// \param[in] buf Buffer of bytes to send.
  /// \param[in] len Number of bytes in the buf buffer, and the number of bytes to send.
  /// \return reason see \ref bcm2835I2CReasonCodes
  int bcm2835_i2c_write(
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_i2c_write(
      buf,
      len,
    );
  }

  late final _bcm2835_i2c_writePtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint8 Function(
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_i2c_write');
  late final _bcm2835_i2c_write = _bcm2835_i2c_writePtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, int)>();

  /// ! Transfers any number of bytes from the currently selected I2C slave.
  /// (as previously set by \sa bcm2835_i2c_setSlaveAddress)
  /// \param[in] buf Buffer of bytes to receive.
  /// \param[in] len Number of bytes in the buf buffer, and the number of bytes to received.
  /// \return reason see \ref bcm2835I2CReasonCodes
  int bcm2835_i2c_read(
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_i2c_read(
      buf,
      len,
    );
  }

  late final _bcm2835_i2c_readPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint8 Function(
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_i2c_read');
  late final _bcm2835_i2c_read = _bcm2835_i2c_readPtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, int)>();

  /// ! Allows reading from I2C slaves that require a repeated start (without any prior stop)
  /// to read after the required slave register has been set. For example, the popular
  /// MPL3115A2 pressure and temperature sensor. Note that your device must support or
  /// require this mode. If your device does not require this mode then the standard
  /// combined:
  /// \sa bcm2835_i2c_write
  /// \sa bcm2835_i2c_read
  /// are a better choice.
  /// Will read from the slave previously set by \sa bcm2835_i2c_setSlaveAddress
  /// \param[in] regaddr Buffer containing the slave register you wish to read from.
  /// \param[in] buf Buffer of bytes to receive.
  /// \param[in] len Number of bytes in the buf buffer, and the number of bytes to received.
  /// \return reason see \ref bcm2835I2CReasonCodes
  int bcm2835_i2c_read_register_rs(
    ffi.Pointer<ffi.Char> regaddr,
    ffi.Pointer<ffi.Char> buf,
    int len,
  ) {
    return _bcm2835_i2c_read_register_rs(
      regaddr,
      buf,
      len,
    );
  }

  late final _bcm2835_i2c_read_register_rsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint8 Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Uint32)>>('bcm2835_i2c_read_register_rs');
  late final _bcm2835_i2c_read_register_rs =
      _bcm2835_i2c_read_register_rsPtr.asFunction<
          int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int)>();

  /// ! Allows sending an arbitrary number of bytes to I2C slaves before issuing a repeated
  /// start (with no prior stop) and reading a response.
  /// Necessary for devices that require such behavior, such as the MLX90620.
  /// Will write to and read from the slave previously set by \sa bcm2835_i2c_setSlaveAddress
  /// \param[in] cmds Buffer containing the bytes to send before the repeated start condition.
  /// \param[in] cmds_len Number of bytes to send from cmds buffer
  /// \param[in] buf Buffer of bytes to receive.
  /// \param[in] buf_len Number of bytes to receive in the buf buffer.
  /// \return reason see \ref bcm2835I2CReasonCodes
  int bcm2835_i2c_write_read_rs(
    ffi.Pointer<ffi.Char> cmds,
    int cmds_len,
    ffi.Pointer<ffi.Char> buf,
    int buf_len,
  ) {
    return _bcm2835_i2c_write_read_rs(
      cmds,
      cmds_len,
      buf,
      buf_len,
    );
  }

  late final _bcm2835_i2c_write_read_rsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint8 Function(ffi.Pointer<ffi.Char>, ffi.Uint32,
              ffi.Pointer<ffi.Char>, ffi.Uint32)>>('bcm2835_i2c_write_read_rs');
  late final _bcm2835_i2c_write_read_rs =
      _bcm2835_i2c_write_read_rsPtr.asFunction<
          int Function(
              ffi.Pointer<ffi.Char>, int, ffi.Pointer<ffi.Char>, int)>();

  /// ! \defgroup smi SMI bus support
  /// Allows access to SMI bus
  /// @{
  /// /
  /// /*! Start SMI operations.
  /// Forces RPi SMI pins P1-19 (MOSI), P1-21 (MISO), P1-23 (CLK), P1-24 (CE0) and P1-26 (CE1)
  /// to alternate function ALT1, which enables those pins for SMI interface.
  /// You should call bcm2835_smi_end() when all SMI functions are complete to return the pins to
  /// their default functions.
  /// Only address bits SA0 to SA3 are available as RPi uses GPIO0 (SA5) and GPIO1 (SA4) for I2C
  /// HAT identification EEPROM access
  /// \sa  bcm2835_smi_end()
  /// \return 1 if successful, 0 otherwise (perhaps because you are not running as root)
  int bcm2835_smi_begin() {
    return _bcm2835_smi_begin();
  }

  late final _bcm2835_smi_beginPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('bcm2835_smi_begin');
  late final _bcm2835_smi_begin =
      _bcm2835_smi_beginPtr.asFunction<int Function()>();

  /// ! End SMI operations.
  /// SMI pins P1-19 (MOSI), P1-21 (MISO), P1-23 (CLK), P1-24 (CE0) and P1-26 (CE1)
  /// are returned to their default INPUT behaviour.
  void bcm2835_smi_end() {
    return _bcm2835_smi_end();
  }

  late final _bcm2835_smi_endPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('bcm2835_smi_end');
  late final _bcm2835_smi_end =
      _bcm2835_smi_endPtr.asFunction<void Function()>();

  /// ! Setup SMI bus cycle timing parameters
  /// There are four SMI channels for read operation and four channels for write operation
  /// Cycles are expressed as multiple of 8ns
  /// Note that Pace cycles are not used (no effect on hardware) but they are required for
  /// configuration. It is recommended to set this value to 1 (and not 0) to have the
  /// smallest cycle in case the hardware would recognize it
  /// \param[in] smichannel SMI configuration slot to setup (0 to 3)
  /// \param[in] readchannel Set to 1 to configure the read channel (0 = configure write channel)
  /// \param[in] setupcycles Time between address assertion on bus and OE/WR signal assertion
  /// \param[in] strobecycles Duration of OE/WR signal assertion
  /// \param[in] holdcycles Time after OE/WR deassertion before address is deasserted
  /// \param[in] pacecycles Time before next SMI bus cycle
  void bcm2835_smi_set_timing(
    int smichannel,
    int readchannel,
    int setupcycles,
    int strobecycles,
    int holdcycles,
    int pacecycles,
  ) {
    return _bcm2835_smi_set_timing(
      smichannel,
      readchannel,
      setupcycles,
      strobecycles,
      holdcycles,
      pacecycles,
    );
  }

  late final _bcm2835_smi_set_timingPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Uint32, ffi.Uint32, ffi.Uint32, ffi.Uint32,
              ffi.Uint32, ffi.Uint32)>>('bcm2835_smi_set_timing');
  late final _bcm2835_smi_set_timing = _bcm2835_smi_set_timingPtr
      .asFunction<void Function(int, int, int, int, int, int)>();

  /// ! Transfers one byte to SMI bus.
  /// Uses polled transfer as described in BCM 2835 ARM Peripherals manual
  /// \param[in] timingslot SMI configuration slot to use (0 to 3)
  /// \param[in] data The data byte to write
  /// \param[in] address The address to write to
  /// \sa bcm2835_smi_writenb()
  void bcm2835_smi_write(
    int smichannel,
    int data,
    int address,
  ) {
    return _bcm2835_smi_write(
      smichannel,
      data,
      address,
    );
  }

  late final _bcm2835_smi_writePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Uint32, ffi.Uint8, ffi.Uint32)>>('bcm2835_smi_write');
  late final _bcm2835_smi_write =
      _bcm2835_smi_writePtr.asFunction<void Function(int, int, int)>();

  /// ! Reads one byte from SMI bus.
  /// Uses polled transfer as described in BCM 2835 ARM Peripherals manual
  /// \param[in] smichannel SMI configuration slot to use (0 to 3)
  /// \param[in] address The address to read from
  /// \return value read from SMI bus
  /// \sa bcm2835_smi_readnb()
  int bcm2835_smi_read(
    int smichannel,
    int address,
  ) {
    return _bcm2835_smi_read(
      smichannel,
      address,
    );
  }

  late final _bcm2835_smi_readPtr =
      _lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.Uint32, ffi.Uint32)>>(
          'bcm2835_smi_read');
  late final _bcm2835_smi_read =
      _bcm2835_smi_readPtr.asFunction<int Function(int, int)>();

  /// ! Read the System Timer Counter register.
  /// \return the value read from the System Timer Counter Lower 32 bits register
  int bcm2835_st_read() {
    return _bcm2835_st_read();
  }

  late final _bcm2835_st_readPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function()>>('bcm2835_st_read');
  late final _bcm2835_st_read =
      _bcm2835_st_readPtr.asFunction<int Function()>();

  /// ! Delays for the specified number of microseconds with offset.
  /// \param[in] offset_micros Offset in microseconds
  /// \param[in] micros Delay in microseconds
  void bcm2835_st_delay(
    int offset_micros,
    int micros,
  ) {
    return _bcm2835_st_delay(
      offset_micros,
      micros,
    );
  }

  late final _bcm2835_st_delayPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint64, ffi.Uint64)>>(
          'bcm2835_st_delay');
  late final _bcm2835_st_delay =
      _bcm2835_st_delayPtr.asFunction<void Function(int, int)>();

  /// ! Sets the PWM clock divisor,
  /// to control the basic PWM pulse widths.
  /// \param[in] divisor Divides the basic 19.2MHz PWM clock. You can use one of the common
  /// values BCM2835_PWM_CLOCK_DIVIDER_* in \ref bcm2835PWMClockDivider
  void bcm2835_pwm_set_clock(
    int divisor,
  ) {
    return _bcm2835_pwm_set_clock(
      divisor,
    );
  }

  late final _bcm2835_pwm_set_clockPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint32)>>(
          'bcm2835_pwm_set_clock');
  late final _bcm2835_pwm_set_clock =
      _bcm2835_pwm_set_clockPtr.asFunction<void Function(int)>();

  /// ! Sets the mode of the given PWM channel,
  /// allowing you to control the PWM mode and enable/disable that channel
  /// \param[in] channel The PWM channel. 0 or 1.
  /// \param[in] markspace Set true if you want Mark-Space mode. 0 for Balanced mode.
  /// \param[in] enabled Set true to enable this channel and produce PWM pulses.
  void bcm2835_pwm_set_mode(
    int channel,
    int markspace,
    int enabled,
  ) {
    return _bcm2835_pwm_set_mode(
      channel,
      markspace,
      enabled,
    );
  }

  late final _bcm2835_pwm_set_modePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Uint8, ffi.Uint8, ffi.Uint8)>>('bcm2835_pwm_set_mode');
  late final _bcm2835_pwm_set_mode =
      _bcm2835_pwm_set_modePtr.asFunction<void Function(int, int, int)>();

  /// ! Sets the maximum range of the PWM output.
  /// The data value can vary between 0 and this range to control PWM output
  /// \param[in] channel The PWM channel. 0 or 1.
  /// \param[in] range The maximum value permitted for DATA.
  void bcm2835_pwm_set_range(
    int channel,
    int range,
  ) {
    return _bcm2835_pwm_set_range(
      channel,
      range,
    );
  }

  late final _bcm2835_pwm_set_rangePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint32)>>(
          'bcm2835_pwm_set_range');
  late final _bcm2835_pwm_set_range =
      _bcm2835_pwm_set_rangePtr.asFunction<void Function(int, int)>();

  /// ! Sets the PWM pulse ratio to emit to DATA/RANGE,
  /// where RANGE is set by bcm2835_pwm_set_range().
  /// \param[in] channel The PWM channel. 0 or 1.
  /// \param[in] data Controls the PWM output ratio as a fraction of the range.
  /// Can vary from 0 to RANGE.
  void bcm2835_pwm_set_data(
    int channel,
    int data,
  ) {
    return _bcm2835_pwm_set_data(
      channel,
      data,
    );
  }

  late final _bcm2835_pwm_set_dataPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Uint8, ffi.Uint32)>>(
          'bcm2835_pwm_set_data');
  late final _bcm2835_pwm_set_data =
      _bcm2835_pwm_set_dataPtr.asFunction<void Function(int, int)>();
}

typedef off_t = _off_t;
typedef _off_t = ffi.Long;

/// ! \brief bcm2835RegisterBase
/// Register bases for bcm2835_regbase()
abstract class bcm2835RegisterBase {
  /// !< Base of the ST (System Timer) registers.
  static const int BCM2835_REGBASE_ST = 1;

  /// !< Base of the GPIO registers.
  static const int BCM2835_REGBASE_GPIO = 2;

  /// !< Base of the PWM registers.
  static const int BCM2835_REGBASE_PWM = 3;

  /// !< Base of the CLK registers.
  static const int BCM2835_REGBASE_CLK = 4;

  /// !< Base of the PADS registers.
  static const int BCM2835_REGBASE_PADS = 5;

  /// !< Base of the SPI0 registers.
  static const int BCM2835_REGBASE_SPI0 = 6;

  /// !< Base of the BSC0 registers.
  static const int BCM2835_REGBASE_BSC0 = 7;

  /// !< Base of the BSC1 registers.
  static const int BCM2835_REGBASE_BSC1 = 8;

  /// !< Base of the AUX registers.
  static const int BCM2835_REGBASE_AUX = 9;

  /// !< Base of the SPI1 registers.
  static const int BCM2835_REGBASE_SPI1 = 10;

  /// !< Base of the SMI registers.
  static const int BCM2835_REGBASE_SMI = 11;
}

/// !   \brief bcm2835PortFunction
/// Port function select modes for bcm2835_gpio_fsel()
abstract class bcm2835FunctionSelect {
  /// !< Input 0b000
  static const int BCM2835_GPIO_FSEL_INPT = 0;

  /// !< Output 0b001
  static const int BCM2835_GPIO_FSEL_OUTP = 1;

  /// !< Alternate function 0 0b100
  static const int BCM2835_GPIO_FSEL_ALT0 = 4;

  /// !< Alternate function 1 0b101
  static const int BCM2835_GPIO_FSEL_ALT1 = 5;

  /// !< Alternate function 2 0b110,
  static const int BCM2835_GPIO_FSEL_ALT2 = 6;

  /// !< Alternate function 3 0b111
  static const int BCM2835_GPIO_FSEL_ALT3 = 7;

  /// !< Alternate function 4 0b011
  static const int BCM2835_GPIO_FSEL_ALT4 = 3;

  /// !< Alternate function 5 0b010
  static const int BCM2835_GPIO_FSEL_ALT5 = 2;

  /// !< Function select bits mask 0b111
  static const int BCM2835_GPIO_FSEL_MASK = 7;
}

/// ! \brief bcm2835PUDControl
/// Pullup/Pulldown defines for bcm2835_gpio_pud()
abstract class bcm2835PUDControl {
  /// !< Off ? disable pull-up/down 0b00
  static const int BCM2835_GPIO_PUD_OFF = 0;

  /// !< Enable Pull Down control 0b01
  static const int BCM2835_GPIO_PUD_DOWN = 1;

  /// !< Enable Pull Up control 0b10
  static const int BCM2835_GPIO_PUD_UP = 2;
}

/// ! \brief bcm2835PadGroup
/// Pad group specification for bcm2835_gpio_pad()
abstract class bcm2835PadGroup {
  /// !< Pad group for GPIO pads 0 to 27
  static const int BCM2835_PAD_GROUP_GPIO_0_27 = 0;

  /// !< Pad group for GPIO pads 28 to 45
  static const int BCM2835_PAD_GROUP_GPIO_28_45 = 1;

  /// !< Pad group for GPIO pads 46 to 53
  static const int BCM2835_PAD_GROUP_GPIO_46_53 = 2;
}

/// ! \brief GPIO Pin Numbers
///
/// Here we define Raspberry Pin GPIO pins on P1 in terms of the underlying BCM GPIO pin numbers.
/// These can be passed as a pin number to any function requiring a pin.
/// Not all pins on the RPi 26 bin IDE plug are connected to GPIO pins
/// and some can adopt an alternate function.
/// RPi version 2 has some slightly different pinouts, and these are values RPI_V2_*.
/// RPi B+ has yet differnet pinouts and these are defined in RPI_BPLUS_*.
/// At bootup, pins 8 and 10 are set to UART0_TXD, UART0_RXD (ie the alt0 function) respectively
/// When SPI0 is in use (ie after bcm2835_spi_begin()), SPI0 pins are dedicated to SPI
/// and cant be controlled independently.
/// If you are using the RPi Compute Module, just use the GPIO number: there is no need to use one of these
/// symbolic names
abstract class RPiGPIOPin {
  /// !< Version 1, Pin P1-03
  static const int RPI_GPIO_P1_03 = 0;

  /// !< Version 1, Pin P1-05
  static const int RPI_GPIO_P1_05 = 1;

  /// !< Version 1, Pin P1-07
  static const int RPI_GPIO_P1_07 = 4;

  /// !< Version 1, Pin P1-08, defaults to alt function 0 UART0_TXD
  static const int RPI_GPIO_P1_08 = 14;

  /// !< Version 1, Pin P1-10, defaults to alt function 0 UART0_RXD
  static const int RPI_GPIO_P1_10 = 15;

  /// !< Version 1, Pin P1-11
  static const int RPI_GPIO_P1_11 = 17;

  /// !< Version 1, Pin P1-12, can be PWM channel 0 in ALT FUN 5
  static const int RPI_GPIO_P1_12 = 18;

  /// !< Version 1, Pin P1-13
  static const int RPI_GPIO_P1_13 = 21;

  /// !< Version 1, Pin P1-15
  static const int RPI_GPIO_P1_15 = 22;

  /// !< Version 1, Pin P1-16
  static const int RPI_GPIO_P1_16 = 23;

  /// !< Version 1, Pin P1-18
  static const int RPI_GPIO_P1_18 = 24;

  /// !< Version 1, Pin P1-19, MOSI when SPI0 in use
  static const int RPI_GPIO_P1_19 = 10;

  /// !< Version 1, Pin P1-21, MISO when SPI0 in use
  static const int RPI_GPIO_P1_21 = 9;

  /// !< Version 1, Pin P1-22
  static const int RPI_GPIO_P1_22 = 25;

  /// !< Version 1, Pin P1-23, CLK when SPI0 in use
  static const int RPI_GPIO_P1_23 = 11;

  /// !< Version 1, Pin P1-24, CE0 when SPI0 in use
  static const int RPI_GPIO_P1_24 = 8;

  /// !< Version 1, Pin P1-26, CE1 when SPI0 in use
  static const int RPI_GPIO_P1_26 = 7;

  /// !< Version 2, Pin P1-03
  static const int RPI_V2_GPIO_P1_03 = 2;

  /// !< Version 2, Pin P1-05
  static const int RPI_V2_GPIO_P1_05 = 3;

  /// !< Version 2, Pin P1-07
  static const int RPI_V2_GPIO_P1_07 = 4;

  /// !< Version 2, Pin P1-08, defaults to alt function 0 UART0_TXD
  static const int RPI_V2_GPIO_P1_08 = 14;

  /// !< Version 2, Pin P1-10, defaults to alt function 0 UART0_RXD
  static const int RPI_V2_GPIO_P1_10 = 15;

  /// !< Version 2, Pin P1-11
  static const int RPI_V2_GPIO_P1_11 = 17;

  /// !< Version 2, Pin P1-12, can be PWM channel 0 in ALT FUN 5
  static const int RPI_V2_GPIO_P1_12 = 18;

  /// !< Version 2, Pin P1-13
  static const int RPI_V2_GPIO_P1_13 = 27;

  /// !< Version 2, Pin P1-15
  static const int RPI_V2_GPIO_P1_15 = 22;

  /// !< Version 2, Pin P1-16
  static const int RPI_V2_GPIO_P1_16 = 23;

  /// !< Version 2, Pin P1-18
  static const int RPI_V2_GPIO_P1_18 = 24;

  /// !< Version 2, Pin P1-19, MOSI when SPI0 in use
  static const int RPI_V2_GPIO_P1_19 = 10;

  /// !< Version 2, Pin P1-21, MISO when SPI0 in use
  static const int RPI_V2_GPIO_P1_21 = 9;

  /// !< Version 2, Pin P1-22
  static const int RPI_V2_GPIO_P1_22 = 25;

  /// !< Version 2, Pin P1-23, CLK when SPI0 in use
  static const int RPI_V2_GPIO_P1_23 = 11;

  /// !< Version 2, Pin P1-24, CE0 when SPI0 in use
  static const int RPI_V2_GPIO_P1_24 = 8;

  /// !< Version 2, Pin P1-26, CE1 when SPI0 in use
  static const int RPI_V2_GPIO_P1_26 = 7;

  /// !< Version 2, Pin P1-29
  static const int RPI_V2_GPIO_P1_29 = 5;

  /// !< Version 2, Pin P1-31
  static const int RPI_V2_GPIO_P1_31 = 6;

  /// !< Version 2, Pin P1-32
  static const int RPI_V2_GPIO_P1_32 = 12;

  /// !< Version 2, Pin P1-33
  static const int RPI_V2_GPIO_P1_33 = 13;

  /// !< Version 2, Pin P1-35, can be PWM channel 1 in ALT FUN 5
  static const int RPI_V2_GPIO_P1_35 = 19;

  /// !< Version 2, Pin P1-36
  static const int RPI_V2_GPIO_P1_36 = 16;

  /// !< Version 2, Pin P1-37
  static const int RPI_V2_GPIO_P1_37 = 26;

  /// !< Version 2, Pin P1-38
  static const int RPI_V2_GPIO_P1_38 = 20;

  /// !< Version 2, Pin P1-40
  static const int RPI_V2_GPIO_P1_40 = 21;

  /// !< Version 2, Pin P5-03
  static const int RPI_V2_GPIO_P5_03 = 28;

  /// !< Version 2, Pin P5-04
  static const int RPI_V2_GPIO_P5_04 = 29;

  /// !< Version 2, Pin P5-05
  static const int RPI_V2_GPIO_P5_05 = 30;

  /// !< Version 2, Pin P5-06
  static const int RPI_V2_GPIO_P5_06 = 31;

  /// !< B+, Pin J8-03
  static const int RPI_BPLUS_GPIO_J8_03 = 2;

  /// !< B+, Pin J8-05
  static const int RPI_BPLUS_GPIO_J8_05 = 3;

  /// !< B+, Pin J8-07
  static const int RPI_BPLUS_GPIO_J8_07 = 4;

  /// !< B+, Pin J8-08, defaults to alt function 0 UART0_TXD
  static const int RPI_BPLUS_GPIO_J8_08 = 14;

  /// !< B+, Pin J8-10, defaults to alt function 0 UART0_RXD
  static const int RPI_BPLUS_GPIO_J8_10 = 15;

  /// !< B+, Pin J8-11
  static const int RPI_BPLUS_GPIO_J8_11 = 17;

  /// !< B+, Pin J8-12, can be PWM channel 0 in ALT FUN 5
  static const int RPI_BPLUS_GPIO_J8_12 = 18;

  /// !< B+, Pin J8-13
  static const int RPI_BPLUS_GPIO_J8_13 = 27;

  /// !< B+, Pin J8-15
  static const int RPI_BPLUS_GPIO_J8_15 = 22;

  /// !< B+, Pin J8-16
  static const int RPI_BPLUS_GPIO_J8_16 = 23;

  /// !< B+, Pin J8-18
  static const int RPI_BPLUS_GPIO_J8_18 = 24;

  /// !< B+, Pin J8-19, MOSI when SPI0 in use
  static const int RPI_BPLUS_GPIO_J8_19 = 10;

  /// !< B+, Pin J8-21, MISO when SPI0 in use
  static const int RPI_BPLUS_GPIO_J8_21 = 9;

  /// !< B+, Pin J8-22
  static const int RPI_BPLUS_GPIO_J8_22 = 25;

  /// !< B+, Pin J8-23, CLK when SPI0 in use
  static const int RPI_BPLUS_GPIO_J8_23 = 11;

  /// !< B+, Pin J8-24, CE0 when SPI0 in use
  static const int RPI_BPLUS_GPIO_J8_24 = 8;

  /// !< B+, Pin J8-26, CE1 when SPI0 in use
  static const int RPI_BPLUS_GPIO_J8_26 = 7;

  /// !< B+, Pin J8-29,
  static const int RPI_BPLUS_GPIO_J8_29 = 5;

  /// !< B+, Pin J8-31,
  static const int RPI_BPLUS_GPIO_J8_31 = 6;

  /// !< B+, Pin J8-32,
  static const int RPI_BPLUS_GPIO_J8_32 = 12;

  /// !< B+, Pin J8-33,
  static const int RPI_BPLUS_GPIO_J8_33 = 13;

  /// !< B+, Pin J8-35, can be PWM channel 1 in ALT FUN 5
  static const int RPI_BPLUS_GPIO_J8_35 = 19;

  /// !< B+, Pin J8-36,
  static const int RPI_BPLUS_GPIO_J8_36 = 16;

  /// !< B+, Pin J8-37,
  static const int RPI_BPLUS_GPIO_J8_37 = 26;

  /// !< B+, Pin J8-38,
  static const int RPI_BPLUS_GPIO_J8_38 = 20;

  /// !< B+, Pin J8-40,
  static const int RPI_BPLUS_GPIO_J8_40 = 21;
}

/// ! \brief bcm2835SPIBitOrder SPI Bit order
/// Specifies the SPI data bit ordering for bcm2835_spi_setBitOrder()
abstract class bcm2835SPIBitOrder {
  /// !< LSB First
  static const int BCM2835_SPI_BIT_ORDER_LSBFIRST = 0;

  /// !< MSB First
  static const int BCM2835_SPI_BIT_ORDER_MSBFIRST = 1;
}

/// ! \brief SPI Data mode
/// Specify the SPI data mode to be passed to bcm2835_spi_setDataMode()
abstract class bcm2835SPIMode {
  /// !< CPOL = 0, CPHA = 0
  static const int BCM2835_SPI_MODE0 = 0;

  /// !< CPOL = 0, CPHA = 1
  static const int BCM2835_SPI_MODE1 = 1;

  /// !< CPOL = 1, CPHA = 0
  static const int BCM2835_SPI_MODE2 = 2;

  /// !< CPOL = 1, CPHA = 1
  static const int BCM2835_SPI_MODE3 = 3;
}

/// ! \brief bcm2835SPIChipSelect
/// Specify the SPI chip select pin(s)
abstract class bcm2835SPIChipSelect {
  /// !< Chip Select 0
  static const int BCM2835_SPI_CS0 = 0;

  /// !< Chip Select 1
  static const int BCM2835_SPI_CS1 = 1;

  /// !< Chip Select 2 (ie pins CS1 and CS2 are asserted)
  static const int BCM2835_SPI_CS2 = 2;

  /// !< No CS, control it yourself
  static const int BCM2835_SPI_CS_NONE = 3;
}

/// ! \brief bcm2835SPIClockDivider
/// Specifies the divider used to generate the SPI clock from the system clock.
/// Figures below give the divider, clock period and clock frequency.
/// Clock divided is based on nominal core clock rate of 250MHz on RPi1 and RPi2, and 400MHz on RPi3.
/// It is reported that (contrary to the documentation) any even divider may used.
/// The frequencies shown for each divider have been confirmed by measurement on RPi1 and RPi2.
/// The system clock frequency on RPi3 is different, so the frequency you get from a given divider will be different.
/// See comments in 'SPI Pins' for information about reliable SPI speeds.
/// Note: it is possible to change the core clock rate of the RPi 3 back to 250MHz, by putting
/// \code
/// core_freq=250
/// \endcode
/// in the config.txt
abstract class bcm2835SPIClockDivider {
  /// !< 65536 = 3.814697260kHz on Rpi2, 6.1035156kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_65536 = 0;

  /// !< 32768 = 7.629394531kHz on Rpi2, 12.20703125kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_32768 = 32768;

  /// !< 16384 = 15.25878906kHz on Rpi2, 24.4140625kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_16384 = 16384;

  /// !< 8192 = 30.51757813kHz on Rpi2, 48.828125kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_8192 = 8192;

  /// !< 4096 = 61.03515625kHz on Rpi2, 97.65625kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_4096 = 4096;

  /// !< 2048 = 122.0703125kHz on Rpi2, 195.3125kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_2048 = 2048;

  /// !< 1024 = 244.140625kHz on Rpi2, 390.625kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_1024 = 1024;

  /// !< 512 = 488.28125kHz on Rpi2, 781.25kHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_512 = 512;

  /// !< 256 = 976.5625kHz on Rpi2, 1.5625MHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_256 = 256;

  /// !< 128 = 1.953125MHz on Rpi2, 3.125MHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_128 = 128;

  /// !< 64 = 3.90625MHz on Rpi2, 6.250MHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_64 = 64;

  /// !< 32 = 7.8125MHz on Rpi2, 12.5MHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_32 = 32;

  /// !< 16 = 15.625MHz on Rpi2, 25MHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_16 = 16;

  /// !< 8 = 31.25MHz on Rpi2, 50MHz on RPI3
  static const int BCM2835_SPI_CLOCK_DIVIDER_8 = 8;

  /// !< 4 = 62.5MHz on Rpi2, 100MHz on RPI3. Dont expect this speed to work reliably.
  static const int BCM2835_SPI_CLOCK_DIVIDER_4 = 4;

  /// !< 2 = 125MHz on Rpi2, 200MHz on RPI3, fastest you can get. Dont expect this speed to work reliably.
  static const int BCM2835_SPI_CLOCK_DIVIDER_2 = 2;

  /// !< 1 = 3.814697260kHz on Rpi2, 6.1035156kHz on RPI3, same as 0/65536
  static const int BCM2835_SPI_CLOCK_DIVIDER_1 = 1;
}

/// ! \brief bcm2835I2CClockDivider
/// Specifies the divider used to generate the I2C clock from the system clock.
/// Clock divided is based on nominal base clock rate of 250MHz
abstract class bcm2835I2CClockDivider {
  /// !< 2500 = 10us = 100 kHz
  static const int BCM2835_I2C_CLOCK_DIVIDER_2500 = 2500;

  /// !< 622 = 2.504us = 399.3610 kHz
  static const int BCM2835_I2C_CLOCK_DIVIDER_626 = 626;

  /// !< 150 = 60ns = 1.666 MHz (default at reset)
  static const int BCM2835_I2C_CLOCK_DIVIDER_150 = 150;

  /// !< 148 = 59ns = 1.689 MHz
  static const int BCM2835_I2C_CLOCK_DIVIDER_148 = 148;
}

/// ! \brief bcm2835I2CReasonCodes
/// Specifies the reason codes for the bcm2835_i2c_write and bcm2835_i2c_read functions.
abstract class bcm2835I2CReasonCodes {
  /// !< Success
  static const int BCM2835_I2C_REASON_OK = 0;

  /// !< Received a NACK
  static const int BCM2835_I2C_REASON_ERROR_NACK = 1;

  /// !< Received Clock Stretch Timeout
  static const int BCM2835_I2C_REASON_ERROR_CLKT = 2;

  /// !< Not all data is sent / received
  static const int BCM2835_I2C_REASON_ERROR_DATA = 4;
}

/// ! \brief bcm2835PWMClockDivider
/// Specifies the divider used to generate the PWM clock from the system clock.
/// Figures below give the divider, clock period and clock frequency.
/// Clock divided is based on nominal PWM base clock rate of 19.2MHz
/// The frequencies shown for each divider have been confirmed by measurement
abstract class bcm2835PWMClockDivider {
  /// !< 2048 = 9.375kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_2048 = 2048;

  /// !< 1024 = 18.75kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_1024 = 1024;

  /// !< 512 = 37.5kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_512 = 512;

  /// !< 256 = 75kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_256 = 256;

  /// !< 128 = 150kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_128 = 128;

  /// !< 64 = 300kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_64 = 64;

  /// !< 32 = 600.0kHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_32 = 32;

  /// !< 16 = 1.2MHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_16 = 16;

  /// !< 8 = 2.4MHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_8 = 8;

  /// !< 4 = 4.8MHz
  static const int BCM2835_PWM_CLOCK_DIVIDER_4 = 4;

  /// !< 2 = 9.6MHz, fastest you can get
  static const int BCM2835_PWM_CLOCK_DIVIDER_2 = 2;

  /// !< 1 = 4.6875kHz, same as divider 4096
  static const int BCM2835_PWM_CLOCK_DIVIDER_1 = 1;
}

const int NULL = 0;

const int INT8_MIN = -128;

const int INT16_MIN = -32768;

const int INT32_MIN = -2147483648;

const int INT64_MIN = -9223372036854775808;

const int INT8_MAX = 127;

const int INT16_MAX = 32767;

const int INT32_MAX = 2147483647;

const int INT64_MAX = 9223372036854775807;

const int UINT8_MAX = 255;

const int UINT16_MAX = 65535;

const int UINT32_MAX = 4294967295;

const int UINT64_MAX = -1;

const int INT_LEAST8_MIN = -128;

const int INT_LEAST16_MIN = -32768;

const int INT_LEAST32_MIN = -2147483648;

const int INT_LEAST64_MIN = -9223372036854775808;

const int INT_LEAST8_MAX = 127;

const int INT_LEAST16_MAX = 32767;

const int INT_LEAST32_MAX = 2147483647;

const int INT_LEAST64_MAX = 9223372036854775807;

const int UINT_LEAST8_MAX = 255;

const int UINT_LEAST16_MAX = 65535;

const int UINT_LEAST32_MAX = 4294967295;

const int UINT_LEAST64_MAX = -1;

const int INT_FAST8_MIN = -128;

const int INT_FAST16_MIN = -2147483648;

const int INT_FAST32_MIN = -2147483648;

const int INT_FAST64_MIN = -9223372036854775808;

const int INT_FAST8_MAX = 127;

const int INT_FAST16_MAX = 2147483647;

const int INT_FAST32_MAX = 2147483647;

const int INT_FAST64_MAX = 9223372036854775807;

const int UINT_FAST8_MAX = 255;

const int UINT_FAST16_MAX = 4294967295;

const int UINT_FAST32_MAX = 4294967295;

const int UINT_FAST64_MAX = -1;

const int INTPTR_MIN = -9223372036854775808;

const int INTPTR_MAX = 9223372036854775807;

const int UINTPTR_MAX = -1;

const int INTMAX_MIN = -9223372036854775808;

const int INTMAX_MAX = 9223372036854775807;

const int UINTMAX_MAX = -1;

const int PTRDIFF_MIN = -9223372036854775808;

const int PTRDIFF_MAX = 9223372036854775807;

const int SIZE_MAX = -1;

const int SIG_ATOMIC_MIN = -2147483648;

const int SIG_ATOMIC_MAX = 2147483647;

const int WCHAR_MIN = 0;

const int WCHAR_MAX = 65535;

const int WINT_MIN = 0;

const int WINT_MAX = 65535;

const int O_RDONLY = 0;

const int O_WRONLY = 1;

const int O_RDWR = 2;

const int O_APPEND = 8;

const int O_CREAT = 256;

const int O_TRUNC = 512;

const int O_EXCL = 1024;

const int O_TEXT = 16384;

const int O_BINARY = 32768;

const int O_RAW = 32768;

const int O_TEMPORARY = 64;

const int O_NOINHERIT = 128;

const int O_SEQUENTIAL = 32;

const int O_RANDOM = 16;

const int BCM2835_VERSION = 10071;

const int HIGH = 1;

const int LOW = 0;

const int BCM2835_CORE_CLK_HZ = 250000000;

const String BMC2835_RPI2_DT_FILENAME = '/proc/device-tree/soc/ranges';

const int BCM2835_PERI_BASE = 536870912;

const int BCM2835_PERI_SIZE = 16777216;

const int BCM2835_RPI2_PERI_BASE = 1056964608;

const int BCM2835_RPI4_PERI_BASE = 4261412864;

const int BCM2835_RPI4_PERI_SIZE = 25165824;

const int BCM2835_ST_BASE = 12288;

const int BCM2835_GPIO_PADS = 1048576;

const int BCM2835_CLOCK_BASE = 1052672;

const int BCM2835_GPIO_BASE = 2097152;

const int BCM2835_SPI0_BASE = 2113536;

const int BCM2835_BSC0_BASE = 2117632;

const int BCM2835_GPIO_PWM = 2146304;

const int BCM2835_AUX_BASE = 2183168;

const int BCM2835_SPI1_BASE = 2183296;

const int BCM2835_SPI2_BASE = 2183360;

const int BCM2835_BSC1_BASE = 8404992;

const int BCM2835_SMI_BASE = 6291456;

const int CHAR_BIT = 8;

const int SCHAR_MIN = -128;

const int SCHAR_MAX = 127;

const int UCHAR_MAX = 255;

const int CHAR_MIN = -128;

const int CHAR_MAX = 127;

const int MB_LEN_MAX = 5;

const int SHRT_MIN = -32768;

const int SHRT_MAX = 32767;

const int USHRT_MAX = 65535;

const int INT_MIN = -2147483648;

const int INT_MAX = 2147483647;

const int UINT_MAX = 4294967295;

const int LONG_MIN = -2147483648;

const int LONG_MAX = 2147483647;

const int ULONG_MAX = 4294967295;

const int LLONG_MAX = 9223372036854775807;

const int LLONG_MIN = -9223372036854775808;

const int ULLONG_MAX = -1;

const int RSIZE_MAX = 9223372036854775807;

const int EXIT_SUCCESS = 0;

const int EXIT_FAILURE = 1;

const int RAND_MAX = 32767;

const int BCM2835_PAGE_SIZE = 4096;

const int BCM2835_BLOCK_SIZE = 4096;

const int BCM2835_GPFSEL0 = 0;

const int BCM2835_GPFSEL1 = 4;

const int BCM2835_GPFSEL2 = 8;

const int BCM2835_GPFSEL3 = 12;

const int BCM2835_GPFSEL4 = 16;

const int BCM2835_GPFSEL5 = 20;

const int BCM2835_GPSET0 = 28;

const int BCM2835_GPSET1 = 32;

const int BCM2835_GPCLR0 = 40;

const int BCM2835_GPCLR1 = 44;

const int BCM2835_GPLEV0 = 52;

const int BCM2835_GPLEV1 = 56;

const int BCM2835_GPEDS0 = 64;

const int BCM2835_GPEDS1 = 68;

const int BCM2835_GPREN0 = 76;

const int BCM2835_GPREN1 = 80;

const int BCM2835_GPFEN0 = 88;

const int BCM2835_GPFEN1 = 92;

const int BCM2835_GPHEN0 = 100;

const int BCM2835_GPHEN1 = 104;

const int BCM2835_GPLEN0 = 112;

const int BCM2835_GPLEN1 = 116;

const int BCM2835_GPAREN0 = 124;

const int BCM2835_GPAREN1 = 128;

const int BCM2835_GPAFEN0 = 136;

const int BCM2835_GPAFEN1 = 140;

const int BCM2835_GPPUD = 148;

const int BCM2835_GPPUDCLK0 = 152;

const int BCM2835_GPPUDCLK1 = 156;

const int BCM2835_GPPUPPDN0 = 228;

const int BCM2835_GPPUPPDN1 = 232;

const int BCM2835_GPPUPPDN2 = 236;

const int BCM2835_GPPUPPDN3 = 240;

const int BCM2835_GPIO_PUD_ERROR = 8;

const int BCM2835_PADS_GPIO_0_27 = 44;

const int BCM2835_PADS_GPIO_28_45 = 48;

const int BCM2835_PADS_GPIO_46_53 = 52;

const int BCM2835_PAD_PASSWRD = 1509949440;

const int BCM2835_PAD_SLEW_RATE_UNLIMITED = 16;

const int BCM2835_PAD_HYSTERESIS_ENABLED = 8;

const int BCM2835_PAD_DRIVE_2mA = 0;

const int BCM2835_PAD_DRIVE_4mA = 1;

const int BCM2835_PAD_DRIVE_6mA = 2;

const int BCM2835_PAD_DRIVE_8mA = 3;

const int BCM2835_PAD_DRIVE_10mA = 4;

const int BCM2835_PAD_DRIVE_12mA = 5;

const int BCM2835_PAD_DRIVE_14mA = 6;

const int BCM2835_PAD_DRIVE_16mA = 7;

const int BCM2835_AUX_IRQ = 0;

const int BCM2835_AUX_ENABLE = 4;

const int BCM2835_AUX_ENABLE_UART1 = 1;

const int BCM2835_AUX_ENABLE_SPI0 = 2;

const int BCM2835_AUX_ENABLE_SPI1 = 4;

const int BCM2835_AUX_SPI_CNTL0 = 0;

const int BCM2835_AUX_SPI_CNTL1 = 4;

const int BCM2835_AUX_SPI_STAT = 8;

const int BCM2835_AUX_SPI_PEEK = 12;

const int BCM2835_AUX_SPI_IO = 32;

const int BCM2835_AUX_SPI_TXHOLD = 48;

const int BCM2835_AUX_SPI_CLOCK_MIN = 30500;

const int BCM2835_AUX_SPI_CLOCK_MAX = 125000000;

const int BCM2835_AUX_SPI_CNTL0_SPEED = 4293918720;

const int BCM2835_AUX_SPI_CNTL0_SPEED_MAX = 4095;

const int BCM2835_AUX_SPI_CNTL0_SPEED_SHIFT = 20;

const int BCM2835_AUX_SPI_CNTL0_CS0_N = 786432;

const int BCM2835_AUX_SPI_CNTL0_CS1_N = 655360;

const int BCM2835_AUX_SPI_CNTL0_CS2_N = 393216;

const int BCM2835_AUX_SPI_CNTL0_POSTINPUT = 65536;

const int BCM2835_AUX_SPI_CNTL0_VAR_CS = 32768;

const int BCM2835_AUX_SPI_CNTL0_VAR_WIDTH = 16384;

const int BCM2835_AUX_SPI_CNTL0_DOUTHOLD = 12288;

const int BCM2835_AUX_SPI_CNTL0_ENABLE = 2048;

const int BCM2835_AUX_SPI_CNTL0_CPHA_IN = 1024;

const int BCM2835_AUX_SPI_CNTL0_CLEARFIFO = 512;

const int BCM2835_AUX_SPI_CNTL0_CPHA_OUT = 256;

const int BCM2835_AUX_SPI_CNTL0_CPOL = 128;

const int BCM2835_AUX_SPI_CNTL0_MSBF_OUT = 64;

const int BCM2835_AUX_SPI_CNTL0_SHIFTLEN = 63;

const int BCM2835_AUX_SPI_CNTL1_CSHIGH = 1792;

const int BCM2835_AUX_SPI_CNTL1_IDLE = 128;

const int BCM2835_AUX_SPI_CNTL1_TXEMPTY = 64;

const int BCM2835_AUX_SPI_CNTL1_MSBF_IN = 2;

const int BCM2835_AUX_SPI_CNTL1_KEEP_IN = 1;

const int BCM2835_AUX_SPI_STAT_TX_LVL = 4026531840;

const int BCM2835_AUX_SPI_STAT_RX_LVL = 15728640;

const int BCM2835_AUX_SPI_STAT_TX_FULL = 1024;

const int BCM2835_AUX_SPI_STAT_TX_EMPTY = 512;

const int BCM2835_AUX_SPI_STAT_RX_FULL = 256;

const int BCM2835_AUX_SPI_STAT_RX_EMPTY = 128;

const int BCM2835_AUX_SPI_STAT_BUSY = 64;

const int BCM2835_AUX_SPI_STAT_BITCOUNT = 63;

const int BCM2835_SPI0_CS = 0;

const int BCM2835_SPI0_FIFO = 4;

const int BCM2835_SPI0_CLK = 8;

const int BCM2835_SPI0_DLEN = 12;

const int BCM2835_SPI0_LTOH = 16;

const int BCM2835_SPI0_DC = 20;

const int BCM2835_SPI0_CS_LEN_LONG = 33554432;

const int BCM2835_SPI0_CS_DMA_LEN = 16777216;

const int BCM2835_SPI0_CS_CSPOL2 = 8388608;

const int BCM2835_SPI0_CS_CSPOL1 = 4194304;

const int BCM2835_SPI0_CS_CSPOL0 = 2097152;

const int BCM2835_SPI0_CS_RXF = 1048576;

const int BCM2835_SPI0_CS_RXR = 524288;

const int BCM2835_SPI0_CS_TXD = 262144;

const int BCM2835_SPI0_CS_RXD = 131072;

const int BCM2835_SPI0_CS_DONE = 65536;

const int BCM2835_SPI0_CS_TE_EN = 32768;

const int BCM2835_SPI0_CS_LMONO = 16384;

const int BCM2835_SPI0_CS_LEN = 8192;

const int BCM2835_SPI0_CS_REN = 4096;

const int BCM2835_SPI0_CS_ADCS = 2048;

const int BCM2835_SPI0_CS_INTR = 1024;

const int BCM2835_SPI0_CS_INTD = 512;

const int BCM2835_SPI0_CS_DMAEN = 256;

const int BCM2835_SPI0_CS_TA = 128;

const int BCM2835_SPI0_CS_CSPOL = 64;

const int BCM2835_SPI0_CS_CLEAR = 48;

const int BCM2835_SPI0_CS_CLEAR_RX = 32;

const int BCM2835_SPI0_CS_CLEAR_TX = 16;

const int BCM2835_SPI0_CS_CPOL = 8;

const int BCM2835_SPI0_CS_CPHA = 4;

const int BCM2835_SPI0_CS_CS = 3;

const int BCM2835_BSC_C = 0;

const int BCM2835_BSC_S = 4;

const int BCM2835_BSC_DLEN = 8;

const int BCM2835_BSC_A = 12;

const int BCM2835_BSC_FIFO = 16;

const int BCM2835_BSC_DIV = 20;

const int BCM2835_BSC_DEL = 24;

const int BCM2835_BSC_CLKT = 28;

const int BCM2835_BSC_C_I2CEN = 32768;

const int BCM2835_BSC_C_INTR = 1024;

const int BCM2835_BSC_C_INTT = 512;

const int BCM2835_BSC_C_INTD = 256;

const int BCM2835_BSC_C_ST = 128;

const int BCM2835_BSC_C_CLEAR_1 = 32;

const int BCM2835_BSC_C_CLEAR_2 = 16;

const int BCM2835_BSC_C_READ = 1;

const int BCM2835_BSC_S_CLKT = 512;

const int BCM2835_BSC_S_ERR = 256;

const int BCM2835_BSC_S_RXF = 128;

const int BCM2835_BSC_S_TXE = 64;

const int BCM2835_BSC_S_RXD = 32;

const int BCM2835_BSC_S_TXD = 16;

const int BCM2835_BSC_S_RXR = 8;

const int BCM2835_BSC_S_TXW = 4;

const int BCM2835_BSC_S_DONE = 2;

const int BCM2835_BSC_S_TA = 1;

const int BCM2835_BSC_FIFO_SIZE = 16;

const int BCM2835_SMI_CS = 0;

const int BCM2835_SMI_LENGTH = 1;

const int BCM2835_SMI_ADRS = 2;

const int BCM2835_SMI_DATA = 3;

const int BCM2835_SMI_READ0 = 4;

const int BCM2835_SMI_WRITE0 = 5;

const int BCM2835_SMI_READ1 = 6;

const int BCM2835_SMI_WRITE1 = 7;

const int BCM2835_SMI_READ2 = 8;

const int BCM2835_SMI_WRITE2 = 9;

const int BCM2835_SMI_READ3 = 10;

const int BCM2835_SMI_WRITE3 = 11;

const int BCM2835_SMI_DMAC = 12;

const int BCM2835_SMI_DIRCS = 13;

const int BCM2835_SMI_DIRADDR = 14;

const int BCM2835_SMI_DIRDATA = 15;

const int BCM2835_SMI_RW_WIDTH_MSK = 3221225472;

const int BCM2835_SMI_RW_WID8 = 0;

const int BCM2835_SMI_RW_WID16 = 1073741824;

const int BCM2835_SMI_RW_WID18 = 2147483648;

const int BCM2835_SMI_RW_WID9 = 3221225472;

const int BCM2835_SMI_RW_SETUP_MSK = 1056964608;

const int BCM2835_SMI_RW_SETUP_LS = 24;

const int BCM2835_SMI_RW_MODE68 = 8388608;

const int BCM2835_SMI_RW_MODE80 = 0;

const int BCM2835_SMI_READ_FSETUP = 4194304;

const int BCM2835_SMI_WRITE_SWAP = 4194304;

const int BCM2835_SMI_RW_HOLD_MSK = 4128768;

const int BCM2835_SMI_RW_HOLD_LS = 16;

const int BCM2835_SMI_RW_PACEALL = 32768;

const int BCM2835_SMI_RW_PACE_MSK = 32512;

const int BCM2835_SMI_RW_PACE_LS = 8;

const int BCM2835_SMI_RW_DREQ = 128;

const int BCM2835_SMI_RW_STROBE_MSK = 127;

const int BCM2835_SMI_RW_STROBE_LS = 0;

const int BCM2835_SMI_DIRCS_ENABLE = 1;

const int BCM2835_SMI_DIRCS_START = 2;

const int BCM2835_SMI_DIRCS_DONE = 4;

const int BCM2835_SMI_DIRCS_WRITE = 8;

const int BCM2835_SMI_DIRADRS_DEV_MSK = 768;

const int BCM2835_SMI_DIRADRS_DEV_LS = 8;

const int BCM2835_SMI_DIRADRS_DEV0 = 0;

const int BCM2835_SMI_DIRADRS_DEV1 = 256;

const int BCM2835_SMI_DIRADRS_DEV2 = 512;

const int BCM2835_SMI_DIRADRS_DEV3 = 768;

const int BCM2835_SMI_DIRADRS_MSK = 63;

const int BCM2835_SMI_DIRADRS_LS = 0;

const int SMICLK_CNTL = 44;

const int SMICLK_DIV = 45;

const int BCM2835_ST_CS = 0;

const int BCM2835_ST_CLO = 4;

const int BCM2835_ST_CHI = 8;

const int BCM2835_PWM_CONTROL = 0;

const int BCM2835_PWM_STATUS = 1;

const int BCM2835_PWM_DMAC = 2;

const int BCM2835_PWM0_RANGE = 4;

const int BCM2835_PWM0_DATA = 5;

const int BCM2835_PWM_FIF1 = 6;

const int BCM2835_PWM1_RANGE = 8;

const int BCM2835_PWM1_DATA = 9;

const int BCM2835_PWMCLK_CNTL = 40;

const int BCM2835_PWMCLK_DIV = 41;

const int BCM2835_PWM_PASSWRD = 1509949440;

const int BCM2835_PWM1_MS_MODE = 32768;

const int BCM2835_PWM1_USEFIFO = 8192;

const int BCM2835_PWM1_REVPOLAR = 4096;

const int BCM2835_PWM1_OFFSTATE = 2048;

const int BCM2835_PWM1_REPEATFF = 1024;

const int BCM2835_PWM1_SERIAL = 512;

const int BCM2835_PWM1_ENABLE = 256;

const int BCM2835_PWM0_MS_MODE = 128;

const int BCM2835_PWM_CLEAR_FIFO = 64;

const int BCM2835_PWM0_USEFIFO = 32;

const int BCM2835_PWM0_REVPOLAR = 16;

const int BCM2835_PWM0_OFFSTATE = 8;

const int BCM2835_PWM0_REPEATFF = 4;

const int BCM2835_PWM0_SERIAL = 2;

const int BCM2835_PWM0_ENABLE = 1;
