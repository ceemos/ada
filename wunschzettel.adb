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
   type Stadt_Record;
   type Kind_Record;
   type Wunsch_Record;
   
   type Stadt is access Stadt_Record;
   type Kind is access Kind_Record;
   type Wunsch is access Wunsch_Record;
   
   type Stadt_Record is record
      Next : Stadt;
      Name : Unbounded_String;
      Kinder : Kind;
   end record;
   type Kind_Record is record
      Next : Kind;
      Name : Unbounded_String;
      Wuensche : Wunsch;
   end record;
   type Wunsch_Record is record
      Next : Wunsch;
      Name : Unbounded_String;
   end record;
   
   function Read (File : String) return Stadt is
      F : File_Type;
      Line : Unbounded_String;
      Typ : Character;
      
      Current_Stadt : Stadt;
      Current_Kind : Kind;
      Current_Wunsch : Wunsch;
      
      Anfang : Stadt;
   begin
      Open (F, In_File, File);
      while not End_Of_File (F) loop
         Line := Get_Line (F);
         Typ := Element (Line, 1);
         case Typ is
            when '-' =>
               if Current_Stadt = null then
                  --  Erste Zeile
                  Current_Stadt := new Stadt_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Anfang := Current_Stadt;
               else
                  Current_Stadt.Next := new Stadt_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Stadt := Current_Stadt.Next;
               end if;
               Current_Kind := null;
            when '+' =>     
               if Current_Kind = null then
                  --  Neue Stadt
                  Current_Kind := new Kind_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Stadt.Kinder := Current_Kind;
               else
                  Current_Kind.Next := new Kind_Record'(null, 
                           Delete (Line, 1, 1),
                           null);
                  Current_Kind := Current_Kind.Next;
               end if;
               Current_Wunsch := null;  
            when '*' =>
               if Current_Wunsch = null then
                  --  1. Wunsch
                  Current_Wunsch := new Wunsch_Record'(null, 
                           Delete (Line, 1, 1));
                  Current_Kind.Wuensche := Current_Wunsch;
               else
                  Current_Wunsch.Next := new Wunsch_Record'(null, 
                           Delete (Line, 1, 1));
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
   
   procedure Print_List (Staedte : Stadt; 
                   Praefix : String := ""; 
                   Filter : Unbounded_String := To_Unbounded_String ("")) is
      Current : Stadt := Staedte;
   begin
      while Current /= null loop
         if Matches (Current.Name, Filter) then
            Put (Praefix);
            Put_Line (Current.Name);
         end if;
         Current := Current.Next;
      end loop;
   end Print_List;
   
   procedure Print_List (Kinder : Kind; 
                   Praefix : String := ""; 
                   Filter : Unbounded_String := To_Unbounded_String ("")) is
      Current : Kind := Kinder;
   begin
      while Current /= null loop
         if Matches (Current.Name, Filter) then
            Put (Praefix);
            Put_Line (Current.Name);
         end if;
         Current := Current.Next;
      end loop;
   end Print_List;
   
   procedure Print_List (Wuensche : Wunsch; 
                   Praefix : String := ""; 
                   Filter : Unbounded_String := To_Unbounded_String ("")) is
      Current : Wunsch := Wuensche;
   begin
      while Current /= null loop
         if Matches (Current.Name, Filter) then
            Put (Praefix);
            Put_Line (Current.Name);
         end if;
         Current := Current.Next;
      end loop;
   end Print_List;
   
    
   
begin
   declare 
      Liste : Stadt;
      
      Eingabe : Character;
      Filter : Unbounded_String;
   begin
      Liste := Read ("wunschliste.txt");
      Print_List (Liste, " - ", To_Unbounded_String ("b"));
      
      loop
         Put ("Suche:");
         Put (Filter);
         Get_Immediate (Eingabe);
         Put ((Character'Pos (Eingabe)));
         if Character'Pos (Eingabe) = 127 then
            if Length (Filter) > 0 then
               Head (Filter, Length (Filter) - 1);
            end if;
         elsif Character'Pos (Eingabe) = 10 then
            exit;
         else 
            Append (Filter, Eingabe);
         end if;
         
         New_Line;
         Print_List (Liste, " - ", Filter);
      end loop;
   end;
end Wunschzettel;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;