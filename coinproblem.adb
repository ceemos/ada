--  FILE: coinproblem.adb
--
--  PROJECT: Programmieruebungen , Uebungsblatt 3
--  VERSION: 2
--  DATE: 05. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  <PROCEDURE> coinproblem
--
-- Berechnet die minimale Anzahl Muenzen, die noetig sind, um einen gegebenen 
-- Wert nur mit Muenzen mit den Werten 1, 7, und 11 darzustellen.
--

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure coinproblem is
   --  Darzustellender Wert
   wert    : Natural;
   
   --  Variablen fuer die Berechnung
   rest    : Natural;
   elfer   : Natural;
   siebner : Natural;
   einer   : Natural;
   
   --  Ergebnis der Berechnung
   optimal : Natural;
   
begin
   --  Wert vom Benutzer entgegen nehmen
   Put_Line ("Wert?");
   Get (wert);
   
   --  Maximale Anzahl Elfer bestimmen
   elfer := wert / 11;
   
   --  Startwert der Optimierung
   optimal := Natural'Last;
   
   --  Alle sinnvollen Anzahlen Elfer durchgehen
   for e in 0 .. elfer loop
   
      --  Anzahl Siebner und Einer berechnen
      rest := wert - e * 11;
      siebner := rest / 7;
      einer := rest mod 7;
      
      --  Pruefen, ob die Lsg. besser als die vorhergehenden war, ggf. merken
      if (einer + siebner + e) < optimal then
         optimal := einer + siebner + e;
      end if;
   end loop;
   
   Put_Line ("Minimale Anzahl Muenzen: "  & Integer'Image (optimal));
   
   exception
      --  falsche Eingabe abfangen
      when Constraint_Error =>
         Put_Line ("Zahl ausserhalb des zulaessigen Bereiches");
         coinproblem; --  richtige Eingabe erzwingen.
         
      when Data_Error =>
         Put_Line ("Geben sie eine Zahl an. Beende.");
         --  Neustart aufwaendig, wg. leeren des Input-Buffers.
         
end coinproblem;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;