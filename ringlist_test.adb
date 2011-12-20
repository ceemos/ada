--  @File: ringlist_test.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 9
--  @Version: 1
--  @Created: 17. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Ringlist_Test
--


with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded;
with Ringlist;
procedure Ringlist_Test is
   function Ist_Kleiner (Links, Rechts : Unbounded_String) return Boolean is
   begin
      return Length (Links) < Length (Rechts);
   end Ist_Kleiner;
   
   function Ist_Gleich (Links, Rechts : Unbounded_String) return Boolean is
   begin
      return Links = Rechts;
   end Ist_Gleich;

   
   package String_Ringlist is new Ringlist 
        (Element_Type => Unbounded_String,
         "<" => Ist_Kleiner,
         "=" => Ist_Gleich,
         Put => Ada.Strings.Unbounded.Text_IO.Put_Line);
         
   use String_Ringlist;

   Stringlist : String_Ringlist.List;
   Stringlist2 : String_Ringlist.List;
begin
   New_List (Stringlist);
   New_List (Stringlist2);
   
   Put_Line ("Laenge: " & Size (Stringlist)'Img);
   Remove (Stringlist, To_Unbounded_String ("Hallo"));
   Insert (Stringlist, To_Unbounded_String ("es"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   Insert (Stringlist, To_Unbounded_String ("Hallo"));
   Remove (Stringlist, To_Unbounded_String ("Hallo"));
   Insert (Stringlist, To_Unbounded_String ("du"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   Insert (Stringlist, To_Unbounded_String ("un"));
   Insert (Stringlist, To_Unbounded_String ("schoene"));
   Insert (Stringlist, To_Unbounded_String ("Welt"));
   Insert (Stringlist, To_Unbounded_String ("Hallo"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   Remove (Stringlist, To_Unbounded_String ("un"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   Remove (Stringlist, To_Unbounded_String ("es"));
   
   Remove_All (Stringlist, To_Unbounded_String ("ich"));
   
   Put_Line ("Init List2");
   Insert (Stringlist2, To_Unbounded_String ("Hallo"));
   Insert (Stringlist2, To_Unbounded_String ("du"));
   Insert (Stringlist2, To_Unbounded_String ("schoene")); 
   Insert (Stringlist2, To_Unbounded_String ("Welt"));
   --  Insert (Stringlist2, To_Unbounded_String ("sehrlange"));
   --  Insert (Stringlist2, To_Unbounded_String ("kurze"));
   --  Insert (Stringlist2, To_Unbounded_String ("ich"));
   --  Insert (Stringlist2, To_Unbounded_String ("i"));
   --  Insert (Stringlist2, To_Unbounded_String ("es"));
   if Contains (Stringlist, To_Unbounded_String ("ich")) then
      Put_Line ("Schlecht");
   end if;
   if Contains (Stringlist, To_Unbounded_String ("du")) then
      Put_Line ("Gut");
   end if;   
      
   Put (Stringlist);
   New_Line;
   Put (Stringlist2);
   if Equals (Stringlist, Stringlist2) then
      Put_Line ("Listen sind gleich");
   end if;
   Insert (Stringlist, To_Unbounded_String ("1"));
   Insert (Stringlist2, To_Unbounded_String ("2"));
   if not Equals (Stringlist, Stringlist2) then
      Put_Line ("Listen sind ungleich");
   end if;
   Put_Line ("Laenge: " & Size (Stringlist)'Img);
end Ringlist_Test;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;