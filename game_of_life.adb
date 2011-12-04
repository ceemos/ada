--  @File: game_of_life.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 7
--  @Version: 1
--  @Created: 04. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Game_of_Life
--


with Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
procedure Game_of_Life is
   
   type Platz is (Frei, Belegt);
   
   type Index is mod 8;
   
   type Pool is array (Index, Index) of Platz;
   
   procedure Put (Feld : Pool) is
   begin
      for y in Index loop
         for x in Index loop
            case Feld (x, y) is
               when Frei   => Put (". ");
               when Belegt => Put ("X ");
            end case;
         end loop;
         New_Line;
      end loop;
   end Put;
   
   package R is new Ada.Numerics.Discrete_Random (Platz);
   
   procedure Initiate (Feld : in out Pool) is
      G : R.Generator;
   begin
      R.Reset (G);
      for y in Index loop
         for x in Index loop
            Feld (x, y) := R.Random (G);
         end loop;
      end loop;
   end Initiate;
   
   function "+" (left : Integer; right : Platz) return Integer is
   begin
      case right is
         when Frei => return left;
         when Belegt => return left + 1;
      end case;
   end "+";
   
   function Zaehle_Nachbarn (Feld : Pool; x, y : Index) return Natural is 
   begin
      --  Felder rechts
      return 0 + Feld (x + 1, y + 1)
               + Feld (x + 1, y - 1)
               + Feld (x + 1, y)
      --  Felder links
               + Feld (x - 1, y + 1)
               + Feld (x - 1, y - 1)
               + Feld (x - 1, y)
      --  Oben + Unten
               + Feld (x, y + 1)
               + Feld (x, y - 1);
   end Zaehle_Nachbarn;
      

   
   procedure Next (Feld : in out Pool) is
      Alter_Zustand : Pool := Feld;
      Nachbarn : Natural;
   begin
      for y in Index loop
         for x in Index loop
            Nachbarn := Zaehle_Nachbarn (Alter_Zustand, x, y);
            case Nachbarn is
               when 0 => Feld (x, y) := Frei;
               when 1 => null;  -- keine Aenderung
               when 2 => Feld (x, y) := Belegt;
               when others => Feld (x, y) := Frei;
            end case;
         end loop;
      end loop;
   end Next;
   
   
   Anzahl_Schritte : Natural;
   Feld : Pool;
begin
   Initiate (Feld);
   Put_Line ("Startbelegung:");
   Put (Feld);
   Put_Line ("Wie viele Folgebelegungen sollen berechnet werden?");
   Ada.Integer_Text_IO.Get (Anzahl_Schritte);
   
   for I in 1 .. Anzahl_Schritte loop
      Put_Line (Natural'Image (I) & ". Folgebelegung:");
      Next (Feld);
      Put (Feld);
      New_Line;
   end loop;
end Game_of_Life;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;