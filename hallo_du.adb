-----------------------------------------------------------------------
-- hallo_du.adb
-- PSE Übung 1
-- Version:	1
-- Datum:	25. 10. 2011
-- Autoren: 	Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
procedure hallo_du is
   name: Unbounded_String; -- Name des Users
begin
   Put_Line("Ihr Name?");
   name := Get_Line;
   
   Put("Hallo " ); -- Ausgabe in einer Zeile
   Put(name);
   Put_Line("!");
end hallo_du;

-- kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; line-numbers on; 