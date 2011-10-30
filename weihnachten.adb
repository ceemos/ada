-----------------------------------------------------------------------
-- weihnachten.adb
-- PSE 
-- Version:	1
-- Datum:	30. 10. 2011
-- Autoren: 	Marcel Schneider
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure weihnachten is
   
   -- prueft, ob das uebergebene Datum Heilig Abend ist
   function ist_weihnachten(t, m: Natural) return boolean is
   begin
      return t = 24 and m = 12;
   end ist_weihnachten;
   
   -- prueft, ob das uebergebene Jahr ein Schaltjahr ist.
   function ist_schaltjahr(j: Natural) return boolean is
   begin
      return ((j mod 4) = 0 and (j mod 100) /= 0) 
           or (j mod 400) = 0;
   end ist_schaltjahr;
   
   procedure addiere_einen_Tag(t, m, j: in out Natural) is
   begin
      
      -- Sonderfall Februar
      if m = 2 then
         if    (t = 28 and not ist_schaltjahr(j))
            or (t = 29 and     ist_schaltjahr(j)) then
            t := 0;
            m := 3;
         end if;
      end if;     
      -- Monatswechsel bei 30 Tegen
      if t = 30 and (m = 4 or m = 6 or m = 9 or m = 11) then
         t := 0;
         m:= m + 1;
      end if;
      -- Monatswechsel bei 31 Tagen
      if t = 31 and (m = 1 or m = 3 or m = 5 
                  or m = 7 or m = 8 or m = 10 or m = 12) then
         t := 0;
         m:= m + 1;
      end if;
      -- Jahreswechsel
      if m = 13 then
         j := j + 1;
         m := 1;
      end if;

      t := t + 1;
   end addiere_einen_Tag;
   
   -- prueft, ob die uebergebenen Daten plausibel sind
   function ist_gueltiges_datum(t, m, j: Natural) return boolean is
   begin
      return m >= 1 and m <= 12 -- Monatsbereich
         and t >= 1 and -- Tagesbereich
         (   ((m = 4 or m = 6 or m = 9  or m = 11) and t <= 30) -- 31-taeg. Mon.
          or ((m = 1 or m = 3 or m = 5  or m = 7                -- 30-taeg. Mon.
                     or m = 8 or m = 10 or m = 12) and t <= 31)
          or ( m = 2 and     ist_schaltjahr(j) and t <= 29 ) -- Sonderfall Feb.
          or ( m = 2 and not ist_schaltjahr(j) and t <= 28 )
         );
   end ist_gueltiges_datum;
         
   
   tag, monat, jahr: Natural;
   anzahl_Tage: Natural;
begin
   
   Put_Line("Geben Sie das Jahr ein:");
   Get(jahr);
   Put_Line("Geben Sie den Monat ein:");
   Get(monat);
   Put_Line("Geben Sie den Tag ein:");
   Get(tag);
   
   if ist_gueltiges_datum(tag, monat, jahr) then
   
      anzahl_Tage := 0;
      while not ist_weihnachten(tag, monat) loop
         addiere_einen_Tag(tag, monat, jahr);
         anzahl_Tage := anzahl_Tage + 1;
      end loop;
      
      Put("Es verbleiben noch ");
      Put(anzahl_Tage);
      Put(" Tage bis Weihnachten."); 
   else 
      Put_Line("Wahrscheinlich wird Weihnachten nie erreicht.");
   end if;
   
   
end weihnachten;

-- kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; line-numbers on; space-indent on; mixed-indent off