--  FILE: acht_damen.adb
--
--  PROJECT: Programmieruebungen, Uebungsblatt 5
--  VERSION: 2
--  DATE: 20. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  PROCEDURE Acht_Damen
--  Findet alle Moeglichkeiten, n Damen Kollisionsfrei auf einem Schachbrett
--  unterzubringen.
--

with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
procedure Acht_Damen is
   n : Positive;
begin
   Put_Line ("Geben Sie die Groesse an:");
   Get (n);
   
   declare
      --  Typ, der angibt, was sich auf einem Feld des Schachbretts befindet.
      type Feld is (Frei, Dame, Bedroht);
      
      --  Hilfstyp fuer die Groesse des Schachbretts
      subtype Index is Integer range 1 .. n;
      
      --  Typ der ein Schachbrett mitsamt Figuren darstellt.
      type Schachbrett is array (Index, Index) of Feld;
      
      --  PROCEDURE Put 
      --
      --  Gibt ein Schachbrett schoen grafisch aus.
      --
      --  PARAMETERS: 
      --   + stellung: Das Auszugebende Schachbrett
      --  
      procedure Put (stellung : Schachbrett) is 
      
         --  PROCEDURE Put_Border
         --
         --  Gibt einen Schachbrettmaessigen Rand / Trennstrich aus
         --
         procedure Put_Border is
         begin
            for i in Index loop
               Put ("+---");
            end loop;
            Put_Line ("+");
         end Put_Border;
         
      begin
         for y in Index loop
            Put_Border;
            for x in Index loop
               Put ("|");
               case stellung (x, y) is
                  when Frei =>
                     Put ("   ");
                  when Dame =>
                     Put (" D ");
                  when Bedroht =>
                     Put (" x ");
               end case;
            end loop;
            Put ("|");
            New_Line;
         end loop;
         Put_Border;
         New_Line;
      end Put;
      
      
      counter : Integer := 0;
      --  PROCEDURE count
      --
      --  Hilfsprozedur, die die Anzahl Aufrufe zaehlt. Wird verwendet, um die 
      --  Anzahl mgl. Kombinationen zu zaehlen.
      --
      procedure count is
      begin
         counter := counter + 1;
      end count;
      
      --  FUNCTION ist_Unschlagbar 
      --
      --  Prueft, ob eine Figur an Stelle x, y im geg, Schachbrett geschlagen 
      --  werden koennte.
      --  Wird vom Programm nicht verwendet, nur fuer die Aufgabenstellung.
      --
      --  PARAMETERS: 
      --   + stellung: das zu untersuchende Brett.
      --   + x: Pos. in x-Richtung
      --   + y: Pos. in y-Richtung
      --  
      --  RETURNS: true, wenn die Figur nicht geschlagen werden koennte, 
      --  sonst false.
      --  
      function ist_Unschlagbar (stellung : Schachbrett; x, y : Index) 
         return Boolean is
         
         --  FUNCTION ist_Dame 
         --
         --  prueft, ob sich an der geg. Stelle eine Dame befindet.
         --  Die Stelle darf auch ausserhalb des Bretts liegen.
         --  
         --  PARAMETERS: 
         --   + x: Pos. in x-Richtung
         --   + y: Pos. in y-Richtung
         --   + stellung: Das zu untersuchende Brett.
         --  
         --  RETURNS: false, wenn sich keine Dame an der Stelle befindet 
         --  oder die Stelle ausserhalb des Feldes liegt, sonst true.
         --  
         function ist_Dame (x, y : Integer; stellung : Schachbrett) 
               return Boolean is 
         begin
            return (x >= Index'First and x <= Index'Last and
                  y >= Index'First and y <= Index'Last)
                  and then stellung (x, y) = Dame;
         end ist_Dame;
         
      begin
         if stellung (x, y) = Frei then
            for i in Index loop
               if ist_Dame (x + i, y + i, stellung) or
                  ist_Dame (x - i, y - i, stellung) or
                  ist_Dame (x - i, y + i, stellung) or
                  ist_Dame (x + i, y - i, stellung) or
                  ist_Dame (x, y + i, stellung) or
                  ist_Dame (x, y - i, stellung) or
                  ist_Dame (x + i, y, stellung) or
                  ist_Dame (x - i, y, stellung) then
                  return False;
               end if;
            end loop;
         else
            return False;
         end if;
         return True;
      end ist_Unschlagbar;
      
      --  PROCEDURE setze_Dame 
      --
      --  Setzt eine Dame an die geg. Stelle und markiert alle von der Dame 
      --  schlagbaren Felder als bedroht.
      --
      --   + x: Pos. in x-Richtung
      --   + y: Pos. in y-Richtung
      --   + stellung: Das zu veraendernde Brett.
      --  
      procedure setze_Dame (x, y : Index; stellung : in out Schachbrett) is
      
         --  PROCEDURE markiere_Bedroht 
         --
         --  markiert ein geg. Feld als bedroht.
         --  Die Stelle darf auch ausserhalb des Bretts liegen; dann wird  
         --  nichts getan.
         --
         --  PARAMETERS: 
         --   + x: Pos. in x-Richtung
         --   + y: Pos. in y-Richtung
         --   + stellung: Das zu veraendernde Brett.
         --  
         procedure markiere_Bedroht (x, y : Integer; 
                                 stellung : in out Schachbrett) is 
         begin
            if (x >= Index'First and x <= Index'Last and
                  y >= Index'First and y <= Index'Last)
                  and then stellung (x, y) = Frei then
               stellung (x, y) := Bedroht;
            end if;
         end markiere_Bedroht;
         
      begin
         stellung (x, y) := Dame;
         for i in Index loop
            markiere_Bedroht (x + i, y + i, stellung);
            markiere_Bedroht (x - i, y - i, stellung);
            markiere_Bedroht (x - i, y + i, stellung);
            markiere_Bedroht (x + i, y - i, stellung);
            markiere_Bedroht (x, y + i, stellung);
            markiere_Bedroht (x, y - i, stellung);
            markiere_Bedroht (x + i, y, stellung);
            markiere_Bedroht (x - i, y, stellung);
         end loop;
      end setze_Dame;
      
      --  FUNCTION konstruiere_Stellungen 
      --
      --  Konstruiert Stellungen, bei denen sich n Damen auf einem nxn Felder 
      --  grossen Schachbrett nicht schlagen koennen.
      --
      --  PARAMETERS: 
      --   + stellung: Zu untersuchendes Schachbrett
      --   + level: Anzahl Damen, die sich schon auf dem Brett befinden.
      --  
      --  RETURNS: true, wenn mindestens eine mgl. Stellung gefunden wurde.
      --  
      function konstruiere_Stellungen (stellung : Schachbrett; 
                                          level : Integer) return Boolean is
         brett : Schachbrett := stellung;
         level_neu : Integer;
         ziel_erreichbar : Boolean := False;
         y : Integer := level + 1; --  die level+1. Dame muss gesetzt werden.
      begin
         for x in Index loop
            --  Voraussetzung: n-te dame in n-ter Zeile. Klappt nur mit Damen/
            --  Tuermen (hier gegeben) aber reduziert den aufwand um n!
            --  weil keine Lsg. mehrfach gefunden werden.
            --  for y in Index loop
            if brett (x, y) = Frei then
               setze_Dame (x, y, brett);
               level_neu := level + 1;
               if level_neu = Index'Last then
                  --  Put (brett);
                  count;
                  ziel_erreichbar := True;
               else 
                  ziel_erreichbar := ziel_erreichbar 
                     or konstruiere_Stellungen (brett, level_neu);
               end if;
            end if;
            brett := stellung;
            --  end loop;
         end loop;
         return ziel_erreichbar;
      end konstruiere_Stellungen;
      
      brett : Schachbrett := (others => (others => Frei));
      moeglich : Boolean;
   begin

      --  level = 0 da noch keine Damen auf dem Brett sind.
      moeglich := konstruiere_Stellungen (brett, 0);
      if moeglich then
         Put_Line ("es ist mgl." & Integer'Image (Index'Last) 
                  & " Damen zu setzen");
         Put_Line ("Anzahl Komb.: " & Integer'Image (counter));
      else 
         Put_Line ("es ist nicht mgl." & Integer'Image (Index'Last) 
                  & " Damen zu setzen");
      end if;
   end;
end Acht_Damen;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;