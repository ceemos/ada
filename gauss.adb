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
--  liest eine Beliebige grosse Matrix fuer ein LGS ein und loest das LGS.
--


with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Rationale_Zahlen;
use Rationale_Zahlen;

procedure Gauss is
   Anzahl_Unbekannte : Natural;
begin
   Put_Line ("Geben Sie die Anzahl unbekannte an:");
   Get (Anzahl_Unbekannte);

   declare 
      N : Natural := Anzahl_Unbekannte;
      type Matrix_Array is array (1 .. N + 1, 1 .. N) of Rationale_Zahl;
      type Matrix is access Matrix_Array; 
      
      type Vektor_Array is array (1 .. N) of Rationale_Zahl; 
      type Vektor is access Vektor_Array;
      
      --  @Procedure: Put 
      --
      --  gibt eine Matrix aus.
      --
      --  @Parameter: 
      --   + Mat: die Matrix.
      --  
      procedure Put (Mat : Matrix) is
      begin
         for Y in 1 .. N loop
            if Y = 1 then
               Put ("/");
            elsif Y = N then
               Put ("\");
            else
               Put ("|");
            end if;
            for X in 1 .. N + 1 loop
               Put (Mat (X, Y));
               if X = N then 
                  Put ("|");
               elsif X = N + 1 then
                  null;
               else
                  Put (",");
               end if;
            end loop;
            if Y = 1 then
               Put ("\");
            elsif Y = N then
               Put ("/");
            else
               Put ("|");
            end if;
            New_Line;
         end loop;
      end Put;
      
      --  @Procedure: Put 
      --
      --  Gibt einen Vektor aus.
      --
      --  @Parameter: 
      --   + V: der Vektor
      --  
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
      
      --  @Procedure: Get 
      --
      --  Liest eine Matrix vom Benutzer ein.
      --
      --  @Parameter: 
      --   + Mat: die Matrix, in der die Werte gespeichert werden sollen.
      --  
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
      
      --  @Function: Null_Matrix 
      --
      --  erzeugt eine neue Matrix und initialisiert sie mit (0/1).
      --
      --  @Return: eine Matrix mit Nullen.
      --
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
      
      --  @Procedure: Eliminiere_Iterativ 
      --
      --  Bringt eine Matrix in Zeilen-Stufen-Form 
      --  Verwendet einen Algorithmus, der ohne Rekursion auskommt.
      --
      --  @Parameter: 
      --   + Mat: die zu bearbeitende Matrix.
      --  
      procedure Eliminiere_Iterativ (Mat : in out Matrix) is 
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

                  Set (Mat (Spalte, Zeile), Mat (Spalte, Zeile) * Faktor
                                            - Mat (Spalte, Schritt));
               end loop;
            end loop;
         end loop;
      end Eliminiere_Iterativ;
     
      
      --  @Procedure: Eliminiere_Rekursiv 
      --
      --  Bringt eine Matrix in Zeilen-Stufen-Form.
      --  Verwendet den in der Aufgabe geg. Algorithmus.
      --
      --  @Parameter: 
      --   + Mat: die zu bearbeitende Matrix.
      --   + I: die Zeile in der gestartet werden soll.
      --   + J: die Spalte in der gestartet werden soll.
      --  
      procedure Eliminiere_Rekursiv (Mat : in out Matrix;
                              I : Natural := 1; J : Natural := 1) is
      begin
         if I = N + 1 or J > N then
            return;
         end if;
         if Mat (J, I) = 0 / 1 then
            for K in I .. N loop
               if  Mat (J, K) /= 0 / 1 then
                  for X in 1 .. N + 1 loop
                     declare
                        Temp : Rationale_Zahl;
                     begin
                        Set (Temp, Mat (X, I));
                        Set (Mat (X, I), Mat (X, K));
                        Set (Mat (X, K), Temp);
                     end;
                  end loop;
               end if;
            end loop;
         end if;
         if Mat (J, I) = 0 / 1 then
            Eliminiere_Rekursiv (Mat, I, J + 1);
            return;
         end if;
         declare
            Faktor : Rationale_Zahl;
         begin
            for Y in I + 1 .. N loop
               Set (Faktor, (Mat (J, Y) / Mat (J, I)));
               for X in 1 .. N + 1 loop
                  Set (Mat (X, Y), Mat (X, Y) - (Faktor * Mat (X, I)));
               end loop;
            end loop;
         end;
         Eliminiere_Rekursiv (Mat, I + 1, J + 1);
      end Eliminiere_Rekursiv;
      
      
      --  @Function: Setze_Rueckwaerts_Ein 
      --
      --  Berechnet die Lsg. eines LGS aus aus einer Matrix in 
      --  Zeilen-Stufen-Form
      --
      --  @Parameter: 
      --   + Mat: die Matrix in Zeilen-Stufen-Form
      --  
      --  @Return: 
      --  
      function Setze_Rueckwaerts_Ein (Mat : Matrix) return Vektor is
         Erg : Vektor;
         Summe_Xi : Rationale_Zahl;
      begin
         Erg := new Vektor_Array;
         for Schritt in reverse 1 .. N loop
            Set (Summe_Xi, 0, 1);
            for I in Schritt + 1 .. N loop
               Set (Summe_Xi, Summe_Xi + Erg (I) * Mat (I, Schritt));
            end loop;
            Set (Erg (Schritt), 
                (Mat (N + 1, Schritt) - Summe_Xi) / Mat (Schritt, Schritt));
         end loop;
         return Erg;
      end Setze_Rueckwaerts_Ein;
         
               
      
      Mat : Matrix := Null_Matrix;
      
   begin
      Get (Mat);
      Put_Line ("Sie gaben folgende Matrix ein: ");
      Put (Mat);
  
      begin
         Eliminiere_Rekursiv (Mat);
      exception
         when Constraint_Error =>
            Put_Line ("Div. durch 0 beim Eliminieren. " &
                      "Es gibt keine eindeutige Loesung.");
            Put (Mat);
            return;
      end;
      Put_Line ("Die Zeilen-Stufen-Form lautet: ");
      Put (Mat);
      Put_Line
      ("Loesung:");
      begin
         Put (Setze_Rueckwaerts_Ein (Mat));
      exception
         when Constraint_Error =>
            Put_Line ("Div. durch 0 beim Einsetzen. " &
                      "Es existiert keine Loesung.");
            return;
      end;

   end;   
exception
   when Constraint_Error =>
      Put_Line ("Bitte geben Sie eine sinnvolle Anzahl Unbekannte ein.");
      Gauss;
   when Data_Error =>
      Put_Line ("Dieses Programm erwartet nur Zahlen. Bitte geben Sie beim "
               & "naechsten mal etwas sinnvolles ein. Gebe auf.");
      
end Gauss;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;