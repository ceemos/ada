--  @File: wunschzettel.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 10
--  @Version: 1
--  @Created: 28. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Wunschzettel
--


with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;

with GNAT.Case_Util; use GNAT.Case_Util;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
procedure Wunschzettel is
   --  Wird nacher zu unflexibel
--    type Stadt_Record;
--    type Kind_Record;
--    type Wunsch_Record;
   type Element_Record;
   
   type Element is access Element_Record;
   
   --  Ein Typ fuer alle Listenelemente, Staedte, Kinder wie Wuensche
   type  Element_Record is record
      Next : Element;
      Name : Unbounded_String;
      Sub : Element;
   end record;

   
   --  @Function: Read 
   --
   --  Liest eine Datei im Wunschliste-Format in eine Liste.
   --
   --  @Parameter: 
   --   + File: der Name der Datei
   --  
   --  @Return: Das 1. El. der Liste
   --  
   function Read (File : String) return Element is
      F : File_Type;
      Line : Unbounded_String;
      Typ : Character;
      
      Current_Stadt : Element;
      Current_Kind : Element;
      Current_Wunsch : Element;
      
      Anfang : Element;
   begin
      Open (F, In_File, File);
      while not End_Of_File (F) loop
         Line := Get_Line (F);
         Typ := Ada.Strings.Unbounded.Element (Line, 1);
         case Typ is
            when '-' =>
               if Current_Stadt = null then
                  --  Erste Zeile
                  Current_Stadt := new Element_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Anfang := Current_Stadt;
               else
                  Current_Stadt.Next := new Element_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Stadt := Current_Stadt.Next;
               end if;
               Current_Kind := null;
            when '+' =>     
               if Current_Kind = null then
                  --  Neue Stadt
                  Current_Kind := new Element_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Stadt.Sub := Current_Kind;
               else
                  Current_Kind.Next := new Element_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Kind := Current_Kind.Next;
               end if;
               Current_Wunsch := null;  
            when '*' =>
               if Current_Wunsch = null then
                  --  1. Wunsch
                  Current_Wunsch := new Element_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Kind.Sub := Current_Wunsch;
               else
                  Current_Wunsch.Next := new Element_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Wunsch := Current_Wunsch.Next;
               end if;
            when others =>
               Put ("Zeile Ignoriert: ");
               Put_Line (Line);
         end case;
      end loop;
      return Anfang;
   end Read;
   
   --  @Function: Matches_By_Words 
   --
   --  Vergleicht zwei Strings intelligent: ein Filter passt auf einen Text.
   --  wenn die Anfangsbuchstaben der Woerter uebereinstimmen.
   --  z. B. passt "w d st" auf "weil der stadt" oder "t p" auf "timo polowski"
   --
   --  @Parameter: 
   --   + Text: der Text mit den kompletten Woertern
   --   + Filter: der Filter-String mit den Anfangsbuchstaben
   --  
   --  @Return: True, wenn der FIlter passt, sonst False.
   --  
   function Matches_By_Words (Text, Filter : String) return Boolean is
      Text_Index : Natural := 1;
   begin
      for Filter_Index in Filter'Range loop
         if Text_Index > Text'Last then
            return False;
         elsif Filter (Filter_Index) = Text (Text_Index) then
            Text_Index := Text_Index + 1;
         elsif Filter (Filter_Index) = ' ' then
            while Text_Index <= Text'Last 
                  and then Text (Text_Index) /= ' ' loop
               Text_Index := Text_Index + 1;
            end loop;
            Text_Index := Text_Index + 1;
         else
            return False;
         end if;
      end loop;
      return True;
   end Matches_By_Words;
   
   --  @Function: Matches 
   --
   --  Prueft, ob ein Filter-String auf ein Elemnet passt. Der Vergleich ist 
   --  case-insensitive.
   --
   --  @Parameter: 
   --   + Text: Der ganze Text
   --   + Filter: der Suchtext
   --  
   --  @Return: True, wenn der Filter passt.
   --  
   function Matches (Text, Filter : Unbounded_String) return Boolean is
      F : String := To_String (Filter);
      T : String := To_String (Text);
   begin
      To_Upper (F);
      To_Upper (T);
      return Matches_By_Words (T, F);
   end Matches;
   
   --  @Function: Print_List
   --
   --  Gibt eine Liste formatiert und gefiltert aus.
   --
   --  @Parameter: 
   --   + Elemente: das Erste El. das ausgegeben werden soll. Kann Stadt, Kind 
   --     oder Wunsch sein.
   --   + Praefix: Text, der an Anfang jeder Zeile ausgegeben werden soll.
   --   + Filter: der Suchtext
   --
   procedure Print_List (Elemente : Element; 
                   Praefix : String := ""; 
                   Filter : Unbounded_String := To_Unbounded_String ("")) is
      Current : Element := Elemente;
   begin
      while Current /= null loop
         if Matches (Current.Name, Filter) then
            Put (Praefix);
            Put_Line (Current.Name);
         end if;
         Current := Current.Next;
      end loop;
   end Print_List;
   
   --  @Function: Choose 
   --
   --  Laesst den Nutzer ein El. aus einer Liste auswaehlen.
   --
   --  @Parameter: 
   --   + Liste: das 1. El. der Liste
   --   + Praefix: Text, der vor jeder Zeile ausgegeben werden soll.
   --  
   --  @Return: Das gew. El. der Liste, null bei Abbruch.
   --  
   function Choose (Liste : Element; Praefix : String := "") return Element is
      Eingabe : Character;
      Filter : Unbounded_String;
   begin
      loop
         New_Line;
         Print_List (Liste, Praefix, Filter);
         Put ("Suche [Esc=Abbruch]: ");
         Put (Filter);
         Get_Immediate (Eingabe);
         
         --  Put ((Character'Pos (Eingabe)));
         
         --  Backspace
         if Character'Pos (Eingabe) = 127 then
            if Length (Filter) > 0 then
               Head (Filter, Length (Filter) - 1);
            end if;
         --  LineFeed
         elsif Character'Pos (Eingabe) = 10 then
            exit;
         --  Escape
         elsif Character'Pos (Eingabe) = 27 then
            return null;
         else 
            Append (Filter, Eingabe);
         end if;
      end loop;
      
      New_Line;
      
      declare
         Current : Element := Liste;
      begin
         while Current /= null loop
            if Matches (Current.Name, Filter) then
               return Current;
            end if;
            Current := Current.Next;
         end loop;
         --  Nichts gefunden
         return null;
      end;
   end Choose;
   
   --  @Procedure: Wait
   --
   --  Wartet, bis der Benutzer eine Taste drueckt.
   --
   procedure Wait is
      Eingabe : Character;
   begin
      Get_Immediate (Eingabe);
   end Wait;
begin
   declare 
      Liste : Element;
      Current_Stadt : Element;
      Current_Kind : Element;

   begin
      Put_Line ("Hinweise: Eintraege aus einer Liste koennen mit einer kurzen "
              & "Schreibweise gesucht werden, z. B. findet ""w d st"" " 
              & """Weil der Stadt""." );
      Put_Line ("<Enter> waehlt immer den 1. passenden Eintrag.");
                 
      Liste := Read ("wunschliste.txt");

      --  immer wieder
      loop
         --  Stadt waehlen lassen
         Current_Stadt := Choose (Liste, "- ");
         exit when Current_Stadt = null;
         
         
         Put ("Kinder aus ");
         Put (Current_Stadt.Name);
         Put_Line (":");
         
         loop
            --  Kind waehlen lassen
            Current_Kind := Choose (Current_Stadt.Sub, "  + ");
            exit when Current_Kind = null;
            
            New_Line;
            --  Wuensche ausgeben
            Put ("Wuensche von ");
            Put (Current_Kind.Name);
            Put_Line (":");
            
            Print_List (Current_Kind.Sub, " * ");
            
            Put_Line ("Bel. Taste...");
            Wait;
         end loop;

      end loop;
   end;
end Wunschzettel;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;