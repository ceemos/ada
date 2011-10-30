-----------------------------------------------------------------------
-- for_schleifen.adb
-- PSE Aufgabenblatt 2
-- Version:	1
-- Datum:	30. 10. 2011
-- Autoren: 	Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
procedure for_schleifen is
   
   function produkt_a(x, n: Integer) return Integer is
      ergebnis: Integer;
   begin
      ergebnis := 1;
      for i in 1..x loop
         ergebnis := ergebnis * n;
      end loop;
      return ergebnis;
   end;
   
   function produkt_b(x, n: Integer) return Float is
      ergebnis: Float;
   begin
      ergebnis := 1.0;
      for i in x..2*x loop
         ergebnis := ergebnis * ( 1.0 / Float(n) );
      end loop;
      return ergebnis;
   end;
   
   x, n, ergebnis_int: Integer;
   ergebnis_float: Float;
begin
   Put_Line("Geben Sie x an:");
   Get(x);
   Put_Line("Geben Sie n an:");
   Get(n);
   
   ergebnis_int := produkt_a(x, n);
   Put("Ergebnis a): ");
   Put(ergebnis_int);
   New_Line;
   
   ergebnis_float := produkt_b(x, n);
   Put("Ergebnis b): ");
   Put(ergebnis_float);
   New_Line;
   
end for_schleifen;

-- kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; line-numbers on; space-indent on; mixed-indent off