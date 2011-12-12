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
      type Matrix_Array is array (1 .. N, 1 .. N) of Rationale_Zahl;
      type Matrix is access Matrix_Array; 
      
      procedure Put (Mat : Matrix) is
      begin
         for Y in 1 .. N loop
            case Y is
               when 1 => Put ("/");
               when N => Put ("\");
               when others => Put ("|");
            end case;
            for X in 1 .. N loop
               Put (Mat (X, Y));
               if X /= N then
                  --  Put (Character'Val (16#09#));
                  Put (",");
               end if;
            end loop;
            case Y is
               when 1 => Put ("\");
               when N => Put ("/");
               when others => Put ("|");
            end case;
            New_Line;
         end loop;
      end Put;
      
      procedure Get (Mat : Matrix) is
      begin
         for Y in 1 .. N loop
            Put_Line ("Geben Sie Werte fuer die" & Y'Img & ". Zeile an"); 
            for X in 1 .. N loop
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
            for X in 1 .. N loop
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
               for Spalte in 1 .. N loop
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
               
      
      Mat : Matrix := Null_Matrix;
      
   begin
      Put (Mat);
      Get (Mat);
      Put (Mat);
      Eliminiere (Mat);
      Put (Mat);
   end;
      
end Gauss;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;