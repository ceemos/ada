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
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
procedure Game_of_Life is
   
   type Platz is (Frei, Belegt);
   
   subtype Index is Integer range 1 .. 8;
   
   type Pool is array (Index, Index) of Platz;
   
   procedure Put (Feld : Pool) is
   begin
      for y in Index loop
         for x in Index loop
            case Feld (x, y) is
               when Frei   => Put ("O ");
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
   
   Feld : Pool;
begin
   Initiate (Feld);
   Put (Feld);
end Game_of_Life;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;