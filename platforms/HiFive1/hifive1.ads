-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ hifive1.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package HiFive1 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- __REF__ SiFive FE310-G002 Manual v1p0
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 6 Clock Generation (PRCI)
   ----------------------------------------------------------------------------

   package PRCI is

      -- 6.3 Internal Trimmable Programmable 72 MHz Oscillator (HFROSC)

      -- sample values, range is div1 .. div64
      hfroscdiv_div1 : constant := 0;
      hfroscdiv_div2 : constant := 1;
      hfroscdiv_div3 : constant := 2;
      hfroscdiv_div4 : constant := 3;
      hfroscdiv_div5 : constant := 4;

      type hfrosccfg_Type is
      record
         hfroscdiv  : Bits_6;           -- Ring Oscillator Divider Register
         Reserved1  : Bits_10 := 0;
         hfrosctrim : Bits_5;           -- Ring Oscillator Trim Register
         Reserved2  : Bits_9 := 0;
         hfroscen   : Boolean;          -- Ring Oscillator Enable
         hfroscrdy  : Boolean := False; -- Ring Oscillator Ready
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for hfrosccfg_Type use
      record
         hfroscdiv  at 0 range 0 .. 5;
         Reserved1  at 0 range 6 .. 15;
         hfrosctrim at 0 range 16 .. 20;
         Reserved2  at 0 range 21 .. 29;
         hfroscen   at 0 range 30 .. 30;
         hfroscrdy  at 0 range 31 .. 31;
      end record;

      -- 6.4 External 16 MHz Crystal Oscillator (HFXOSC)

      type hfxosccfg_Type is
      record
         Reserved  : Bits_30 := 0;
         hfxoscen  : Boolean;          -- Crystal Oscillator Enable
         hfxoscrdy : Boolean := False; -- Crystal Oscillator Ready
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for hfxosccfg_Type use
      record
         Reserved  at 0 range 0 .. 29;
         hfxoscen  at 0 range 30 .. 30;
         hfxoscrdy at 0 range 31 .. 31;
      end record;

      -- 6.5 Internal High-Frequency PLL (HFPLL)

      pllr_div1 : constant := 2#00#;
      pllr_div2 : constant := 2#01#;
      pllr_div3 : constant := 2#10#;
      pllr_div4 : constant := 2#11#;

      -- sample values, range is x2 .. x128 in even steps
      pllf_x2   : constant := 0;
      pllf_x4   : constant := 1;
      pllf_x8   : constant := 3;
      pllf_x16  : constant := 7;
      pllf_x32  : constant := 15;
      pllf_x64  : constant := 31;
      pllf_x128 : constant := 63;

      pllq_div2 : constant := 2#01#;
      pllq_div4 : constant := 2#10#;
      pllq_div8 : constant := 2#11#;

      pllsel_HFROSC : constant := 0; -- hfroscclk directly drives hfclk
      pllsel_PLL    : constant := 1; -- PLL drives hfclk

      pllrefsel_HFROSC : constant := 0; -- PLL driven by HFROSC
      pllrefsel_HFXOSC : constant := 1; -- PLL driven by HFXOSC

      type pllcfg_Type is
      record
         pllr      : Bits_3;           -- PLL R Value
         Reserved1 : Bits_1 := 0;
         pllf      : Bits_6;           -- PLL F Value
         pllq      : Bits_2;           -- PLL Q Value
         Reserved2 : Bits_4 := 0;
         pllsel    : Bits_1;           -- PLL Select
         pllrefsel : Bits_1;           -- PLL Reference Select
         pllbypass : Boolean;          -- PLL Bypass
         Reserved3 : Bits_12 := 0;
         plllock   : Boolean := False; -- PLL Lock (RO)
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pllcfg_Type use
      record
         pllr      at 0 range 0 .. 2;
         Reserved1 at 0 range 3 .. 3;
         pllf      at 0 range 4 .. 9;
         pllq      at 0 range 10 .. 11;
         Reserved2 at 0 range 12 .. 15;
         pllsel    at 0 range 16 .. 16;
         pllrefsel at 0 range 17 .. 17;
         pllbypass at 0 range 18 .. 18;
         Reserved3 at 0 range 19 .. 30;
         plllock   at 0 range 31 .. 31;
      end record;

      -- 6.6 PLL Output Divider

      -- sample values, range is div2 .. div128 in even steps
      plloutdiv_div2   : constant := 0;
      plloutdiv_div4   : constant := 1;
      plloutdiv_div6   : constant := 2;
      plloutdiv_div8   : constant := 3;
      plloutdiv_div16  : constant := 7;
      plloutdiv_div128 : constant := 63;

      plloutdivby1_CLR : constant := 0; -- PLL Final Divide By plloutdiv_...
      plloutdivby1_SET : constant := 1; -- PLL Final Divide By 1

      type plloutdiv_Type is
      record
         plloutdiv    : Bits_6 := 0;  -- PLL Final Divider Value (default = divide by 2)
         Reserved1    : Bits_2 := 0;
         plloutdivby1 : Bits_6;       -- PLL Final Divide By 1
         Reserved2    : Bits_18 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for plloutdiv_Type use
      record
         plloutdiv    at 0 range 0 .. 5;
         Reserved1    at 0 range 6 .. 7;
         plloutdivby1 at 0 range 8 .. 13;
         Reserved2    at 0 range 14 .. 31;
      end record;

      -- 6.7 Internal Programmable Low-Frequency Ring Oscillator (LFROSC)

      -- sample values, range is div1 .. div64
      lfroscdiv_div1 : constant := 0;
      lfroscdiv_div2 : constant := 1;
      lfroscdiv_div3 : constant := 2;
      lfroscdiv_div4 : constant := 3;
      lfroscdiv_div5 : constant := 4;

      type lfrosccfg_Type is
      record
         lfroscdiv  : Bits_6;           -- Ring Oscillator Divider Register
         Reserved1  : Bits_10 := 0;
         lfrosctrim : Bits_5;           -- Ring Oscillator Trim Register
         Reserved2  : Bits_9 := 0;
         lfroscen   : Boolean;          -- Ring Oscillator Enable
         lfroscrdy  : Boolean := False; -- Ring Oscillator Ready
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for lfrosccfg_Type use
      record
         lfroscdiv  at 0 range 0 .. 5;
         Reserved1  at 0 range 6 .. 15;
         lfrosctrim at 0 range 16 .. 20;
         Reserved2  at 0 range 21 .. 29;
         lfroscen   at 0 range 30 .. 30;
         lfroscrdy  at 0 range 31 .. 31;
      end record;

      -- 6.8 Alternate Low-Frequency Clock (LFALTCLK)

      lfextclk_sel_LFROSC : constant := 0; -- low-frequency clock source = LFROSC
      lfextclk_sel_EXT    : constant := 1; -- low-frequency clock source = psdlfaltclk pad

      type lfclkmux_Type is
      record
         lfextclk_sel        : Bits_1;           -- Low Frequency Clock Source Selector
         Reserved            : Bits_30 := 0;
         lfextclk_mux_status : Boolean := False; -- Setting of the aon_lfclksel pin (RO)
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for lfclkmux_Type use
      record
         lfextclk_sel        at 0 range 0 .. 0;
         Reserved            at 0 range 1 .. 30;
         lfextclk_mux_status at 0 range 31 .. 31;
      end record;

      PRCI_BASEADDRESS : constant := 16#1000_8000#;

      hfrosccfg : aliased hfrosccfg_Type with
         Address              => To_Address (PRCI_BASEADDRESS + 16#00#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      hfxosccfg : aliased hfxosccfg_Type with
         Address              => To_Address (PRCI_BASEADDRESS + 16#04#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      pllcfg : aliased pllcfg_Type with
         Address              => To_Address (PRCI_BASEADDRESS + 16#08#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      plloutdiv : aliased plloutdiv_Type with
         Address              => To_Address (PRCI_BASEADDRESS + 16#0C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      lfrosccfg : aliased lfrosccfg_Type with
         Address              => To_Address (PRCI_BASEADDRESS + 16#70#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      lfclkmux : aliased lfclkmux_Type  with
         Address              => To_Address (PRCI_BASEADDRESS + 16#7C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

   end PRCI;

   ----------------------------------------------------------------------------
   -- 13 Always-On (AON) Domain
   ----------------------------------------------------------------------------

   package AON is

      AON_BASEADDRESS : constant := 16#1000_0000#;

      -- 13.9 Backup Registers

      type backup_Type is new Bits_32 with
         Volatile_Full_Access => True;

      backup : aliased array (0 .. 15) of backup_Type with
         Address    => To_Address (AON.AON_BASEADDRESS + 16#80#),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

   end AON;

   ----------------------------------------------------------------------------
   -- 14 Watchdog Timer (WDT)
   ----------------------------------------------------------------------------

   package WDT is

      wdogkey_Value  : constant := 16#0051_F15E#;
      wdogfeed_Value : constant := 16#0D09_F00D#;

      -- 14.3 Watchdog Configuration Register (wdogcfg)

      type wdogcfg_Type is
      record
         wdogscale     : Bits_4;       -- Counter scale value.
         Reserved1     : Bits_4 := 0;
         wdogrsten     : Boolean;      -- Controls whether the comp output can set the wdogrst bit and hence cause a full reset.
         wdogzerocmp   : Boolean;
         Reserved2     : Bits_2 := 0;
         wdogenalways  : Boolean;      -- Enable Always - run continuously
         wdogcoreawake : Boolean;      -- Increment the watchdog counter if the processor is not asleep
         Reserved3     : Bits_14 := 0;
         wdogip0       : Boolean;      -- Interrupt 0 Pending
         Reserved4     : Bits_3 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for wdogcfg_Type use
      record
         wdogscale     at 0 range 0 .. 3;
         Reserved1     at 0 range 4 .. 7;
         wdogrsten     at 0 range 8 .. 8;
         wdogzerocmp   at 0 range 9 .. 9;
         Reserved2     at 0 range 10 .. 11;
         wdogenalways  at 0 range 12 .. 12;
         wdogcoreawake at 0 range 13 .. 13;
         Reserved3     at 0 range 14 .. 27;
         wdogip0       at 0 range 28 .. 28;
         Reserved4     at 0 range 29 .. 31;
      end record;

      -- 14.4 Watchdog Compare Register (wdogcmp)

      type wdogcmp_Type is
      record
         wdogcmp0 : Unsigned_16;      -- Comparator 0
         Reserved : Unsigned_16 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for wdogcmp_Type use
      record
         wdogcmp0 at 0 range 0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      wdogcfg : aliased wdogcfg_Type with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#00#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      wdogcount : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#08#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      wdogs : aliased Unsigned_16 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#10#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      wdogfeed : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#18#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      wdogkey : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#1C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      wdogcmp0 : aliased wdogcmp_Type with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#20#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

   end WDT;

   ----------------------------------------------------------------------------
   -- 15 Power-Management Unit (PMU)
   ----------------------------------------------------------------------------

   package PMU is

      -- 15.3 PMU Key Register (pmukey)

      pmukey_Value : constant := 16#0051_F15E#;

      pmukey : aliased Bits_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#14C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      -- 15.4 PMU Program

      type pmu_sleep_wakeup_iX_Type is
      record
         delaym       : Bits_4;       -- delay multiplier
         pmu_out_0_en : Boolean;      -- Drive PMU Output En 0 High
         pmu_out_1_en : Boolean;      -- Drive PMU Output En 1 High
         corerst      : Boolean;      -- Core Reset
         hfclkrst     : Boolean;      -- High-Frequency Clock Reset
         isolate      : Boolean;      -- Isolate MOFF-to-AON Power Domains
         Reserved     : Bits_23 := 0;
      end record with
         Bit_Order            => Low_Order_First,
         Size                 => 32,
         Volatile_Full_Access => True;
      for pmu_sleep_wakeup_iX_Type use
      record
         delaym       at 0 range 0 .. 3;
         pmu_out_0_en at 0 range 4 .. 4;
         pmu_out_1_en at 0 range 5 .. 5;
         corerst      at 0 range 6 .. 6;
         hfclkrst     at 0 range 7 .. 7;
         isolate      at 0 range 8 .. 8;
         Reserved     at 0 range 9 .. 31;
      end record;

      pmuwakeupi : aliased array (0 .. 7) of pmu_sleep_wakeup_iX_Type with
         Address    => To_Address (AON.AON_BASEADDRESS + 16#100#),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

      pmusleepi : aliased array (0 .. 7) of pmu_sleep_wakeup_iX_Type with
         Address    => To_Address (AON.AON_BASEADDRESS + 16#120#),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

      -- 15.5 Initiate Sleep Sequence Register (pmusleep)

      pmusleep : aliased Bits_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#148#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      -- 15.7 PMU Interrupt Enables (pmuie) and Wakeup Cause (pmucause)

      type pmuie_Type is
      record
         rtc      : Boolean;      -- RTC wakeup
         dwakeup  : Boolean;      -- Digital input wakeup
         awakeup  : Boolean;      -- ??? Analog input wakeup
         Reserved : Bits_29 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pmuie_Type use
      record
         rtc      at 0 range 0 .. 0;
         dwakeup  at 0 range 1 .. 1;
         awakeup  at 0 range 2 .. 2;
         Reserved at 0 range 3 .. 31;
      end record;

      pmuie : aliased pmuie_Type with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#140#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      type pmucause_Type is
      record
         reset     : Boolean; -- Reset
         rtc       : Boolean; -- RTC wakeup
         dwakeup   : Boolean; -- Digital input wakeup
         Reserved1 : Bits_5;
         ponreset  : Boolean; -- Power-on reset
         extreset  : Boolean; -- External reset
         wdogreset : Boolean; -- Watchdog timer reset
         Reserved2 : Bits_21;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pmucause_Type use
      record
         reset     at 0 range 0 .. 0;
         rtc       at 0 range 1 .. 1;
         dwakeup   at 0 range 2 .. 2;
         Reserved1 at 0 range 3 .. 7;
         ponreset  at 0 range 8 .. 8;
         extreset  at 0 range 9 .. 9;
         wdogreset at 0 range 10 .. 10;
         Reserved2 at 0 range 11 .. 31;
      end record;

      pmucause : aliased pmucause_Type with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#144#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

   end PMU;

   ----------------------------------------------------------------------------
   -- 16 Real-Time Clock (RTC)
   ----------------------------------------------------------------------------

   package RTC is

      rtcscale_DIVNONE : constant := 2#0000#;
      rtcscale_DIV2    : constant := 2#0001#;
      rtcscale_DIV4    : constant := 2#0010#;
      rtcscale_DIV8    : constant := 2#0011#;
      rtcscale_DIV16   : constant := 2#0100#;
      rtcscale_DIV32   : constant := 2#0101#;
      rtcscale_DIV64   : constant := 2#0110#;
      rtcscale_DIV128  : constant := 2#0111#;
      rtcscale_DIV256  : constant := 2#1000#;
      rtcscale_DIV512  : constant := 2#1001#;
      rtcscale_DIV1k   : constant := 2#1010#;
      rtcscale_DIV2k   : constant := 2#1011#;
      rtcscale_DIV4k   : constant := 2#1100#;
      rtcscale_DIV8k   : constant := 2#1101#;
      rtcscale_DIV16k  : constant := 2#1110#;
      rtcscale_DIV32k  : constant := 2#1111#;

      type rtccfg_Type is
      record
         rtcscale    : Bits_4;       -- Counter scale value.
         Reserved1   : Bits_8 := 0;
         rtcenalways : Boolean;      -- Enable Always - run continuously
         Reserved2   : Bits_15 := 0;
         rtcip0      : Boolean;      -- Interrupt 0 Pending
         Reserved3   : Bits_3 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for rtccfg_Type use
      record
         rtcscale    at 0 range 0 .. 3;
         Reserved1   at 0 range 4 .. 11;
         rtcenalways at 0 range 12 .. 12;
         Reserved2   at 0 range 13 .. 27;
         rtcip0      at 0 range 28 .. 28;
         Reserved3   at 0 range 29 .. 31;
      end record;

      rtccfg : aliased rtccfg_Type with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#40#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      rtccountlo : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#48#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      rtccounthi : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#4C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      rtcs : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#50#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      rtccmp0 : aliased Unsigned_32 with
         Address              => To_Address (AON.AON_BASEADDRESS + 16#60#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

   end RTC;

   ----------------------------------------------------------------------------
   -- 17 General Purpose Input/Output Controller (GPIO)
   ----------------------------------------------------------------------------

   package GPIO is

      GPIO_BASEADDRESS : constant := 16#1001_2000#;

      OEN : aliased Bitmap_32 with
         Address              => To_Address (GPIO_BASEADDRESS + 16#08#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      PORT : aliased Bitmap_32 with
         Address              => To_Address (GPIO_BASEADDRESS + 16#0C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      IOFEN : aliased Bitmap_32 with
         Address              => To_Address (GPIO_BASEADDRESS + 16#38#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

      IOFSEL : aliased Bitmap_32 with
         Address              => To_Address (GPIO_BASEADDRESS + 16#3C#),
         Volatile_Full_Access => True,
         Import               => True,
         Convention           => Ada;

   end GPIO;

   ----------------------------------------------------------------------------
   -- 18 Universal Asynchronous Receiver/Transmitter (UART)
   ----------------------------------------------------------------------------

   package UART is

      -- 18.4 Transmit Data Register (txdata)

      type txdata_Type is
      record
         txdata   : Unsigned_8;       -- Transmit data
         Reserved : Bits_23 := 0;
         full     : Boolean := False; -- Transmit FIFO full (RO)
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for txdata_Type use
      record
         txdata   at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 30;
         full     at 0 range 31 .. 31;
      end record;

      -- 18.5 Receive Data Register (rxdata)

      type rxdata_Type is
      record
         rxdata   : Unsigned_8;       -- Received data (RO)
         Reserved : Bits_23 := 0;
         empty    : Boolean := False; -- Receive FIFO empty (RO)
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for rxdata_Type use
      record
         rxdata   at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 30;
         empty    at 0 range 31 .. 31;
      end record;

      -- 18.6 Transmit Control Register (txctrl)

      nstop_1 : constant := 0; -- one stop bit
      nstop_2 : constant := 1; -- two stop bits

      type txctrl_Type is
      record
         txen      : Boolean;      -- Transmit enable
         nstop     : Bits_1;       -- Number of stop bits
         Reserved1 : Bits_14 := 0;
         txcnt     : Bits_3;       -- Transmit watermark level
         Reserved2 : Bits_13 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for txctrl_Type use
      record
         txen      at 0 range 0 .. 0;
         nstop     at 0 range 1 .. 1;
         Reserved1 at 0 range 2 .. 15;
         txcnt     at 0 range 16 .. 18;
         Reserved2 at 0 range 19 .. 31;
      end record;

      -- 18.7 Receive Control Register (rxctrl)

      type rxctrl_Type is
      record
         rxen      : Boolean;      -- Receive enable
         Reserved1 : Bits_15 := 0;
         rxcnt     : Bits_3;       -- Receive watermark level
         Reserved2 : Bits_13 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for rxctrl_Type use
      record
         rxen      at 0 range 0 .. 0;
         Reserved1 at 0 range 1 .. 15;
         rxcnt     at 0 range 16 .. 18;
         Reserved2 at 0 range 19 .. 31;
      end record;

      -- 18.8 Interrupt Registers (ip and ie)

      type ie_Type is
      record
         txwm     : Boolean;      -- Transmit watermark interrupt enable
         rxwm     : Boolean;      -- Receive watermark interrupt enable
         Reserved : Bits_30 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for ie_Type use
      record
         txwm     at 0 range 0 .. 0;
         rxwm     at 0 range 1 .. 1;
         Reserved at 0 range 2 .. 31;
      end record;

      type ip_Type is
      record
         txwm     : Boolean;      -- Transmit watermark interrupt pending
         rxwm     : Boolean;      -- Receive watermark interrupt pending
         Reserved : Bits_30 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for ip_Type use
      record
         txwm     at 0 range 0 .. 0;
         rxwm     at 0 range 1 .. 1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 18.9 Baud Rate Divisor Register (div)

      type div_Type is
      record
         div      : Unsigned_16;  -- Baud rate divisor.
         Reserved : Bits_16 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for div_Type use
      record
         div      at 0 range 0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      -- 18.3 Memory Map

      type UART_Type is
      record
         txdata : txdata_Type with Volatile_Full_Access => True;
         rxdata : rxdata_Type with Volatile_Full_Access => True;
         txctrl : txctrl_Type with Volatile_Full_Access => True;
         rxctrl : rxctrl_Type with Volatile_Full_Access => True;
         ie     : ie_Type     with Volatile_Full_Access => True;
         ip     : ip_Type     with Volatile_Full_Access => True;
         div    : div_Type    with Volatile_Full_Access => True;
      end record with
         Size => 7 * 32;
      for UART_Type use
      record
         txdata at 16#00# range 0 .. 31;
         rxdata at 16#04# range 0 .. 31;
         txctrl at 16#08# range 0 .. 31;
         rxctrl at 16#0C# range 0 .. 31;
         ie     at 16#10# range 0 .. 31;
         ip     at 16#14# range 0 .. 31;
         div    at 16#18# range 0 .. 31;
      end record;

      UART0_BASEADDRESS : constant := 16#1001_3000#;

      UART0 : aliased UART_Type with
         Address    => To_Address (UART0_BASEADDRESS),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

      UART1_BASEADDRESS : constant := 16#1002_3000#;

      UART1 : aliased UART_Type with
         Address    => To_Address (UART1_BASEADDRESS),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

   end UART;

   ----------------------------------------------------------------------------
   -- 19 Serial Peripheral Interface (SPI)
   ----------------------------------------------------------------------------

   package SPI is

      -- protocol definitions for
      -- fmt.proto
      -- ffmt.[cmd_proto|addr_proto|data_proto]

      proto_SINGLE : constant := 2#00#; -- DQ0 (MOSI), DQ1 (MISO)
      proto_DUAL   : constant := 2#01#; -- DQ0, DQ1
      proto_QUAD   : constant := 2#10#; -- DQ0, DQ1, DQ2, DQ3

      -- 19.4 Serial Clock Divisor Register (sckdiv)

      -- sample values, range is div2 .. div8192 in even steps
      sckdiv_div2  : constant := 0;
      sckdiv_div4  : constant := 1;
      sckdiv_div6  : constant := 2;
      sckdiv_div8  : constant := 3;
      sckdiv_div10 : constant := 4;

      type sckdiv_Type is
      record
         div      : Bits_12 := 16#03#;
         Reserved : Bits_20 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for sckdiv_Type use
      record
         div      at 0 range 0 .. 11;
         Reserved at 0 range 12 .. 31;
      end record;

      -- 19.5 Serial Clock Mode Register (sckmode)

      pha_SALSHT : constant := 0; -- Data is sampled on the leading edge of SCK and shifted on the trailing edge of SCK
      pha_SHLSAT : constant := 1; -- Data is shifted on the leading edge of SCK and sampled on the trailing edge of SCK

      pol_INACTIVE0 : constant := 0; -- Inactive state of SCK is logical 0
      pol_INACTIVE1 : constant := 1; -- Inactive state of SCK is logical 1

      type sckmode_Type is
      record
         pha      : Bits_1 := 0;  -- Serial clock phase
         pol      : Bits_1 := 0;  -- Serial clock polarity
         Reserved : Bits_30 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for sckmode_Type use
      record
         pha      at 0 range 0 .. 0;
         pol      at 0 range 1 .. 1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 19.8 Chip Select Mode Register (csmode)

      mode_AUTO : constant := 2#00#; -- Assert/deassert CS at the beginning/end of each frame
      mode_HOLD : constant := 2#10#; -- Keep CS continuously asserted after the initial frame
      mode_OFF  : constant := 2#11#; -- Disable hardware control of the CS pin

      type csmode_Type is
      record
         mode     : Bits_2 := 0;  -- Chip select mode
         Reserved : Bits_30 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for csmode_Type use
      record
         mode     at 0 range 0 .. 1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 19.9 Delay Control Registers (delay0 and delay1)

      type delay0_Type is
      record
         cssck     : Unsigned_8 := 1; -- CS to SCK Delay
         Reserved1 : Bits_8 := 0;
         sckcs     : Unsigned_8 := 1; -- SCK to CS Delay
         Reserved2 : Bits_8 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for delay0_Type use
      record
         cssck     at 0 range 0 .. 7;
         Reserved1 at 0 range 8 .. 15;
         sckcs     at 0 range 16 .. 23;
         Reserved2 at 0 range 24 .. 31;
      end record;

      type delay1_Type is
      record
         intercs   : Unsigned_8 := 1; -- Minimum CS inactive time
         Reserved1 : Bits_8 := 0;
         interxfr  : Unsigned_8 := 0; -- Maximum interframe delay
         Reserved2 : Bits_8 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for delay1_Type use
      record
         intercs   at 0 range 0 .. 7;
         Reserved1 at 0 range 8 .. 15;
         interxfr  at 0 range 16 .. 23;
         Reserved2 at 0 range 24 .. 31;
      end record;

      -- 19.10 Frame Format Register (fmt)

      endian_MSB : constant := 0; -- Transmit most-significant bit (MSB) first
      endian_LSB : constant := 1; -- Transmit least-significant bit (LSB) first

      dir_RX : constant := 0; -- dual, quad -> DQ tri-stated. single -> DQ0 transmit data.
      dir_TX : constant := 1; -- The receive FIFO is not populated.

      type fmt_Type is
      record
         proto     : Bits_2 := 0;  -- SPI protocol
         endian    : Bits_1 := 0;  -- SPI endianness
         dir       : Bits_1 := 0;  -- SPI I/O direction.
         Reserved1 : Bits_12 := 0;
         len       : Bits_4 := 8;  -- Number of bits per frame
         Reserved2 : Bits_12 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for fmt_Type use
      record
         proto     at 0 range 0 .. 1;
         endian    at 0 range 2 .. 2;
         dir       at 0 range 3 .. 3;
         Reserved1 at 0 range 4 .. 15;
         len       at 0 range 16 .. 19;
         Reserved2 at 0 range 20 .. 31;
      end record;

      -- 19.11 Transmit Data Register (txdata)

      type txdata_Type is
      record
         txdata   : Unsigned_8;       -- Transmit data
         Reserved : Bits_23 := 0;
         full     : Boolean := False; -- FIFO full flag (RO)
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for txdata_Type use
      record
         txdata   at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 30;
         full     at 0 range 31 .. 31;
      end record;

      -- 19.12 Receive Data Register (rxdata)

      type rxdata_Type is
      record
         rxdata   : Unsigned_8;       -- Received data (RO)
         Reserved : Bits_23 := 0;
         empty    : Boolean := False; -- FIFO empty flag (RO)
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for rxdata_Type use
      record
         rxdata   at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 30;
         empty    at 0 range 31 .. 31;
      end record;

      -- 19.13 Transmit Watermark Register (txmark)

      type txmark_Type is
      record
         txmark   : Bits_3;       -- Transmit watermark.
         Reserved : Bits_29 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for txmark_Type use
      record
         txmark   at 0 range 0 .. 2;
         Reserved at 0 range 3 .. 31;
      end record;

      -- 19.14 Receive Watermark Register (rxmark)

      type rxmark_Type is
      record
         rxmark   : Bits_3;       -- Receive watermark
         Reserved : Bits_29 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for rxmark_Type use
      record
         rxmark   at 0 range 0 .. 2;
         Reserved at 0 range 3 .. 31;
      end record;

      -- 19.15 SPI Interrupt Registers (ie and ip)

      type ie_Type is
      record
         txwm   : Boolean;        -- Transmit watermark enable
         rxwm   : Boolean;        -- Receive watermark enable
         Reserved : Bits_30 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for ie_Type use
      record
         txwm     at 0 range 0 .. 0;
         rxwm     at 0 range 1 .. 1;
         Reserved at 0 range 2 .. 31;
      end record;

      type ip_Type is
      record
         txwm   : Boolean;        -- Transmit watermark pending
         rxwm   : Boolean;        -- Receive watermark pending
         Reserved : Bits_30 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for ip_Type use
      record
         txwm     at 0 range 0 .. 0;
         rxwm     at 0 range 1 .. 1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 19.16 SPI Flash Interface Control Register (fctrl)

      type fctrl_Type is
      record
         en       : Boolean;      -- SPI Flash Mode Select
         Reserved : Bits_31 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for fctrl_Type use
      record
         en       at 0 range 0 .. 0;
         Reserved at 0 range 1 .. 31;
      end record;

      -- 19.17 SPI Flash Instruction Format Register (ffmt)

      type ffmt_Type is
      record
         cmd_en     : Boolean;     -- Enable sending of command
         addr_len   : Bits_3;      -- Number of address bytes (0 to 4)
         pad_cnt    : Bits_4;      -- Number of dummy cycles
         cmd_proto  : Bits_2;      -- Protocol for transmitting command
         addr_proto : Bits_2;      -- Protocol for transmitting address and padding
         data_proto : Bits_2;      -- Protocol for receiving data bytes
         Reserved   : Bits_2 := 0;
         cmd_code   : Unsigned_8;  -- Value of command byte
         pad_code   : Unsigned_8;  -- First 8 bits to transmit during dummy cycles
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for ffmt_Type use
      record
         cmd_en     at 0 range 0 .. 0;
         addr_len   at 0 range 1 .. 3;
         pad_cnt    at 0 range 4 .. 7;
         cmd_proto  at 0 range 8 .. 9;
         addr_proto at 0 range 10 .. 11;
         data_proto at 0 range 12 .. 13;
         Reserved   at 0 range 14 .. 15;
         cmd_code   at 0 range 16 .. 23;
         pad_code   at 0 range 24 .. 31;
      end record;

      -- 19.3 Memory Map

      type SPI_Type is
      record
         sckdiv  : sckdiv_Type  with Volatile_Full_Access => True;
         sckmode : sckmode_Type with Volatile_Full_Access => True;
         csid    : Unsigned_32  with Volatile_Full_Access => True;
         csdef   : Unsigned_32  with Volatile_Full_Access => True;
         csmode  : csmode_Type  with Volatile_Full_Access => True;
         delay0  : delay0_Type  with Volatile_Full_Access => True;
         delay1  : delay1_Type  with Volatile_Full_Access => True;
         fmt     : fmt_Type     with Volatile_Full_Access => True;
         txdata  : txdata_Type  with Volatile_Full_Access => True;
         rxdata  : rxdata_Type  with Volatile_Full_Access => True;
         txmark  : txmark_Type  with Volatile_Full_Access => True;
         rxmark  : rxmark_Type  with Volatile_Full_Access => True;
         fctrl   : fctrl_Type   with Volatile_Full_Access => True;
         ffmt    : ffmt_Type    with Volatile_Full_Access => True;
         ie      : ie_Type      with Volatile_Full_Access => True;
         ip      : ip_Type      with Volatile_Full_Access => True;
      end record with
         Size => 16#78# * 8;
      for SPI_Type use
      record
         sckdiv  at 16#00# range 0 .. 31;
         sckmode at 16#04# range 0 .. 31;
         csid    at 16#10# range 0 .. 31;
         csdef   at 16#14# range 0 .. 31;
         csmode  at 16#18# range 0 .. 31;
         delay0  at 16#28# range 0 .. 31;
         delay1  at 16#2C# range 0 .. 31;
         fmt     at 16#40# range 0 .. 31;
         txdata  at 16#48# range 0 .. 31;
         rxdata  at 16#4C# range 0 .. 31;
         txmark  at 16#50# range 0 .. 31;
         rxmark  at 16#54# range 0 .. 31;
         fctrl   at 16#60# range 0 .. 31;
         ffmt    at 16#64# range 0 .. 31;
         ie      at 16#70# range 0 .. 31;
         ip      at 16#74# range 0 .. 31;
      end record;

      -- QSPI0: Flash Controller = Y, cs_width = 1, div_width = 12

      QSPI0_BASEADDRESS : constant := 16#1001_4000#;

      QSPI0 : aliased SPI_Type with
         Address    => To_Address (QSPI0_BASEADDRESS),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

      -- SPI1: Flash Controller = N, cs_width = 4, div_width = 12

      SPI1_BASEADDRESS : constant := 16#1002_4000#;

      SPI1 : aliased SPI_Type with
         Address    => To_Address (SPI1_BASEADDRESS),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

      -- SPI2: Flash Controller = N, cs_width = 1, div_width = 12

      SPI2_BASEADDRESS : constant := 16#1003_4000#;

      SPI2 : aliased SPI_Type with
         Address    => To_Address (SPI2_BASEADDRESS),
         Volatile   => True,
         Import     => True,
         Convention => Ada;

   end SPI;

   ----------------------------------------------------------------------------
   -- 20 Pulse Width Modulator (PWM)
   ----------------------------------------------------------------------------

   package PWM is

      -- 20.4 PWM Count Register (pwmcount)

      type pwmcount_Type is
      record
         pwmcount : Bits_31;     -- PWM count register. cmpwidth + 15 bits wide.
         Reserved : Bits_1 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pwmcount_Type use
      record
         pwmcount at 0 range 0 .. 30;
         Reserved at 0 range 31 .. 31;
      end record;

      -- 20.5 PWM Configuration Register (pwmcfg)

      type pwmcfg_Type is
      record
         pwmscale      : Bits_4;      -- PWM Counter scale
         Reserved1     : Bits_4 := 0;
         pwmsticky     : Boolean;     -- PWM Sticky - disallow clearing pwmcmp ip bits
         pwmzerocmp    : Boolean;     -- PWM Zero - counter resets to zero after match
         pwmdeglitch   : Boolean;     -- PWM Deglitch - latch pwmcmp ip within same cycle
         Reserved2     : Bits_1 := 0;
         pwmenalways   : Boolean;     -- PWM enable always - run continuously
         pwmenoneshot  : Boolean;     -- PWM enable one shot - run one cycle
         Reserved3     : Bits_2 := 0;
         pwmcmp0center : Boolean;     -- PWM0 Compare Center
         pwmcmp1center : Boolean;     -- PWM1 Compare Center
         pwmcmp2center : Boolean;     -- PWM2 Compare Center
         pwmcmp3center : Boolean;     -- PWM3 Compare Center
         Reserved4     : Bits_4 := 0;
         pwmcmp0gang   : Boolean;     -- PWM0/PWM1 Compare Gang
         pwmcmp1gang   : Boolean;     -- PWM1/PWM2 Compare Gang
         pwmcmp2gang   : Boolean;     -- PWM2/PWM3 Compare Gang
         pwmcmp3gang   : Boolean;     -- PWM3/PWM0 Compare Gang
         pwmcmp0ip     : Boolean;     -- PWM0 Interrupt Pending
         pwmcmp1ip     : Boolean;     -- PWM1 Interrupt Pending
         pwmcmp2ip     : Boolean;     -- PWM2 Interrupt Pending
         pwmcmp3ip     : Boolean;     -- PWM3 Interrupt Pending
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pwmcfg_Type use
      record
         pwmscale      at 0 range 0 .. 3;
         Reserved1     at 0 range 4 .. 7;
         pwmsticky     at 0 range 8 .. 8;
         pwmzerocmp    at 0 range 9 .. 9;
         pwmdeglitch   at 0 range 10 .. 10;
         Reserved2     at 0 range 11 .. 11;
         pwmenalways   at 0 range 12 .. 12;
         pwmenoneshot  at 0 range 13 .. 13;
         Reserved3     at 0 range 14 .. 15;
         pwmcmp0center at 0 range 16 .. 16;
         pwmcmp1center at 0 range 17 .. 17;
         pwmcmp2center at 0 range 18 .. 18;
         pwmcmp3center at 0 range 19 .. 19;
         Reserved4     at 0 range 20 .. 23;
         pwmcmp0gang   at 0 range 24 .. 24;
         pwmcmp1gang   at 0 range 25 .. 25;
         pwmcmp2gang   at 0 range 26 .. 26;
         pwmcmp3gang   at 0 range 27 .. 27;
         pwmcmp0ip     at 0 range 28 .. 28;
         pwmcmp1ip     at 0 range 29 .. 29;
         pwmcmp2ip     at 0 range 30 .. 30;
         pwmcmp3ip     at 0 range 31 .. 31;
      end record;

      -- 20.6 Scaled PWM Count Register (pwms)

      type pwms_Type is
      record
         pwms     : Bits_16;      -- Scaled PWM count register. cmpwidth bits wide.
         Reserved : Bits_16 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pwms_Type use
      record
         pwms     at 0 range 0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      -- 20.7 PWM Compare Registers (pwmcmp0–pwmcmp3)

      type pwmcmp_Type is
      record
         pwmcmp   : Bits_16;      -- PWM [0 .. 3] Compare Value
         Reserved : Bits_16 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for pwmcmp_Type use
      record
         pwmcmp   at 0 range 0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

   end PWM;

end HiFive1;
