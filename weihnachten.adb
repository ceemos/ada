-----------------------------------------------------------------------
--  weihnachten.adb
--  PSE Aufgabenblatt 2
--  Version:    2
--  Datum:      30. 10. 2011
--  Autoren:    Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure weihnachten is
   
   --  prueft, ob das uebergebene Datum Heilig Abend ist
   function ist_weihnachten (t, m : Natural) return Boolean is
   begin
      return t = 24 and m = 12;
   end ist_weihnachten;
   
   --  prueft, ob das uebergebene Jahr ein Schaltjahr ist.
   function ist_schaltjahr (j : Natural) return Boolean is
   begin
      return ((j mod 4) = 0 and (j mod 100) /= 0) 
           or (j mod 400) = 0;
   end ist_schaltjahr;
   
   --  prueft, ob die uebergebenen Daten plausibel sind
   function ist_gueltiges_datum (t, m, j : Natural) return Boolean is
   begin
      return m >= 1 and m <= 12 --  Monatsbereich
         and t >= 1 and --  Tagesbereich
            --  31-taeg. Mon.
            (((m = 4 or m = 6 or m = 9  or m = 11) and t <= 30)
            --  30-taeg. Mon.
          or ((m = 1 or m = 3 or m = 5  or m = 7                
                     or m = 8 or m = 10 or m = 12) and t <= 31)
            --  Sonderfall Feb.
          or (m = 2 and     ist_schaltjahr (j) and t <= 29) 
          or (m = 2 and not ist_schaltjahr (j) and t <= 28));
   end ist_gueltiges_datum;
   
   --  erhoehe das Datum um einen Tag, beachte dabei alle Monats/Jahreswechsel
   procedure addiere_einen_Tag (t, m, j : in out Natural) is
   begin
      --  ist_gueltiges_datum (t, m, j) muss wahr sein
      t := t + 1; --  einen Tag weiter
      if not ist_gueltiges_datum (t, m, j) then --  Tagesbereich verlassen
         t := 1;       --  Monat weiterspringen
         m := m + 1;
         if not ist_gueltiges_datum (t, m, j) then --  Monatsbereich verlassen
            m := 1;    --  Jahr weiterspringen
            j := j + 1;
         end if;
      end if;
      --  ist_gueltiges_datum (t, m, j) sollte wieder wahr sein 
   end addiere_einen_Tag;
   
   tag, monat, jahr : Natural;
   anzahl_Tage : Natural;
begin
   
   Put_Line ("Geben Sie das Jahr ein:");
   Get (jahr);
   Put_Line ("Geben Sie den Monat ein:");
   Get (monat);
   Put_Line ("Geben Sie den Tag ein:");
   Get (tag);
   
   if ist_gueltiges_datum (tag, monat, jahr) then
   
      anzahl_Tage := 0;
      --  addiere Tage bis Weihnachten erreicht ist.
      while not ist_weihnachten (tag, monat) loop
         addiere_einen_Tag (tag, monat, jahr);
         anzahl_Tage := anzahl_Tage + 1;
      end loop;
      
      Put ("Es verbleiben noch ");
      Put (anzahl_Tage);
      Put (" Tage bis Weihnachten."); 
   else
      --  Datum nicht gueltig.
      Put_Line ("Wahrscheinlich wird Weihnachten nie erreicht.");
   end if;

end weihnachten;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;