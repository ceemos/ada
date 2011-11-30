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
with Ada.Containers.Vectors;
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
      
      function len (this : Klausel) return Natural;
      
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
         for i in Index'First .. this.len loop
            if this.data (i) = what then
               return True;
            end if;
         end loop;
         return False;
      end contains;
      
      function len (this : Klausel) return Natural is
      begin
         return this.pos - Index'First;
      end len;
      
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
         for i in Index'First .. left.len loop
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
         for i in Index'First .. left.len loop
            if left.data (i) /= wrt and left.data (i) /= neg (wrt) then
               r.add (left.data (i));
            end if;
         end loop;
         for i in Index'First .. right.len loop
            if right.data (i) /= wrt and right.data (i) /= neg (wrt) then
               r.add (right.data (i));
            end if;
         end loop;
         return r;
      end DoRes;
         
      
   end Logik;
   
   use Logik;
   
   package Formeln is new Ada.Containers.Vectors
     (Element_Type => Klausel,
      Index_Type => Natural);
   subtype Formel is Formeln.Vector; 
   use Formeln;
   
   procedure Put (f : Formel) is
      procedure over (d : Cursor) is
         b : Klausel;
      begin
         b := Element (d);
         Put (b.data (Index'First .. b.len) & ", ");
      end over;
   begin
      Put ('{');
      Iterate (f, over'Access);
      Put_Line ("}");
   end Put;
   
      
   function Res (f : Formel) return Formel is
      use Formeln;
      rf : Formel;
      a, b, r : Klausel;
      wrt : Character;
      
      procedure overA (c : Cursor) is
      
         procedure overB (d : Cursor) is
         begin
            b := Element (d);
            wrt := CanRes (a, b);
            if wrt /= ' ' then
               r := DoRes (a, b, wrt);
               if not Contains (rf, r) then
                  Append (rf, r);
               end if;
            end if;
         end overB;
         
      begin
         a := Element (c);
         Iterate (f, overB'Access);
      end overA;
      
   begin
      Iterate (f, overA'Access);
      return rf;
   end Res;
   
   procedure merge (into : in out Formel; what : Formel) is
      procedure each (c : Cursor) is 
         k : Klausel;
      begin
         k := Element (c);
         if not into.Contains (k) then
            into.Append (k);
         end if;
      end each;
   begin 
      what.Iterate (each'Access);
   end merge;
   
   
   k : Klausel;
   f : Formel;
   rf : Formel;
begin
   Append (f, ("ab      ", 3));
   Append (f, ("AB      ", 3));
   Append (f, ("aB      ", 3));
   Append (f, ("Ab      ", 3));
   Put (f);
   rf := Res (f);
   merge (f, rf);
   Put (f);
   rf := Res (f);
   merge (f, rf);
   Put (f);
      rf := Res (f);
   merge (f, rf);
   Put (f);
   k := Leer;
   k.add ('a');
   k.add ('B');
   k.add ('B');
   k.add ('c');
   k.add (neg ('d'));
   Put_Line (k.data);
   Put (Integer'Image (DoRes (("Ab      ", 3), ("ac      ", 3), 'a').len));
   Put (DoRes (("Ab      ", 3), ("ac      ", 3), 'a').data);
end Res;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;