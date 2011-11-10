-----------------------------------------------------------------------
-- fakultaet.adb
-- PSE Übung 1
-- Version:	1
-- Datum:	25. 10. 2011
-- Autoren: 	Marcel Schneider
-----------------------------------------------------------------------
-- Compile: gnatmake -gnatp fakultaet.adb
-----------------------------------------------------------------------
-- Erlaeuterungen:
-- - das Programm berechnet nur Werte bis 12! richtig. 
-- - die Werte von 13! bis 16! werden ausgegeben, sind aber falsch.
-- - ab 17! stuertzt das Programm ab: 
--   raised CONSTRAINT_ERROR : fakultaet.adb:26 range check failed
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure Fakultaet is
   N,
   Fak: Natural;
   
   grenzeUnten, grenzeOben: Natural;
begin
   Put_Line("Geben Sie die untere Grenze an:");
   Get(grenzeUnten);
   Put_Line("Geben Sie die obere Grenze an:");
   Get(grenzeOben);
   
   Put_Line("   N | Fak");
   for k in grenzeUnten..grenzeOben loop
      N := k;
      Fak := 1;
      for i in 1.. N loop
         Fak := Fak*i;
      end loop;
      
      -- Augabe einer Zeile
      Put(k, 4); -- 4 Stellen n
      Put(" | ");
      Put(Fak, 10); -- 10 Stellen Ergebnis
      New_Line;
      
   end loop;
end Fakultaet;


-- kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; line-numbers on; space-indent on; mixed-indent off