--  FILE: textsuche.adb
--
--  PROJECT: Programmieruebungen, Uebungsblatt 5
--  VERSION: 1
--  DATE: 20. 11. 2011
--  AUTHOR: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  PROCEDURE Textsuche
--  Liest zwei Texte ein und testet, ob der 2. im 1. vorkommt.
--


with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
procedure Textsuche is

   --  @Function: contains 
   --
   --  Prueft, ob der Text needle im Text haystack auftaucht.
   --
   --  @Parameter: 
   --   + haystack: Text, in dem gesucht werden soll
   --   + needle: Text, der gesucht werden soll
   --  
   --  @Return: True, wenn der Text auftaucht, sonst False. Der leere String ""
   --  taucht in jedem anderen String auf.
   --  
   function contains (haystack, needle : Unbounded_String) return Boolean is
      -- zaehlt die passenden Zeichen
      matchedlen : Integer := 0;
   begin
      --  Sonderfall Suchstring leer: Ergebnis per Def. True
      if Length (needle) = 0 then
         return True;
      end if;
      
      --  Erstes Zeichen der Suchstring suchen, mgl. Anfang der Strings
      --  nur soweit suchen das der Suchstring noch Platz finden kann.
      for i in 1 .. Length (haystack) - Length (needle) + 1 loop
         if Element (haystack, i) = Element (needle, 1) then
         
            --  Pruefen, ob auch die folgenden Zeichen passen.
            matchedlen := 0;
            for j in 1 .. Length (needle) loop
               if Element (haystack, i + j - 1) = Element (needle, j) then
                  matchedlen := matchedlen + 1;
               end if;
            end loop;
            --  Wenn alle Zeichen richtig waren - > Treffer
            if matchedlen = Length (needle) then 
               return True;
            end if;
         end if;
      end loop;
      
      --  Ende des Strings erreicht -> Text taucht nicht auf.
      return False;
   end contains;
   
   text, suchtext : Unbounded_String;
   
begin
   Put_Line ("Geben Sie einen Text ein:");
   text := Get_Line;
   
   Put_Line ("Geben Sie einen Suchtext ein:");
   suchtext := Get_Line;
   
   if contains (text, suchtext) then 
      Put_Line ("Suchtext ist enthalten");
   else 
      Put_Line ("Suchtext ist nicht enthalten");
   end if;
end Textsuche;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;