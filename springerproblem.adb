--  @File: springerproblem.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 1
--  @Version: 1
--  @Created: 27. 11. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Springerproblem
--  Berechnet, wie viele Zuege ein Springer braucht um von einem Feld ein bel. 
--  anderes zu erreichen.
--


with Ada.Text_IO;
use Ada.Text_IO;
procedure Springerproblem is
   subtype Index is Integer range 1 .. 8;
   type Schachbrett is array (Index, Index) of Natural;
   
   --  @Procedure: Markiere_Erreichbare_Felder 
   --
   --  Traegt in den fuer eine Springer von dem geg. Feld aus erreichbaren 
   --  Feldern die min. anzahl Schritte ein. Verwendet Rekursion um alle Felder 
   --  zu erreichen.
   --
   --  @Parameter: 
   --   + Brett: Schachbrett in das die Werte eingetragen werden.
   --   + x: x-Pos. des Feldes
   --   + y: y-Pos. des Feldes
   --  
   procedure Markiere_Erreichbare_Felder (Brett : in out Schachbrett; 
                                           x, y :        Index) is
      
      Anzahl_Schritte : Natural := Brett (x, y) + 1; 
      
      --  @Procedure: Bearbeite_Feld 
      --
      --  Treagt ggf. die neue Anzahl Schritte in Schachbrett ein und fuerht 
      --  die Rekursion durch, igonoriert Felder ausserhalb.
      --
      --  @Parameter: 
      --   + x: x-Pos. des Feldes
      --   + y: y-Pos. des Feldes
      --  
      procedure Bearbeite_Feld (x, y : Integer) is
      begin
         --  Felder nur bearbeiten wenn der neue Weg kuerzer als die 
         --  bisherigen ist.
         if Brett (x, y) > Anzahl_Schritte then
            Brett (x, y) := Anzahl_Schritte;
            Markiere_Erreichbare_Felder (Brett, x, y);
         end if;
      exception
         when Constraint_Error =>
            null; --  Felder ausserhalb des Bretts ignorieren
      end Bearbeite_Feld;
      
   begin
      --  Alle moegliche Zuege des Springers
      Bearbeite_Feld (x - 1, y - 2);
      Bearbeite_Feld (x + 1, y + 2);
      Bearbeite_Feld (x + 1, y - 2);
      Bearbeite_Feld (x - 1, y + 2);
      Bearbeite_Feld (x - 2, y - 1);
      Bearbeite_Feld (x + 2, y + 1);
      Bearbeite_Feld (x + 2, y - 1);
      Bearbeite_Feld (x - 2, y + 1);
   end Markiere_Erreichbare_Felder;
   
   --  @Function: Bestimme_Erreichbarkeit 
   --
   --  Bestimmt die Anzahl Schritte, die ein Springer braucht um vom geg. 
   --  Feld ein bel. Feld zu erreichen.
   --
   --  @Parameter: 
   --   + x: x-Pos. des Springers
   --   + y: y-Pos. des Springers
   --  
   --  @Return: 
   --  Ein Schachbrett, in dem in jedem Feld die Anzahl Schritte zu diesem 
   --  Feld eingetragen ist.
   --  
   function Bestimme_Erreichbarkeit (x, y : Index) return Schachbrett is
      brett : Schachbrett := (others => (others => Natural'Last));
   begin
      brett (x, y) := 0;
      begin
         Markiere_Erreichbare_Felder (brett, x, y);
      exception
         when Storage_Error =>
            null; --  Nach vielen Rek. aufhoeren
      end;
      return brett;
   end Bestimme_Erreichbarkeit;
   
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
            Put (Integer'Image (stellung (x, y)));
            Put (" ");
         end loop;
         Put ("|");
         New_Line;
      end loop;
      Put_Border;
      New_Line;
   end Put;
      
   
begin
   Put (Bestimme_Erreichbarkeit (1, 1));
end Springerproblem;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;