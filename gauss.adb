--  @File: gauss.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 8
--  @Version: 1
--  @Created: 11. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Gauss
--


with Ada.Text_IO;
use Ada.Text_IO;
with Rationale_Zahlen;
use Rationale_Zahlen;
procedure Gauss is
   N : constant := 3;
begin

   declare 
      type Matrix_Array is array (1 .. N + 1, 1 .. N) of Rationale_Zahl;
      type Matrix is access Matrix_Array; 
      
      type Vektor_Array is array (1 .. N) of Rationale_Zahl; 
      type Vektor is access Vektor_Array;
      
      procedure Put (Mat : Matrix) is
      begin
         for Y in 1 .. N loop
            case Y is
               when 1 => Put ("/");
               when N => Put ("\");
               when others => Put ("|");
            end case;
            for X in 1 .. N + 1 loop
               Put (Mat (X, Y));
               case X is
                  when N => Put ("|");
                  when N + 1 => null;
                  when others => Put (",");
                  --  Put (Character'Val (16#09#));
               end case;
            end loop;
            case Y is
               when 1 => Put ("\");
               when N => Put ("/");
               when others => Put ("|");
            end case;
            New_Line;
         end loop;
      end Put;
      
      procedure Put (V : Vektor) is
      begin
         Put ("(");
         for I in 1 .. N loop
            Put (V (I));
            if I /= N then 
               Put (",");
            end if;
         end loop;
         Put (")");
      end Put;
      
      procedure Get (Mat : Matrix) is
      begin
         for Y in 1 .. N loop
            Put_Line ("Geben Sie Werte fuer die" & Y'Img & ". Zeile an"); 
            for X in 1 .. N + 1 loop
               Put_Line ("Geben Sie den" & X'Img & ". Wert an"); 
               Get (Mat (X, Y));
            end loop;
         end loop;
      end Get;
      
      function Null_Matrix return Matrix is
         Mat : Matrix;
      begin
         Mat := new Matrix_Array;
         for Y in 1 .. N loop
            for X in 1 .. N + 1 loop
               Set (Mat (X, Y), 0, 1);
            end loop;
         end loop;
         return Mat;
      end Null_Matrix;
      
      procedure Eliminiere (Mat : in out Matrix) is 
         Faktor : Rationale_Zahl;
      begin
         for Schritt in 1 .. N - 1 loop
            if Mat (Schritt, Schritt) = 0 / 1 then
               --  TODO
               null;
            end if;
            for Zeile in Schritt + 1 .. N loop
               Set (Faktor, Mat (Schritt, Schritt) / Mat (Schritt, Zeile));
               for Spalte in 1 .. N + 1 loop
                  Put ("Schritt: " & Schritt'Img & " Zeile:" & Zeile'Img
                          & " Spalte:" & Spalte'Img & " Faktor:");
                  Put (Faktor);
                  New_Line;
                  Set (Mat (Spalte, Zeile), Mat (Spalte, Zeile) * Faktor
                                            - Mat (Spalte, Schritt));
                  Put (Mat);
               end loop;
            end loop;
         end loop;
      end Eliminiere;
      
      
      function Setze_Rueckwaerts_Ein (Mat : Matrix) return Vektor is
         Erg : Vektor;
      begin
         Erg := new Vektor_Array;
         Set (Erg (3), Mat (4, 3) / Mat (3, 3));
         Set (Erg (2), (Mat (4, 2) - Erg (3) * Mat (3, 2)) / Mat (2, 2));
         Set (Erg (1), (Mat (4, 1) - Erg (3) * Mat (3, 1) 
                                   - Erg (2) * Mat (2, 1)) / Mat (1, 1));
         return Erg;
      end Setze_Rueckwaerts_Ein;
         
               
      
      Mat : Matrix := Null_Matrix;
      
   begin
      Put (Mat);
      Get (Mat);
      Put (Mat);
      Eliminiere (Mat);
      Put (Mat);
      Put (Setze_Rueckwaerts_Ein (Mat));
   end;
      
end Gauss;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;