-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.ads                                                                                                   --
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

with UART16x50;
with IDE;
with NE2000;
with Ethernet;

package BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use UART16x50;
   use NE2000;
   use Ethernet;

   UART_Descriptors    : array (1 .. 2) of aliased Uart16x50_Descriptor_Type :=
                         [others => Uart16x50_DESCRIPTOR_INVALID];
   IDE_Descriptors     : array (1 .. 1) of aliased IDE.Descriptor_Type :=
                         [others => IDE.DESCRIPTOR_INVALID];
   NE2000_Descriptors  : array (1 .. 1) of aliased NE2000_Descriptor_Type :=
                         [others => NE2000_DESCRIPTOR_INVALID];
   Ethernet_Descriptor : aliased Ethernet_Descriptor_Type := Ethernet_DESCRIPTOR_INVALID;

   QEMU : Boolean := False;

   procedure Tclk_Init;
   procedure Console_Putchar (C : in Character);
   procedure Console_Getchar (C : out Character);
   procedure Setup;
   procedure Reset;

end BSP;
