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
begin
   New_List (Stringlist);
   Put_Line ("Laenge: " & Size (Stringlist)'Img);
   Remove (Stringlist, To_Unbounded_String ("Hallo"));
   Insert (Stringlist, To_Unbounded_String ("Hallo"));
   Remove (Stringlist, To_Unbounded_String ("Hallo"));
   Insert (Stringlist, To_Unbounded_String ("du"));
   Insert (Stringlist, To_Unbounded_String ("un"));
   Insert (Stringlist, To_Unbounded_String ("schoene"));
   Insert (Stringlist, To_Unbounded_String ("Welt"));
   Insert (Stringlist, To_Unbounded_String ("Hallo"));
   Remove (Stringlist, To_Unbounded_String ("un"));
   Put (Stringlist);
   Put_Line ("Laenge: " & Size (Stringlist)'Img);
end Ringlist_Test;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;