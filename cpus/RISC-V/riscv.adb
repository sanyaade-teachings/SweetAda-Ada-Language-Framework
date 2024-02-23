-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.adb                                                                                                 --
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

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Definitions;

package body RISCV
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Definitions;

   ZICSR_ZIFENCEI_ASM : constant String := "        .option arch,+zicsr,+zifencei";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- mtvec_Write
   ----------------------------------------------------------------------------
   procedure mtvec_Write
      (mtvec : in mtvec_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       ZICSR_ZIFENCEI_ASM         & CRLF &
                       "        csrw    mtvec,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mtvec_Type'Asm_Input ("r", mtvec),
           Clobber  => "",
           Volatile => True
          );
   end mtvec_Write;

   ----------------------------------------------------------------------------
   -- mepc_Read
   ----------------------------------------------------------------------------
   function mepc_Read
      return MXLEN_Type
      is
      mepc : MXLEN_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       ZICSR_ZIFENCEI_ASM        & CRLF &
                       "        csrr    %0,mepc" & CRLF &
                       "",
           Outputs  => MXLEN_Type'Asm_Output ("=r", mepc),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return mepc;
   end mepc_Read;

   ----------------------------------------------------------------------------
   -- mcause_Read
   ----------------------------------------------------------------------------
   function mcause_Read
      return mcause_Type
      is
      mcause : mcause_Type;
   begin
      Asm (
           Template => ""                          & CRLF &
                       ZICSR_ZIFENCEI_ASM          & CRLF &
                       "        csrr    %0,mcause" & CRLF &
                       "",
           Outputs  => mcause_Type'Asm_Output ("=r", mcause),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return mcause;
   end mcause_Read;

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        jalr    x1,%0,0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Intcontext := 0; -- __TBD__
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
   begin
      null; -- __TBD__
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- mie_Set_Interrupt
   ----------------------------------------------------------------------------
   procedure mie_Set_Interrupt
      (mie : in mie_Type)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       ZICSR_ZIFENCEI_ASM          & CRLF &
                       "        csrrs   x0,mie,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mie_Type'Asm_Input ("r", mie),
           Clobber  => "",
           Volatile => True
          );
   end mie_Set_Interrupt;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
      function To_mstatus is new Ada.Unchecked_Conversion (MXLEN_Type, mstatus_Type);
      mstatus : mstatus_Type := To_mstatus (0);
   begin
      mstatus.MIE := True;
      Asm (
           Template => ""                              & CRLF &
                       ZICSR_ZIFENCEI_ASM              & CRLF &
                       "        csrrs   x0,mstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mstatus_Type'Asm_Input ("r", mstatus),
           Clobber  => "",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
      function To_mstatus is new Ada.Unchecked_Conversion (MXLEN_Type, mstatus_Type);
      mstatus : mstatus_Type := To_mstatus (0);
   begin
      mstatus.MIE := True;
      Asm (
           Template => ""                              & CRLF &
                       ZICSR_ZIFENCEI_ASM              & CRLF &
                       "        csrrc   x0,mstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mstatus_Type'Asm_Input ("r", mstatus),
           Clobber  => "",
           Volatile => True
          );
   end Irq_Disable;

end RISCV;
