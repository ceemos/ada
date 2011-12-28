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
   
   type  Element_Record is record
      Next : Element;
      Name : Unbounded_String;
      Sub : Element;
   end record;

   
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
   
   function Matches (Text, Filter : Unbounded_String) return Boolean is
      F : String := To_String (Filter);
      T : String := To_String (Head (Text, Length (Filter)));
   begin
      To_Upper (F);
      To_Upper (T);
      return F = T;
   end Matches;
   
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
      Liste := Read ("wunschliste.txt");

      loop
         Current_Stadt := Choose (Liste, "- ");
         exit when Current_Stadt = null;
         
         
         Put ("Kinder aus ");
         Put (Current_Stadt.Name);
         Put_Line (":");
         
         loop
            Current_Kind := Choose (Current_Stadt.Sub, "  + ");
            exit when Current_Kind = null;
            
            New_Line;
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