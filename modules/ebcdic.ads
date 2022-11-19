-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ebcdic.ads                                                                                                --
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

with System.Storage_Elements;

package EBCDIC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   package SSE renames System.Storage_Elements;

   type EBCDIC_String is array (Positive range <>) of SSE.Storage_Element with
      Pack => True;

   ----------------------------------------------------------------------------
   -- CodePage 437 (CP 437, OEM 437, PC-8, MS-DOS Latin US) --> EBCDIC
   ----------------------------------------------------------------------------

   ASCII2EBCDIC : constant array (0 .. 255) of SSE.Storage_Element :=
      [
       -- NUL     SOH     STX     ETX     EOT     ENQ     ACK     BEL
       16#00#, 16#01#, 16#02#, 16#03#, 16#37#, 16#2D#, 16#2E#, 16#2F#,
       --  BS      HT      LF      VT      FF      CR      SO      SI
       16#16#, 16#05#, 16#15#, 16#0B#, 16#0C#, 16#0D#, 16#0E#, 16#0F#,
       -- DLE     DC1     DC2     DC3     DC4     NAK     SYN     ETB
       16#10#, 16#11#, 16#12#, 16#13#, 16#3C#, 16#3D#, 16#32#, 16#26#,
       -- CAN      EM     SUB     ESC      FS      GS      RS      US
       16#18#, 16#19#, 16#3F#, 16#27#, 16#22#, 16#1D#, 16#1E#, 16#1F#,
       --  SP       !       "       #       $       %       &       '
       16#40#, 16#5A#, 16#7F#, 16#7B#, 16#5B#, 16#6C#, 16#50#, 16#7D#,
       --   (       )       *       +       ,       -       .       /
       16#4D#, 16#5D#, 16#5C#, 16#4E#, 16#6B#, 16#60#, 16#4B#, 16#61#,
       --   0       1       2       3       4       5       6       7
       16#F0#, 16#F1#, 16#F2#, 16#F3#, 16#F4#, 16#F5#, 16#F6#, 16#F7#,
       --   8       9       :       ;       <       =       >       ?
       16#F8#, 16#F9#, 16#7A#, 16#5E#, 16#4C#, 16#7E#, 16#6E#, 16#6F#,
       --   @       A       B       C       D       E       F       G
       16#7C#, 16#C1#, 16#C2#, 16#C3#, 16#C4#, 16#C5#, 16#C6#, 16#C7#,
       --   H       I       J       K       L       M       N       O
       16#C8#, 16#C9#, 16#D1#, 16#D2#, 16#D3#, 16#D4#, 16#D5#, 16#D6#,
       --   P       Q       R       S       T       U       V       W
       16#D7#, 16#D8#, 16#D9#, 16#E2#, 16#E3#, 16#E4#, 16#E5#, 16#E6#,
       --   X       Y       Z       [       \       ]       ^       _
       16#E7#, 16#E8#, 16#E9#, 16#BA#, 16#E0#, 16#BB#, 16#B0#, 16#6D#,
       --   `       a       b       c       d       e       f       g
       16#79#, 16#81#, 16#82#, 16#83#, 16#84#, 16#85#, 16#86#, 16#87#,
       --   h       i       j       k       l       m       n       o
       16#88#, 16#89#, 16#91#, 16#92#, 16#93#, 16#94#, 16#95#, 16#96#,
       --   p       q       r       s       t       u       v       w
       16#97#, 16#98#, 16#99#, 16#A2#, 16#A3#, 16#A4#, 16#A5#, 16#A6#,
       --   x       y       z       {       |       }       ~     DEL
       16#A7#, 16#A8#, 16#A9#, 16#C0#, 16#4F#, 16#D0#, 16#A1#, 16#07#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#59#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#3F#,
       --
       16#90#, 16#3F#, 16#3F#, 16#3F#, 16#3F#, 16#EA#, 16#3F#, 16#FF#
      ];

   procedure To_EBCDIC (S1 : in String; S2 : out EBCDIC_String);

end EBCDIC;
