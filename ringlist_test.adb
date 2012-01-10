--  @File: ringlist_test.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 9
--  @Version: 1
--  @Created: 17. 12. 2011
--  @Author: Marcel Schneider, Ulrich Zendler, Philipp Klaas
--
-------------------------------------------------------------------------------
--
--  @Procedure: Ringlist_Test
--  Testet die Funktionalitaet der Ringliste
--


with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded;
with Ringlist;
procedure Ringlist_Test is
   --  @Function: Ist_Kleiner 
   --
   --  Vergleicht zwei Unbounded Strings nach der Laenge.
   --
   --  @Parameter: 
   --   + Links: der eine String
   --   + Rechts: der andere String
   --  
   --  @Return: True, wenn der linke String kuerzer als der rechte ist.
   --  
   function Ist_Kleiner (Links, Rechts : Unbounded_String) return Boolean is
   begin
      return Length (Links) < Length (Rechts);
   end Ist_Kleiner;
   
   --  @Function: Ist_Gleich 
   --
   --  Vergleicht zwie Unbounded Strings
   --
   --  @Parameter: 
   --   + Links: der eine String
   --   + Rechts: der andere String
   --  
   --  @Return: True, wenn beide Strings genau gleich sind
   --  
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
   begin
      Insert (Stringlist, To_Unbounded_String ("Hallo"));
   exception
      when Empty_List_Error =>
         Put_Line ("Liste nicht Initialisiert");
   end;
   
   New_List (Stringlist);
   New_List (Stringlist2);
   
   --  Muss 0 sein
   Put_Line ("Laenge: " & Size (Stringlist)'Img);
   
   --  Darf keinen Fehler verursachen
   Remove (Stringlist, To_Unbounded_String ("Hallo"));
   
   Insert (Stringlist, To_Unbounded_String ("es"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   Insert (Stringlist, To_Unbounded_String ("Hallo"));
   
   --  Muss das letzte El. entfernen
   Remove (Stringlist, To_Unbounded_String ("Hallo"));
   
   --  Einfuegen an verschiedenen Stellen
   Insert (Stringlist, To_Unbounded_String ("du"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   Insert (Stringlist, To_Unbounded_String ("un"));
   Insert (Stringlist, To_Unbounded_String ("schoene"));
   Insert (Stringlist, To_Unbounded_String ("Welt"));
   Insert (Stringlist, To_Unbounded_String ("Hallo"));
   Insert (Stringlist, To_Unbounded_String ("ich"));
   
   --  1. El. Entfernen
   Remove (Stringlist, To_Unbounded_String ("un"));
   Remove (Stringlist, To_Unbounded_String ("es"));
   
   Insert (Stringlist, To_Unbounded_String ("ich"));
   
   --  Muss 4 El. entfernen
   Remove_All (Stringlist, To_Unbounded_String ("ich"));
   
   --  Testen, ob El. Entfernt wurden
   if Contains (Stringlist, To_Unbounded_String ("ich")) then
      Put_Line ("Schlecht");
   end if;
   if Contains (Stringlist, To_Unbounded_String ("du")) then
      Put_Line ("Gut");
   end if;  
   
   --  Put_Line ("Init List2");
   --  Diese Strings sollten auch in Stringlist sein
   Insert (Stringlist2, To_Unbounded_String ("Hallo"));
   Insert (Stringlist2, To_Unbounded_String ("du"));
   Insert (Stringlist2, To_Unbounded_String ("schoene")); 
   Insert (Stringlist2, To_Unbounded_String ("Welt"));
   
   --  Listen ausgeben
   --  Ausgaben muessen der Laenge nach geordnet sein.
   Put (Stringlist);
   New_Line;
   Put (Stringlist2);
   
   --  Vergleich Testen
   if Equals (Stringlist, Stringlist2) then
      Put_Line ("Listen sind gleich");
   end if;
   
   --  Listen ungleich machen
   Insert (Stringlist, To_Unbounded_String ("1"));
   Insert (Stringlist2, To_Unbounded_String ("2"));
   --  Testen
   if not Equals (Stringlist, Stringlist2) then
      Put_Line ("Listen sind ungleich");
   end if;
   
   --  Muss 5 sein
   Put_Line ("Laenge: " & Size (Stringlist)'Img);
   
   Clear (Stringlist);
   if Is_Empty (Stringlist) then
      --  Muss ausgegeben werden.
      Put_Line ("Liste wurde geleert.");
   end if;
end Ringlist_Test;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;