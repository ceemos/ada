-----------------------------------------------------------------------
-- schleifen_umformung.adb
-- PSE Aufgabenblatt 2
-- Version:	1
-- Datum:	30. 10. 2011
-- Autoren: 	Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure schleifen_umformung is
   X, Limit, Result:    Integer; -- Variablen aus den Codeschnippseln
   I, J:        Integer; -- Laufvariablen
begin
   
   X      := 7; -- Beispielwerte
   Limit  := 3;
   Result := 0;
   
   -- Aufgabe a)
--    for I in X .. 2 * X loop
--       Result := Result + X;
--    end loop;
   
   I := X;
   while I <= (2 * X) loop
      Result := Result + X;
      I := I + 1;
   end loop;
   
   Put(Result); -- Damit man das Ergebnis auch sieht
   New_Line;
   
   for I in reverse 1 .. 10 loop
      Put_Line (Integer'Image (I));
   end loop;
   
   for I in 1 .. Limit loop
      for J in reverse I .. Limit loop
         Put (I );
         Put (" -- " );
         Put (J);
         Put (" -> " );
         Put (I * J);
      end loop;
   end loop;
 
end schleifen_umformung;

-- kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; line-numbers on; space-indent on; mixed-indent off