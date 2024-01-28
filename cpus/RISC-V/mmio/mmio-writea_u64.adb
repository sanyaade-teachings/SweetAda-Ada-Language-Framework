-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmio-writea_u64.adb                                                                                       --
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

separate (MMIO)
procedure WriteA_U64
   (Memory_Address : in System.Address;
    Value          : in Interfaces.Unsigned_64)
   is
   ATOMIC_SEQ_CST : constant Integer := 5;
   procedure Atomic_Store
      (Ptr      : System.Address;
       Val      : Interfaces.Unsigned_64;
       Memorder : Integer)
      with Import        => True,
           Convention    => Intrinsic,
           External_Name => "__atomic_store_8";
begin
   Atomic_Store (Memory_Address, Value, ATOMIC_SEQ_CST);
end WriteA_U64;
