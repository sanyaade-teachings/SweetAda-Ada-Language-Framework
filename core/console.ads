-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console.ads                                                                                               --
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
with Interfaces.C;
with Bits;

package Console is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   package SSE renames System.Storage_Elements;

   Maximum_String_Length : constant := 256;

   subtype Decimal_Digit_Type is Natural range 0 .. 9;

   type Row_Size_Type is range 1 .. 64;

   type Console_Write_Ptr is access procedure (C : in Character);
   type Console_Read_Ptr is access procedure (C : out Character);

   type Console_Descriptor_Type is
   record
      Write : not null Console_Write_Ptr;
      Read  : not null Console_Read_Ptr;
   end record;

   function To_Ch (Digit : Decimal_Digit_Type) return Character with
      Inline => True;

   procedure Console_Null_Write (C : in Character);
   procedure Console_Null_Read (C : out Character);

   Console_Descriptor : Console_Descriptor_Type := (Console_Null_Write'Access, Console_Null_Read'Access);

   -- Print (Character)
   procedure Print (C : in Character);

   -- Print (cchar)
   procedure Print (c : in Interfaces.C.char) with
      Export        => True,
      Convention    => Ada,
      External_Name => "console__print__cchar";

   procedure Print_NewLine;

   -- Print[_String]
   procedure Print_String (
                           S     : in String;
                           Limit : in Natural := Maximum_String_Length;
                           NL    : in Boolean := False
                          );
   procedure Print (
                    S     : in String;
                    Limit : in Natural := Maximum_String_Length;
                    NL    : in Boolean := False
                   ) renames Print_String;

   -- Print (Boolean)
   procedure Print (
                    Value  : in Boolean;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print (Bits_1)
   procedure Print (
                    Value  : in Bits.Bits_1;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print (Unsigned_8)
   procedure Print (
                    Value  : in Interfaces.Unsigned_8;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print (Unsigned_16)
   procedure Print (
                    Value  : in Interfaces.Unsigned_16;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print (Unsigned_32)
   procedure Print (
                    Value  : in Interfaces.Unsigned_32;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print (Unsigned_64)
   procedure Print (
                    Value  : in Interfaces.Unsigned_64;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print[_Integer_Address]
   procedure Print_Integer_Address (
                                    Value  : in SSE.Integer_Address;
                                    NL     : in Boolean := False;
                                    Prefix : in String := "";
                                    Suffix : in String := ""
                                   );
   procedure Print (
                    Value  : in SSE.Integer_Address;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) renames Print_Integer_Address;

   -- Print (Address)
   procedure Print (
                    Value  : in System.Address;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   );

   -- Print[_Integer]
   procedure Print_Integer (
                            Value  : in Integer;
                            NL     : in Boolean := False;
                            Prefix : in String := "";
                            Suffix : in String := ""
                           );
   procedure Print (
                    Value  : in Integer;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) renames Print_Integer;

   -- Print[_sizet]
   procedure Print_sizet (
                          s      : in Interfaces.C.size_t;
                          NL     : in Boolean := False;
                          Prefix : in String := "";
                          Suffix : in String := ""
                         );
   procedure Print (
                    s      : in Interfaces.C.size_t;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) renames Print_sizet;

   -- Print_BitImage
   procedure Print_BitImage (
                             Value  : in Interfaces.Unsigned_8;
                             NL     : in Boolean := False;
                             Prefix : in String := "";
                             Suffix : in String := ""
                            );

   -- Print[_Byte_Array]
   procedure Print_Byte_Array (
                               ByteArray : in Bits.Byte_Array;
                               Limit     : in Natural := 0;
                               NL        : in Boolean := False;
                               Prefix    : in String := "";
                               Separator : in Character := ' '
                              );
   procedure Print (
                    ByteArray : in Bits.Byte_Array;
                    Limit     : in Natural := 0;
                    NL        : in Boolean := False;
                    Prefix    : in String := "";
                    Separator : in Character := ' '
                   ) renames Print_Byte_Array;

   -- Print_ASCIIZ_String
   procedure Print_ASCIIZ_String (
                                  String_Ptr : in System.Address;
                                  NL         : in Boolean := False;
                                  Prefix     : in String := "";
                                  Suffix     : in String := ""
                                 );

   -- Print_Memory
   procedure Print_Memory (
                           Start_Address : in System.Address;
                           Data_Size     : in Bits.Bytesize;
                           Row_Size      : in Row_Size_Type := 16
                          );

end Console;
