-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-textfile.ads                                                                                        --
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

package FATFS.Textfile
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a text file by directory entry.
   ----------------------------------------------------------------------------
   procedure Open
      (D       : in     Descriptor_Type;
       File    :    out TFCB_Type;
       DE      : in     Directory_Entry_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a text file by name.
   ----------------------------------------------------------------------------
   procedure Open
      (D         : in     Descriptor_Type;
       File      :    out TFCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind a text file.
   ----------------------------------------------------------------------------
   procedure Rewind
      (D    : in     Descriptor_Type;
       File : in out TFCB_Type);

   ----------------------------------------------------------------------------
   -- Read_Char
   ----------------------------------------------------------------------------
   -- Read the next character.
   ----------------------------------------------------------------------------
   procedure Read_Char
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       C       :    out Character;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Read_Line
   ----------------------------------------------------------------------------
   -- Read the next line.
   ----------------------------------------------------------------------------
   procedure Read_Line
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Line    :    out String;
       Last    :    out Natural;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read a binary record.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Buffer  :    out Byte_Array;
       Count   :    out Unsigned_16;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read an Unsigned_8.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_8;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read an Unsigned_16.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_16;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read an Unsigned_32.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_32;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a text file (READ).
   ----------------------------------------------------------------------------
   procedure Close
      (D    : in     Descriptor_Type;
       File : in out TFCB_Type);

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open an existing file for text writing (WRITE).
   ----------------------------------------------------------------------------
   procedure Open
      (D         : in out Descriptor_Type;
       File      :    out TWCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   ----------------------------------------------------------------------------
   -- Create
   ----------------------------------------------------------------------------
   -- Create a file.
   ----------------------------------------------------------------------------
   procedure Create
      (D         : in out Descriptor_Type;
       File      :    out TWCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write a character.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       C       : in     Character;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write a string of text.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Text    : in     String;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write_NewLine
   ----------------------------------------------------------------------------
   -- Write a line terminator.
   ----------------------------------------------------------------------------
   procedure Write_Line
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Text    : in     String;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write_Line
   ----------------------------------------------------------------------------
   -- Write one line of text (plus a terminating newline).
   ----------------------------------------------------------------------------
   procedure Write_NewLine
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write a binary record.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Buffer  : in     Byte_Array;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an Unsigned_8.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_8;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an Unsigned_16.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_16;
       Success : out    Boolean);

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an Unsigned_32.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_32;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Sync
   ----------------------------------------------------------------------------
   -- Force update of file size in directory entry.
   ----------------------------------------------------------------------------
   procedure Sync
      (D       : in     Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a text file (WRITE).
   ----------------------------------------------------------------------------
   procedure Close
      (D       : in     Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean);

end FATFS.Textfile;
