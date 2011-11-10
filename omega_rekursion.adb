--  FILE: omega_rekursion.adb
--
--  PROJECT: Programmieruebungen , Uebungsblatt 3
--  VERSION: 2
--  DATE: 10. 11, 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  <PROCEDURE> omega_rekursion
--
--  Diese Prozedur berechnet mit Hilfe einer rekursiven Funktion eine 
--  vorgegebene math. Funktion.
--


with Ada.Text_IO;
use Ada.Text_IO;
procedure omega_rekursion is
   function omega (a, b : Natural) return Natural is
   begin
      --  Put_Line ("in omega" & Integer'Image (a) & " " & Integer'Image (b));
      if a = 0 then --  Unterscheidung der 4 mgl. Definitionen
         return b**2;
      elsif b = 0 then
         return omega (1, a);
      elsif a = b then
         return omega (a - 1, a + 1);
      else
         return omega (a - 1, omega (b - 1, a - 1));
      end if;
   end omega;
   
   --  Zahlen fuer den Test
   test_a : array (1 .. 4) of Natural := (1, 2, 2, 4);
   test_b : array (1 .. 4) of Natural := (3, 1, 2, 0);
   
begin
   --  fuer vier Wertepaare Testen
   for i in test_a'Range loop
      Put_Line ("a =" & Integer'Image (test_a (i)) & ", " & 
                "b =" & Integer'Image (test_b (i)) & ", " & 
            "omega =" & Integer'Image (omega (test_a (i), test_b (i))));
   end loop;
end omega_rekursion;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;