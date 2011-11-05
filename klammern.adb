-----------------------------------------------------------------------
--  klammern.adb
--  PSE Blatt 3
--  Version:    1
--  Datum:      05. 11. 2011
--  Autoren:    Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Strings.Unbounded;
use Ada.Text_IO, Ada.Strings.Unbounded;
procedure klammern is
   procedure pruefe_klammern_impl (ausdruck : in Unbounded_String; 
                                      index : in out Natural;
                                   ergebnis : in out Boolean) is
   begin
      Put_Line ("in der impl");
      while index <= Length (ausdruck) loop
         case Element (ausdruck, index) is
            when ')' => --  Diese Klammer ist unsere schliessende
               index := index + 1;
               ergebnis := True;
               return; 
            when '(' =>
               index := index + 1; --  Zeichen Verarbeitet
               --  Rekursiv weiterpruefen
               pruefe_klammern_impl (ausdruck, index, ergebnis);
               if not ergebnis then
                  Put_Line ("impl fallthru");
                  return; --  Fehler in der inneren Klammer
               end if;
               --  index wurde aufs Ende der inneren Klammer geschoben
            when others =>
               index := index + 1; --  Zeichen Verarbeitet
         end case;
      end loop;
      Put_Line ("Impl aus -> false");
      ergebnis := False;
      return; --  Ende erreicht, Fehler! (keine schliessende Klammer)
   end pruefe_klammern_impl;
   
   function pruefe_klammern (ausdruck : Unbounded_String) return Boolean is
      index : Natural := 1;
      erg : Boolean := False;
   begin
      while index <= Length (ausdruck) loop
         case Element (ausdruck, index) is
            when ')' => --  Diese Klammer ging nirgends auf
               Put_Line ("schliessende im HP");
               return False; 
            when '(' =>
               index := index + 1; --  Zeichen Verarbeitet
               --  Rekursiv weiterpruefen
               pruefe_klammern_impl (ausdruck, index, erg);
               if not erg then
                  return False; --  Fehler in der inneren Klammer
               end if;
               --  index wurde aufs Ende der inneren Klammer geschoben
            when others =>
               index := index + 1; --  Zeichen Verarbeitet
         end case;
      end loop;
      return True; --  Ende erreicht, kein Fehler
      
   end pruefe_klammern;
   
   testausdruck : String := "ab(cd(e()f()g))";
begin
   if pruefe_klammern (To_Unbounded_String (testausdruck)) then
      Put_Line ("alles ok");
   else 
      Put_Line ("Kaputte Klammern");
   end if;
end klammern;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;