-----------------------------------------------------------------------
-- fakultaet_bigint.adb
-- PSE 
-- Version:	1
-- Datum:	31. 10. 2011
-- Autoren: 	Marcel Schneider
-----------------------------------------------------------------------

with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;            use Ada.Integer_Text_IO;
with Interfaces;             use Interfaces;
procedure fakultaet_bigint is

type Long_Number is array (Natural range <>) of Unsigned_32;
 
   function "*" (Left, Right : Long_Number) return Long_Number is
      Result : Long_Number (0..Left'Length + Right'Length - 1) := (others => 0);
      Accum  : Unsigned_64;
   begin
      for I in Left'Range loop
         for J in Right'Range loop
            Accum := Unsigned_64 (Left (I)) * Unsigned_64 (Right (J));
            for K in I + J..Result'Last loop
               exit when Accum = 0;
               Accum := Accum + Unsigned_64 (Result (K));
               Result (K) := Unsigned_32 (Accum and 16#FFFF_FFFF#);
               Accum := Accum / 2**32;
            end loop;
         end loop;
      end loop;
      for Index in reverse Result'Range loop -- Normalization
         if Result (Index) /= 0 then
            return Result (0..Index);
         end if;
      end loop;
      return (0 => 0);
   end "*";
   
   procedure Div
            (  Dividend  : in out Long_Number;
               Last      : in out Natural;
               Remainder : out Unsigned_32;
               Divisor   : Unsigned_32
            )  is
      Div   : constant Unsigned_64 := Unsigned_64 (Divisor);
      Accum : Unsigned_64 := 0;
      Size  : Natural     := 0;
   begin
      for Index in reverse Dividend'First..Last loop
         Accum := Accum * 2**32 + Unsigned_64 (Dividend (Index));
         Dividend (Index) := Unsigned_32 (Accum / Div);
         if Size = 0 and then Dividend (Index) /= 0 then
            Size := Index;
         end if;
         Accum := Accum mod Div;
      end loop;
      Remainder := Unsigned_32 (Accum);
      Last := Size;
   end Div;

   procedure Put (Value : Long_Number) is
      X      : Long_Number := Value;
      Last   : Natural     := X'Last;
      Digit  : Unsigned_32;
      Result : Unbounded_String;
   begin
      loop
         Div (X, Last, Digit, 10);
         Append (Result, Character'Val (Digit + Character'Pos ('0')));
         exit when Last = 0 and then X (0) = 0;
      end loop;
      for Index in reverse 1..Length (Result) loop
         Put (Element (Result, Index));
      end loop;
   end Put;
   
   function fakultaet(n: Natural) return Long_Number is
   begin
      if n = 0 then
         return (0 => 1);
      else 
         return fakultaet(n - 1) * (0 => Unsigned_32(n));
      end if;
   end;
 
   X : Long_Number := (0 => 0, 1 => 0, 2 => 1) * (0 => 0, 1 => 0, 2 => 1);
   N: Natural;

begin
   
--    Put_Line("Geben Sie die Zahl an:");
--    Get(N);
   N := 10000;
   
   
   -- Augabe einer Zeile
   Put(N, 4); -- 4 Stellen n
   Put(" | ");
   Put(fakultaet(N)); -- 10 Stellen Ergebnis
   New_Line;
   
end fakultaet_bigint;

-- kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; line-numbers on; space-indent on; mixed-indent off