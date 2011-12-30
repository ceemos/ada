--  @File: geschenkeliste.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 10
--  @Version: 1
--  @Created: 30. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Geschenkeliste
--


with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
procedure Geschenkeliste is
   type Element_Record;
   
   type Element is access Element_Record;
   
   type  Element_Record is record
      Next : Element;
      Name : Unbounded_String;
      Sub : Element;
   end record;
   
   type Element_Counter_Record;
   
   type Element_Counter is access Element_Counter_Record;
   
   type Element_Counter_Record is record
      Next : Element_Counter;
      Name : Unbounded_String;
      Count : Natural;
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
   
   procedure Zaehle_Wunsch (Name : Unbounded_String; 
                         Counter : in out Element_Counter) is
      Current_Counter : Element_Counter := Counter;
   begin
      while Current_Counter.Next /= null loop
         if Current_Counter.Name = Name then
            Current_Counter.Count := Current_Counter.Count + 1;
            return;
         end if;
         Current_Counter := Current_Counter.Next;
      end loop;
      --  Falls das erreicht wird, fehlt der Eintrag
      Current_Counter.Next := new Element_Counter_Record'(null, Name, 1);
   end Zaehle_Wunsch;
   
   procedure Zaehle_Stadt (Kinder : Element; 
                          Counter : in out Element_Counter) is
      Current_Kind : Element := Kinder;
      Current_Wunsch : Element;
   begin
      while Current_Kind /= null loop
         Current_Wunsch := Current_Kind.Sub;
         while Current_Wunsch /= null loop
            Zaehle_Wunsch (Current_Wunsch.Name, Counter);
            Current_Wunsch := Current_Wunsch.Next;
         end loop;
         Current_Kind := Current_Kind.Next;
      end loop;
   end Zaehle_Stadt;
   
   procedure Put (Counter : Element_Counter) is
      Current_Counter : Element_Counter := Counter.Next;
   begin
      while Current_Counter.Next /= null loop
         Put ("   ");
         Put (Current_Counter.Name);
         Put_Line (":" & Current_Counter.Count'Img);
         Current_Counter := Current_Counter.Next;
      end loop;
   end Put;
   
begin
   declare 
      Counter : Element_Counter := 
            new Element_Counter_Record'(null, To_Unbounded_String (""), 0);
      Liste : Element;
      Current_Stadt : Element;
   begin
      Liste := Read ("wunschliste.txt");
      Current_Stadt := Liste;
      while Current_Stadt /= null loop
         declare
            Stadt_Counter : Element_Counter :=
               new Element_Counter_Record'(null, To_Unbounded_String (""), 0);
         begin
            New_Line;
            Put_Line ("Geschenke fuer " & Current_Stadt.Name & ":");
            --  Nur die Stadt
            Zaehle_Stadt (Current_Stadt.Sub, Stadt_Counter);
            Put (Stadt_Counter);
            --  fuers grosse Ganze
            Zaehle_Stadt (Current_Stadt.Sub, Counter);
         end;
         Current_Stadt := Current_Stadt.Next;
      end loop;
      New_Line;
      Put_Line ("Geschenke insgesamt:");
      Put (Counter);
   end;
end Geschenkeliste;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;