--  FILE: vektorberechnugen.adb
--
--  PROJECT: Programmieruebungen , Uebungsblatt 4
--  VERSION: 1
--  DATE: 14. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  <PROCEDURE> vektorberechnugen
--  Interaktives Programm das Vektoroperationen mit ueberladenen Operatoren 
--  ausfuehrt.
--


with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
procedure vektorberechnungen is

   type Vektor is array (Natural range <>) of Float; 
   
   --  PROCEDURE Put 
   --
   --  Gibt einen Vektor auf der Konsole aus.
   --
   --  PARAMETERS: 
   --   + v: Der auszugebende Vektor
   --  
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
   
   --  PROCEDURE Get 
   --
   --  Liest die Werte eines Vektors vom Benutzer ein.
   --  Die Anzahl Werte wird aus dem Vektor bestimmt.
   --
   --  PARAMETERS: 
   --   + v: Der einzulesende Vektor.
   --  
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
   
   --  FUNCTION "+" 
   --
   --  Addiert zwei Vektoren.
   --
   --  PARAMETERS: 
   --   + a: der 1. Vektor.
   --   + b: der 2. Vektor, muss gleich gross wie der 1. sein.
   --  
   --  RETURNS: die Vektorsumme, (gleich gross wie a und b)
   --  RAISE: Constraint_Error, falls die groessen nicht zusammenpassen
   --  
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
   
   --  FUNCTION "*" 
   --
   --  multipliziert einen Vektor mit einem Skalar
   --
   --  PARAMETERS: 
   --   + a: der Vektor
   --   + skalar: der Skalarfaktor
   --  
   --  RETURNS: der Vektor, mit dem Skalar multipliziert.
   --  
   function "*" (a : Vektor; skalar : Float) return Vektor is 
      Ergebnis : Vektor (a'Range);
   begin
      
      for I in a'Range loop
         Ergebnis (I) := a (I) * skalar;
      end loop;
      
      return Ergebnis;
   end "*";
   
   --  FUNCTION "*" 
   --
   --  multipliziert einen Vektor mit einem Skalar
   --
   --  PARAMETERS: 
   --   + a: der Vektor
   --   + skalar: der Skalarfaktor
   --  
   --  RETURNS: der Vektor, mit dem Skalar multipliziert.
   --
   function "*" (skalar : Float; a : Vektor) return Vektor is 
   begin
      return a * skalar;
   end "*";
   
   --  FUNCTION "*" 
   --
   --  berechnet das Skalarprodukt zweier Vektoren.
   --
   --  PARAMETERS: 
   --   + a: der 1. Vektor
   --   + b: der 2. Vektor. Muss gleich gross wie der 1. sein.
   --  
   --  RETURNS: das Skalarprodukt
   --  RAISE: Constraint_Error, falls die groessen nicht zusammenpassen
   --  
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
   
   --  FUNCTION "**" 
   --
   --  Berchnet der Kreuzprodukt zweier Vektoren der Dimension 3
   --
   --  PARAMETERS: 
   --   + a: der linke Vekotr
   --   + b: der rechte Vektor
   --  
   --  RETURNS: das Vektorprodukt a x b
   --  RAISE: Constraint_Error, falls die groessen ungleich 3 sind
   --  
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
   
   auswahl : Character;
   dimension : Positive;
   
begin
   loop
      Ada.Text_IO.Put_Line ("Was soll berechnet werden?");
      Ada.Text_IO.Put_Line ("a) Addition zweier Vektoren,");
      Ada.Text_IO.Put_Line ("b) Subtraktion zweier Vektoren,");
      Ada.Text_IO.Put_Line ("c) Multiplikation mit einem Skalar,");
      Ada.Text_IO.Put_Line ("d) Skalarprodukt,");
      Ada.Text_IO.Put_Line ("e) Kreuzprodukt,");
      Ada.Text_IO.Put_Line ("x) Beenden");
      
      Ada.Text_IO.Get (auswahl);
      
      case auswahl is
         when 'a' | 'b' | 'c' | 'd' =>
            Ada.Text_IO.Put_Line ("Anzahl Dimensionen?");
            Ada.Integer_Text_IO.Get (dimension);
            declare
               vec_a, vec_b : Vektor (1 .. dimension);
               skalar : Float;
            begin
               Ada.Text_IO.Put_Line ("Daten fuer 1. Vektor:");
               Get (vec_a);
               
               if auswahl /= 'c' then 
                  Ada.Text_IO.Put_Line ("Daten fuer 2. Vektor:");
                  Get (vec_b);
               end if;
               case auswahl is 
                  when 'a' =>
                     Put (vec_a + vec_b);
                  when 'b' =>
                     Put (vec_a + (vec_b * (-1.0)));
                  when 'c' =>
                     Ada.Text_IO.Put_Line ("Geben Sie den Skalar an:");
                     Ada.Float_Text_IO.Get (skalar);
                     Put (vec_a * skalar);
                  when 'd' =>
                     Ada.Float_Text_IO.Put (vec_a * vec_b, 1, 4, 0);
                     Ada.Text_IO.New_Line;
                  when others =>
                     null; --  sollte niemals auftreten, wg. aeusserem case 
               end case;
            end;
         when 'e' =>
            declare
               vec_a, vec_b : Vektor (1 .. 3);
            begin
               Ada.Text_IO.Put_Line ("Daten fuer 1. Vektor:");
               Get (vec_a);

               Ada.Text_IO.Put_Line ("Daten fuer 2. Vektor:");
               Get (vec_b);
               
               Put (vec_a ** vec_b);
            end;
         when 'x' =>
            exit;
         when others =>
            Ada.Text_IO.Put_Line ("Geben Sie bitte etwas vernuenftiges ein.");
      end case;
   end loop;
      


end vektorberechnungen;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;