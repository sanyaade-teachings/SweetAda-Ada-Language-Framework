-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions.ads                                                                                      --
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

with System;
with Interfaces;
with Interfaces.C;
with Bits;

package Memory_Functions
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- C-style function subprograms, with the same semantics and argument order
   -- (destination address first).
   ----------------------------------------------------------------------------

   function Memcmp
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return Interfaces.C.int
      with Inline => True;

   function Memcpy
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      with Inline => True;

   function Memmove
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      with Inline => True;

   function Memset
      (S : System.Address;
       C : Interfaces.C.int;
       N : Interfaces.C.size_t)
      return System.Address
      with Inline => True;

   ----------------------------------------------------------------------------
   -- C-style procedure subprograms with inverted arguments (source address
   -- first).
   ----------------------------------------------------------------------------

   procedure Cmpmem
      (S1 : in     System.Address;
       S2 : in     System.Address;
       N  : in     Bits.Bytesize;
       R  : in out Integer)
      with Inline => True;

   procedure Cpymem
      (S1 : in System.Address;
       S2 : in System.Address;
       N  : in Bits.Bytesize)
      with Inline => True;

   procedure Movemem
      (S1 : in System.Address;
       S2 : in System.Address;
       N  : in Bits.Bytesize)
      with Inline => True;

   procedure Setmem
      (S : in System.Address;
       V : in Interfaces.Unsigned_8;
       N : in Bits.Bytesize)
      with Inline => True;

end Memory_Functions;
