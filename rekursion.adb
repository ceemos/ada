-----------------------------------------------------------------------
--  rekursion.adb
--  PSE Aufgabenblatt 2
--  Version:    1
--  Datum:      30. 10. 2011
--  Autoren:    Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO;
use Ada.Text_IO;
procedure rekursion is

   --  Aufgabe b)
   --    for I in reverse 1 .. 10 loop
   --       Put_Line (Integer'Image (I));
   --    end loop;
   
   procedure for_I_in_reverse (I : in Integer) is
   begin
      Put_Line (Integer'Image (I));
      
      if I > 1 then --  Abbruchbedingung
         for_I_in_reverse (I - 1); --  rek. Aufruf
      end if;
   end for_I_in_reverse;

begin
   for_I_in_reverse (10);
end rekursion;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off