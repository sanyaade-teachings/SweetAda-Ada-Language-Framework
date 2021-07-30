-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits-byte_swap_32.adb                                                                                     --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

   separate (Bits)
   function Byte_Swap_32 (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      return ShR (Value and 16#FF00_0000#, 24) or
             ShR (Value and 16#00FF_0000#, 8) or
             ShL (Value and 16#0000_FF00#, 8) or
             ShL (Value and 16#0000_00FF#, 24);
   end Byte_Swap_32;
