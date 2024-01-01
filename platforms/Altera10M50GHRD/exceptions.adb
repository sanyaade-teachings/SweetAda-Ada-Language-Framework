-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with Interfaces;
with Configure;
with GHRD;
with BSP;
with IOEMU;

package body Exceptions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
      is
   begin
      if GHRD.Timer.Status.TO then
         BSP.Tick_Count := @ + 1;
         if Configure.USE_QEMU_IOEMU then
            -- IRQ pulsemeter
            IOEMU.IO0 := 1;
         end if;
         GHRD.Timer.Status.TO := False;
      end if;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   null;

end Exceptions;
