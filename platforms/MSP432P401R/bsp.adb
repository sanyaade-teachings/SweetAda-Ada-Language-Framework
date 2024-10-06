-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Definitions;
with Bits;
with CPU;
with ARMv7M;
with MSP432P401R;
with Exceptions;
with Console;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Definitions;
   use Bits;
   use MSP432P401R;

   procedure SysTick_Init;
   procedure Clk_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init
      is
   begin
      -- The LED is toggled every 1000 ticks, so that in 2000 ticks a complete
      -- 1s-cycle can be observed @ 24 MHz CPU clock (MCLK)
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (24_000_000 / 2_000);
      ARMv7M.SHPR3.PRI_15 := 16#01#;
      ARMv7M.SYST_CVR.CURRENT := 0;
      ARMv7M.SYST_CSR := (
         ENABLE    => True,
         TICKINT   => True,
         CLKSOURCE => ARMv7M.CLKSOURCE_CPU,
         COUNTFLAG => False,
         others    => <>
         );
   end SysTick_Init;

   ----------------------------------------------------------------------------
   -- Clk_Init
   ----------------------------------------------------------------------------
   -- Initialize clocks, HFXT = 48 MHz
   -- MCLK CPU:     24 MHz
   -- HSMCLK/SMCLK: 12 MHz
   ----------------------------------------------------------------------------
   procedure Clk_Init
      is
   begin
      CSKEY.CSKEY := CSKEY_CSKEY;
      while True loop
         exit when CSSTAT.REFO_ON;
      end loop;
      -- set primary module for HFXT
      PJ.PxSELC (2) := False;
      PJ.PxSEL0 (2) := True;
      PJ.PxSEL1 (2) := False;
      PJ.PxSELC (3) := False;
      PJ.PxSEL0 (3) := True;
      PJ.PxSEL1 (3) := False;
      -- HFX, 48 MHz external source
      CSCTL2 := (
         LFXTDRIVE  => LFXTDRIVE_0,
         LFXT_EN    => False,
         LFXTBYPASS => LFXTBYPASS_EXTAL,
         HFXTDRIVE  => HFXTDRIVE_5_48,
         HFXTFREQ   => HFXTFREQ_41_48,
         HFXT_EN    => True,
         HFXTBYPASS => HFXTBYPASS_EXTAL,
         others     => <>
         );
      -- wait until HFXT oscillator does not fail
      while True loop
         CSCLRIFG.CLR_HFXTIFG := True;
         for Delay_Loop_Count in 1 .. 1024 loop CPU.NOP; end loop;
         exit when CSSTAT.HFXT_ON and then not CSIFG.HFXTIFG;
      end loop;
      -- clock enables
      CSCLKEN := (
         ACLK_EN   => True,
         MCLK_EN   => True,
         HSMCLK_EN => True,
         SMCLK_EN  => True,
         VLO_EN    => False,
         REFO_EN   => True,
         MODOSC_EN => False,
         REFOFSEL  => REFOFSEL_32k,
         others => <>
         );
      -- check for readiness
      declare
         Clock_Status : CSSTAT_Type;
      begin
         while True loop
            Clock_Status := CSSTAT;
            exit when Clock_Status.ACLK_READY   and then
                      Clock_Status.BCLK_READY   and then
                      Clock_Status.MCLK_READY   and then
                      Clock_Status.SMCLK_READY  and then
                      Clock_Status.HSMCLK_READY;
         end loop;
      end;
      -- MCLK = 24 MHz (core clock), SMCLK = 12 MHz (peripherals)
      CSCTL1 := (
         SELM   => SELM_HFXTCLK,
         SELS   => SELS_HFXTCLK,
         SELA   => SELA_REFOCLK,
         SELB   => SELB_REFOCLK,
         DIVM   => DIVM_DIV2,
         DIVHS  => DIVHS_DIV4,
         DIVA   => DIVA_DIV4,
         DIVS   => DIVS_DIV4,
         others => <>
         );
      -- check for readiness
      declare
         Clock_Status : CSSTAT_Type;
      begin
         while True loop
            Clock_Status := CSSTAT;
            exit when Clock_Status.ACLK_READY   and then
                      Clock_Status.BCLK_READY   and then
                      Clock_Status.MCLK_READY   and then
                      Clock_Status.SMCLK_READY  and then
                      Clock_Status.HSMCLK_READY;
         end loop;
      end;
      -- disable DCO
      CSCTL0 := (
         DCOTUNE => 0,
         DCORSEL => DCORSEL_48M,
         DCORES  => False,
         DCOEN   => False,
         others  => <>
         );
   end Clk_Init;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop
         exit when not eUSCI_A0.UCAxSTATW.UCBUSY;
      end loop;
      eUSCI_A0.UCAxTXBUF.UCTXBUFx := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- stop WDT -------------------------------------------------------------
      MSP432P401R.WDTCTL := (
         WDTIS    => WDTIS_DIV2E15,
         WDTCNTCL => False,
         WDTTMSEL => WDTTMSEL_WATCHDOG,
         WDTSSEL  => WDTSSEL_SMCLK,
         WDTHOLD  => True,
         WDTPW    => WDTPW_PASSWD
         );
      -- PCM ------------------------------------------------------------------
      PCMCTL0.AMR := AMR_AM_LDO_VCORE0;
      while True loop
         exit when PCMCTL0.CPM = CPM_AM_LDO_VCORE0;
      end loop;
      -- Port mapping initialization ------------------------------------------
      PMAPKEYID.PMAPKEYx := PMAPKEYx_KEY;
      PMAPCTL.PMAPRECFG := True;
      -- Clock ----------------------------------------------------------------
      Clk_Init;
      -- USCI_A0 --------------------------------------------------------------
      eUSCI_A0.UCAxCTLW0.UCSWRST := True;
      eUSCI_A0.UCAxIRCTL.UCIREN := False;
      eUSCI_A0.UCAxBRW := 78; -- 9600 bps @ SMCLK = 12 MHz
      eUSCI_A0.UCAxMCTLW := (
         UCOS16 => True,
         UCBRFx => 2,
         UCBRSx => 0,
         others => <>
         );
      eUSCI_A0.UCAxCTLW0 := (
         UCSWRST => True,
         UCSSELx => UCSSELx_SMCLK,
         UCSYNC  => False,
         UCMODEx => UCMODEx_UART,
         UCSPB   => UCSPB_1,
         UC7BIT  => UC7BIT_8,
         UCMSB   => UCMSB_LSB,
         UCPAR   => UCPAR_ODD,
         UCPEN   => False,
         others  => <>
         );
      P1.PxSELC (2) := False;
      P1.PxSEL0 (2) := True;
      P1.PxSEL1 (2) := False;
      P1.PxREN  (2) := False;
      P1.PxSELC (3) := False;
      P1.PxSEL0 (3) := True;
      P1.PxSEL1 (3) := False;
      P1.PxREN  (3) := False;
      eUSCI_A0.UCAxCTLW0.UCSWRST := False;
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("MSP432P401R", NL => True);
      -------------------------------------------------------------------------
      ARMv7M.Irq_Enable;
      ARMv7M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
