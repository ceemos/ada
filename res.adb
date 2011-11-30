--  @File: res.adb
--
--  @Project: Theo
--  @Version: 1
--  @Created: 30. 11. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Res
--


with Ada.Text_IO;
with Ada.Characters.Handling;
use Ada.Text_IO;
procedure Res is
   subtype Index is Integer range 1 .. 8;
   
   package Logik is
      type Klausel is tagged record
         data : String (Index);
         pos : Index;
      end record;
   
      procedure add (this : in out Klausel; what : Character);
      
      function Leer return Klausel;
      
      function contains (this : Klausel; what : Character) return Boolean;
      
      function neg (what : Character) return Character;
      
      function CanRes (left : Klausel; right : Klausel) 
         return Character;
         
      function DoRes (left : Klausel; right : Klausel; wrt : Character) 
         return Klausel;

   end Logik;
   
   package body Logik is
      procedure add (this : in out Klausel; what : Character) is
      begin
         if this.contains (what) then return; end if;
         this.data (this.pos) := what;
         this.pos := this.pos + 1;
      end add;
      
      function Leer return Klausel is
         k : Klausel;
      begin
         k.data := "        ";
         k.pos := Index'First;
         return k;
      end Leer;
      
      function contains (this : Klausel; what : Character) return Boolean is
      begin 
         for i in Index'First .. this.pos loop
            if this.data (i) = what then
               return True;
            end if;
         end loop;
         return False;
      end contains;
      
      function neg (what : Character) return Character is
      begin
         if Ada.Characters.Handling.Is_Upper (what) then
            return Ada.Characters.Handling.To_Lower (what);
         else 
            return Ada.Characters.Handling.To_Upper (what);
         end if;
      end neg;
      
      function CanRes (left : Klausel; right : Klausel) 
         return Character is
         wrt : Character := ' ';
      begin
         for i in Index'First .. left.pos loop
            if right.contains (neg (left.data (i))) then
               if wrt = ' ' then
                  wrt := left.data (i);
               else
                  return ' '; -- Res sinnlos, mehrere Mgl.
               end if;
            end if;
         end loop;
         return wrt;
      end CanRes;
      
      function DoRes (left : Klausel; right : Klausel; wrt : Character) 
         return Klausel is
         r : Klausel;
      begin
         r := Leer;
         for i in Index'First .. left.pos loop
            if left.data (i) /= wrt and left.data (i) /= neg (wrt) then
               r.add (left.data (i));
            end if;
         end loop;
         for i in Index'First .. right.pos loop
            if right.data (i) /= wrt and right.data (i) /= neg (wrt) then
               r.add (right.data (i));
            end if;
         end loop;
         return r;
      end DoRes;
         
      
   end Logik;
   
   use Logik;
   
   k : Klausel;
begin
   k := Leer;
   k.add ('a');
   k.add ('B');
   k.add ('B');
   k.add ('c');
   k.add (neg ('d'));
   Put_Line (k.data);
   Put (DoRes (("aBcD    ", 4), ("aBdeF   ", 5), 'd').data);
end Res;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;