-----------------------------------------------------------------------
--  coinproblem.adb
--  PSE Blatt 3
--  Version:    1
--  Datum:      05. 11. 2011
--  Autoren:    Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure coinproblem is
   wert : Natural := 1;
   rest : Natural;
   elfer : Natural;
   siebner : Natural;
   einer : Natural;
   
   optimal  : Natural;
begin
   Put_Line ("Wert?");
   Get (wert);
   
   elfer := wert / 11;
   
   optimal := Natural'Last;
   
   for e in 0 .. elfer loop
      rest := wert - e * 11;
      siebner := rest / 7;
      rest := rest mod 7;
      einer := rest;
      if (einer + siebner + e) < optimal then
         optimal := einer + siebner + e;
      end if;
   end loop;
   
   Put_Line (Integer'Image (optimal));
   
   exception
      when Constraint_Error =>
         Put ("Zahl ausserhalb des zulaessigen Bereiches");
end coinproblem;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;