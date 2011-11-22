--  FILE: acht_damen.adb
--
--  PROJECT: Programmieruebungen, Uebungsblatt 5
--  VERSION: 1
--  DATE: 20. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  <PROCEDURE> Acht_Damen
--  Findet alle Moeglichkeiten, acht Damen KOllisionsfrei auf einem Schachbrett
--  unterzubringen.
--

with Ada.Text_IO;
use Ada.Text_IO;
procedure Acht_Damen is
   type Feld is (Frei, Dame, Bedroht);
   subtype Index is Integer range 1 .. 9;
   type Schachbrett is array (Index, Index) of Feld;
   
   procedure Put (stellung : Schachbrett) is 
   begin
      for y in Index loop
         Put_Line ("+---+---+---+---+---+---+---+---+");
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
      Put_Line ("+---+---+---+---+---+---+---+---+");
   end Put;
   
   counter : Integer := 0;
   procedure count is
   begin
      counter := counter + 1;
   end count;
   
   function Fakultaet (zahl : Integer) return Integer is
   begin
      if zahl = 1 then
         return 1;
      else
         return Fakultaet (zahl - 1) * zahl;
      end if;
   end Fakultaet;
   
   function ist_Unschlagbar (stellung : Schachbrett; x, y : Index) 
      return Boolean is
      
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
   
   procedure setze_Dame (x, y : Index; stellung : in out Schachbrett) is
   
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
--       Put_Line ("Setzte Dame auf " & Integer'Image (x) & "," 
--             & Integer'Image (y));
--       Put (stellung);
   end setze_Dame;
   
   function teste_rekursiv (stellung : Schachbrett; level : Integer) 
         return Boolean is
      brett : Schachbrett := stellung;
      level_neu : Integer;
      ziel_erreichbar : Boolean := False;
   begin
      for x in Index loop
         for y in Index loop
            if brett (x, y) = Frei then
               setze_Dame (x, y, brett);
               level_neu := level + 1;
               if level_neu = Index'Last then
                  --  Put (brett);
                  count;
                  ziel_erreichbar := True;
               else 
                  ziel_erreichbar := ziel_erreichbar 
                                  or teste_rekursiv (brett, level_neu);
               end if;
            end if;
            brett := stellung;
         end loop;
      end loop;
      return ziel_erreichbar;
   end teste_rekursiv;
   
   brett : Schachbrett := (others => (others => Frei));
   moeglich : Boolean;
begin
   --  setze_Dame (3, 5, brett);
   --  Put (brett);
   
--    if ist_Unschlagbar (brett, 1, 1) then
--       Put_Line ("1, 1 ist nicht schlagbar");
--    end if;

   moeglich := teste_rekursiv (brett, 0);
   if moeglich then
      Put_Line ("es ist mgl. 8 Damen zu setzen");
      Put_Line ("Anzahl Komb.: " 
               & Integer'Image (counter / Fakultaet (Index'Last)));
   end if;
end Acht_Damen;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;