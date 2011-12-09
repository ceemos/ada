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
--  Implementiert das "Spiel des Unilebens"
--


with Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

with Ada.Containers.Vectors;

procedure Game_of_Life is
   
   --  Typ fuer die Zustaende, die ein Platz annehmen kann.
   type Platz is (Frei, Belegt);
   
   --  Typ fuer alle Indizes die in den Pool zeigen
   --  Ermoeglicht automatisch die Torus-Form
   type Index is mod 8;
   
   --  Der Pool selbst
   type Pool is arraY (Index, Index) of Platz;
   
   --  @Procedure: Put 
   --
   --  Gibt die Belegung des Pools graphisch als Text aus.
   --
   --  @Parameter: 
   --   + Feld: Die auzugebende Belegung
   --  
   procedure Put (Feld : Pool) is
   begin
      for Y in Index loop
         for X in Index loop
            case Feld (X, Y) is
               when Frei   => Put ("O ");
               when Belegt => Put ("X ");
            end case;
         end loop;
         New_Line;
      end loop;
   end Put;
   
   --  Zufallsgenerator fuer zufaellig belegte Plaetze.
   package R is new Ada.Numerics.Discrete_Random (Platz);
   
   --  @Procedure: Initiate 
   --
   --  Erzeugt eine zufaellige Belegung des Pools.
   --
   --  @Parameter: 
   --   + Feld: Pool, in dem die Belegung gespeichert werden soll.
   --  
   procedure Initiate (Feld : in out Pool) is
      G : R.Generator;
   begin
      R.Reset (G); 
      for Y in Index loop
         for X in Index loop
            Feld (X, Y) := R.Random (G);
         end loop;
      end loop;
   end Initiate;
   
   --  @Function: "+" 
   --
   --  Addiert 1 zu einem Integer, falls ein Platz belegt ist, und ermoeglicht 
   --  so das Zaehlen belegter Plaetze.
   --
   --  @Parameter: 
   --   + Left: Zahl, zu der der Platz dazugezaehlt werden soll.
   --   + Right: Paltz, der gezaehlt werden soll.
   --  
   --  @Return: die Zahl + 1, falls der Platz belegt war, sonst die Zahl.
   --  
   function "+" (Left : Integer; Right : Platz) return Integer is
   begin
      case Right is
         when Frei => return Left;
         when Belegt => return Left + 1;
      end case;
   end "+";
   
   --  @Function: Zaehle_Nachbarn 
   --
   --  Zahlt, wie viele Plaetze in der Umgebung eines Platzes belegt sind.
   --
   --  @Parameter: 
   --   + Feld: Der Pool um den es geht.
   --   + X: die X-Koordinate des Platzes
   --   + Y: die Y-Koordinate des Platzes
   --  
   --  @Return: die Anzahl belegte Plaetze in der Nachbarschaft.
   --  
   function Zaehle_Nachbarn (Feld : Pool; X, Y : Index) return Natural is 
   begin
      --  Felder rechts
      return 0 + Feld (X + 1, Y + 1)
               + Feld (X + 1, Y - 1)
               + Feld (X + 1, Y)
      --  Felder links
               + Feld (X - 1, Y + 1)
               + Feld (X - 1, Y - 1)
               + Feld (X - 1, Y)
      --  Oben + Unten
               + Feld (X, Y + 1)
               + Feld (X, Y - 1);
   end Zaehle_Nachbarn;
      

   
   --  @Procedure: Next 
   --
   --  Berechnet die Naechste Belegung eines Pools
   --
   --  @Parameter: 
   --   + Feld: Pool, auf den der Schritt angewandt werden soll.
   --  
   procedure Next (Feld : in out Pool) is
      Alter_Zustand : Pool := Feld;
      Nachbarn : Natural;
   begin
      for Y in Index loop
         for X in Index loop
            Nachbarn := Zaehle_Nachbarn (Alter_Zustand, X, Y);
            case Nachbarn is
               when 0 => Feld (X, Y) := Frei;
               when 1 => null;  -- keine Aenderung
               when 2 => Feld (X, Y) := Belegt;
               when others => Feld (X, Y) := Frei;
            end case;
         end loop;
      end loop;
   end Next;
   
   
begin
   declare 
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
      
   exception 
      when Constraint_Error | Data_Error =>
         Put_Line ("Bitte geben Sie eine positive Zahl ein!"); 
   end;
end Game_of_Life;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;