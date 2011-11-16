--  FILE: vector.adb
--
--  PROJECT: Programmieruebungen , Uebungsblatt 4
--  VERSION: 1
--  DATE: 14. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  <PROCEDURE> vektor
--  fuehrt Vektoroperationen mit ueberladenen Operatoren aus.
--


with Ada.Text_IO, Ada.Float_Text_IO;
procedure vektor is

   type Vektor is array (Natural range <>) of Float; 
   
   procedure Put (v : Vektor) is
   begin
      Ada.Text_IO.Put ("(");
      for I in v'Range loop
         --  es wird von eher uebersichtlichen Zahlen ausgegangen.
         Ada.Float_Text_IO.Put (v (I), 1, 4, 0);
         
         --  Komma nach der letzten Zahl unterdruecken
         if I /= v'Last then
            Ada.Text_IO.Put (", ");
         end if;
      end loop;
      Ada.Text_IO.Put_Line (")");
   end Put;
   
   procedure Get (v : out Vektor) is
      --  Aktuell eingelesene Zahl
      Zahl : Float;
   begin
      for I in v'Range loop
         Ada.Text_IO.Put_Line ("Geben Sie die " & Integer'Image (I) 
                              & ". Zahl ein!");
         Ada.Float_Text_IO.Get (Zahl);
         v (I) := Zahl;
      end loop;
   end Get;
   
   function "+" (a, b : Vektor) return Vektor is 
      Ergebnis : Vektor (a'Range);
   begin
      --  Exakt identischer Bereich, keine Verschiebung
      if a'First /= b'First or a'Last /= b'Last then 
         raise Constraint_Error;
      end if;
      
      for I in a'Range loop
         Ergebnis (I) := a (I) + b (I);
      end loop;
      
      return Ergebnis;
   end "+";
   
   function "*" (a : Vektor; skalar : Float) return Vektor is 
      Ergebnis : Vektor (a'Range);
   begin
      
      for I in a'Range loop
         Ergebnis (I) := a (I) * skalar;
      end loop;
      
      return Ergebnis;
   end "*";
   
   function "*" (skalar : Float; a : Vektor) return Vektor is 
   begin
      return a * skalar;
   end "*";
   
   function "*" (a, b : Vektor) return Float is 
      Ergebnis : Float := 0.0;
   begin
      --  Exakt identischer Bereich, keine Verschiebung
      if a'First /= b'First or a'Last /= b'Last then 
         raise Constraint_Error;
      end if;
      
      for I in a'Range loop
         Ergebnis := Ergebnis + (a (I) * b (I));
      end loop;
      
      return Ergebnis;
   end "*";
   
   function "**" (a, b : Vektor) return Vektor is 
      Ergebnis : Vektor (a'Range);
   begin
      --  Exakt identischer Bereich, keine Verschiebung, genau 3 Elemente
      if    a'First /= b'First or a'Last /= b'Last 
         or a'First /= 1       or a'Last /= 3      then 
         raise Constraint_Error;
      end if;
      
      Ergebnis (1) := (a (2) * b (3)) - (a (3) * b (2));
      Ergebnis (2) := (a (3) * b (1)) - (a (1) * b (3));
      Ergebnis (3) := (a (1) * b (2)) - (a (2) * b (1));
      
      return Ergebnis;
   end "**";
   
   
   v : Vektor (1 .. 3) := (0.5789, 100.0, 2.0);
   a : Vektor (1 .. 3);
   b : Vektor (1 .. 3); 
   e : Vektor (1 .. 3);
begin
   Get (a);
   Get (b);
   Put (a + b);
   Put (3.0 * a);
   Ada.Float_Text_IO.Put (a * b);
   Ada.Text_IO.New_Line;
   e := a ** b;
   Put (e);
   Ada.Float_Text_IO.Put (a * e);
   Ada.Text_IO.New_Line;
   Ada.Float_Text_IO.Put (b * e);
   Ada.Text_IO.New_Line;
end vektor;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;