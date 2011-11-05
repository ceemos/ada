-----------------------------------------------------------------------
--  klammern.adb
--  PSE Blatt 3
--  Version:    1
--  Datum:      05. 11. 2011
--  Autoren:    Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
procedure klammern is
   procedure pruefe_klammern_impl (ausdruck : in Unbounded_String; 
                                      index : in out Natural;
                                   ergebnis : in out Boolean;
                              klammer_offen : in Boolean) is
   begin
      while index <= Length (ausdruck) loop
         index := index + 1; --  Index erhoehen, wird spaeter schwer
         case Element (ausdruck, index - 1) is
            when ')' => --  Diese Klammer ist unsere schliessende
               --  ok, wenn vorher eine Klammer aufging
               ergebnis := klammer_offen; 
               return; 
            when '(' => --  Rekursiv weiterpruefen
               --  index wird aufs Ende der inneren Klammer geschoben
               pruefe_klammern_impl (ausdruck, index, ergebnis, True);
               if not ergebnis then
                  return; --  Fehler in der inneren Klammer
               end if;
            when others => null; --  Es gibt nix zu tun
         end case;
      end loop;
      --  Ende erreicht, Fehler wenn eine Klammer offen ist
      ergebnis := not klammer_offen;
      return; 
   end pruefe_klammern_impl;
   
   function pruefe_klammern (ausdruck : Unbounded_String) return Boolean is
      index : Natural := 1;
      erg : Boolean := False;
   begin
      pruefe_klammern_impl (ausdruck, index, erg, False);
      return erg;
   end pruefe_klammern;
   
   testausdruck : Unbounded_String;
begin
   Put_Line ("Ausdruck:");
   testausdruck := Get_Line;
   if pruefe_klammern (testausdruck) then
      Put_Line ("alles ok");
   else 
      Put_Line ("Kaputte Klammern");
   end if;
end klammern;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;