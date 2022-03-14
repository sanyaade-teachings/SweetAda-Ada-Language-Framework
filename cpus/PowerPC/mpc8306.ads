-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mpc8306.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;

package MPC8306 is

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

   IMMRBAR : constant := 16#FF40_0000#;

   SICR_1 : Unsigned_32 with
      Address              => To_Address (IMMRBAR + 16#0114#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   SICR_2 : Unsigned_32 with
      Address              => To_Address (IMMRBAR + 16#0118#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   GP1DIR : Unsigned_32 with
      Address              => To_Address (IMMRBAR + 16#0C00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GP1ODR : Unsigned_32 with
      Address              => To_Address (IMMRBAR + 16#0C04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GP1DAT : Unsigned_32 with
      Address              => To_Address (IMMRBAR + 16#0C08#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   UART1_URBR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4500#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_UTHR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4500#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_UDLB : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4500#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_UIER : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4501#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_UDMB : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4501#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_ULCR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4503#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_UMCR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4504#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART1_ULSR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4505#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   UART2_URBR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4600#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_UTHR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4600#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_UDLB : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4600#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_UIER : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4601#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_UDMB : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4601#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_ULCR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4603#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_UMCR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4604#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   UART2_ULSR : Unsigned_8 with
      Address              => To_Address (IMMRBAR + 16#4605#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end MPC8306;
