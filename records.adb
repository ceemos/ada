--  FILE: records.adb
--
--  PROJECT: Programmieruebungen , Uebungsblatt 4
--  VERSION: 1
--  DATE: 13. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  <PROCEDURE> records
--  Verschiedene Beispiele fuer (Variante-)Records.
--


with Ada.Text_IO;
use Ada.Text_IO;
procedure Records is
   type Artikel_Daten is record
      Artikel_Name   : String (1 .. 10);
      Artikel_Nummer : Positive;
      Preis          : Float;
   end record;
   
   type Datum is record
      Tag       : Integer range 1 .. 31;
      Monat     : Integer range 1 .. 12;
      Jahr      : Integer;
   end record;
   
   type Person is (Student, Mitarbeiter);
   
   type Studenten_oder_Mitarbeiter_Daten (typ : Person := Student) is record
      Name : String (1 .. 10);
      Nachname : String (1 .. 10);
      case typ is
         when Student => Matrikelnummer : Positive; 
         when Mitarbeiter => Abteilung : String (1 .. 2);
      end case;
   end record;
   
   type Komplexe_Zahl_Form is (Algebraisch, Polar);
   
   type Komplexe_Zahl (art : Komplexe_Zahl_Form := Algebraisch) is record
      case art is
         when Algebraisch => 
            re : Float;
            im : Float;
         when Polar => 
            r   : Float;
            phi : Float;
      end case;
   end record;
            
   
   artikel : Artikel_Daten;
   tag : Datum;
   christoph : Studenten_oder_Mitarbeiter_Daten;
   zahl : Komplexe_Zahl;
begin
   artikel := ("Ada-Buch  ", 12345, 99.99);
   tag := (9, 9, 1893);
   christoph := (Mitarbeiter, "Christoph ", "Stach     ", "AS");
   zahl := (Polar, 4.0, 7.91);
   
end Records;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;