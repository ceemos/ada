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
with Ada.Numerics.Discrete_Random;
use Ada.Text_IO;
procedure Res is
   subtype Index is Integer range 1 .. 8;
   
   package Klauseln is
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
         
      function isPositive (this : Klausel) return Boolean;

   end Klauseln;
   
   package body Klauseln is
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
      
      function isPositive (this : Klausel) return Boolean is
      begin
         for i in Index'First .. this.len loop
            if Ada.Characters.Handling.Is_Upper (this.data (i)) then
               return False;
            end if;
         end loop;
         return True;
      end isPositive;
         
      
   end Klauseln;
   
   use Klauseln;
   
   package Formeln is new Ada.Containers.Vectors
     (Element_Type => Klausel,
      Index_Type => Natural);
   subtype Formel is Formeln.Vector; 
   use Formeln;
   use Ada.Containers;
   
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
      
      procedure overB (d : Cursor) is
      begin
         b := Element (d);
         --  if a.isPositive or b.isPositive then --  PosRes
            wrt := CanRes (a, b);
            if wrt /= ' ' then
               r := DoRes (a, b, wrt);
               if not Contains (rf, r) and not Contains (f, r) then
                  Append (rf, r);
               end if;
            end if;
         --  end if;
      end overB;
         
      procedure overA (c : Cursor) is 
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
   
   function LinRes (f : Formel; wrt : Klausel) return Boolean is
      moeglich : Boolean := False;  
      
      procedure each (c : Cursor) is 
         k : Klausel;
         r : Klausel;
         res_wrt : Character;
         f_neu : Formel := f;

      begin
         if moeglich then return; end if;
         k := Element (c);
         if not isPositive (k) and not isPositive (wrt) then
            return; -- LinPosRes
         end if;
         res_wrt := CanRes (k, wrt);
         if res_wrt /= ' ' then
            r := DoRes (k, wrt, res_wrt);
            if not f_neu.Contains (r) then
               f_neu.Append (r);
            else 
               return;
            end if;
            --  Put (f_neu);
            if f_neu.Contains (Leer) then
               --  Put_Line ("Hab leer als LinRes");
               Put ("Erg: ");
               Put (f_neu);
               moeglich := True;
               return;
            end if;
            if not moeglich then 
               --  Put ("Try: ");
               --  Put (f_neu);
               moeglich := LinRes (f_neu, r);
               if moeglich then
                  --  Put ("Weg: ");
                  --  Put (f_neu);
                  return;
               end if;
            end if;
         end if;
      end each;
   begin
      f.Iterate (each'Access);
      return moeglich;
   end LinRes;
   
   function normRes (f_in : Formel) return Boolean is 
      rf : Formel;
      f : Formel := f_in;
   begin
      loop
         --  Put (f);
         rf := Res (f);
         merge (f, rf);
         if rf.Contains (Leer) then
            Put (f);
            --  Put_Line ("Hab die leere Klausel, Schluss.");
            return True;
         elsif rf.Length = 0 then
            --  Put_Line ("Kann nimmer resolvieren, Schluss.");
            return False;
         end if;
      end loop;
   end normRes;
      
   
   function LinRes (f : Formel) return Boolean is
      moeglich : Boolean := False;
      procedure each (c : Cursor) is 
         k : Klausel;
      begin
         if moeglich then return; end if;
         k := Element (c);
         if LinRes (f, k) then
            moeglich := True;
            return;
         end if;
      end each;
   begin 
      f.Iterate (each'Access);
      return moeglich;
   end LinRes;
   
   subtype alphas is Integer range 1 .. 8;
   package Rand_Alpha is new Ada.Numerics.Discrete_Random (alphas);
   seed : Rand_Alpha.Generator;
   literale : String := "aAbBcCdDeEfF";
   
   function Zufaellige_Klausel (len : Index) return Klausel is 
      k : Klausel;
      c : Character;
   begin
      k := Leer;
      while k.len < len loop
         c := literale (Rand_Alpha.Random (seed));
         if not k.contains (neg (c)) then
            k.add (c);
         end if;
      end loop;
      return k;
   end Zufaellige_Klausel;
   
   function Zufaellige_Neg_Klausel (len : Index) return Klausel is 
      k : Klausel;
      c : Character;
   begin
      k := Leer;
      while k.len < len loop
         c := literale (Rand_Alpha.Random (seed));
         if Ada.Characters.Handling.Is_Upper (c) then
            k.add (c);
         end if;
      end loop;
      return k;
   end Zufaellige_Neg_Klausel;
   
   function Zufaellige_Pos_Klausel (len : Index) return Klausel is 
      k : Klausel;
      c : Character;
   begin
      k := Leer;
      while k.len < len loop
         c := literale (Rand_Alpha.Random (seed));
         if not Ada.Characters.Handling.Is_Upper (c) then
            k.add (c);
         end if;
      end loop;
      return k;
   end Zufaellige_Pos_Klausel;
   
   function Zufaellige_Formel (len : Natural) return Formel is 
      f : Formel;
   begin
      f.Append (Zufaellige_Neg_Klausel (2));
      f.Append (Zufaellige_Pos_Klausel (2));
      for i in 1 .. len loop
         f.Append (Zufaellige_Klausel (2));
      end loop;
      return f;
   end Zufaellige_Formel;
   
   
   k : Klausel;
   f : Formel;
   
   unerfuellbar : Boolean;
   linresbar : Boolean;
   
   erfuellbare, unerfuellbare : Natural := 0;
begin

   Rand_Alpha.Reset (seed);
   
--    Append (f, ("ab      ", 3));
--    Append (f, ("AB      ", 3));
--    Append (f, ("aB      ", 3));
--    Append (f, ("Ab      ", 3));
   
   loop
      f := Zufaellige_Formel (3);
      unerfuellbar := normRes (f);
      
      if unerfuellbar then
         --  Put_Line ("f unerfuellbar");
         unerfuellbare := unerfuellbare + 1;
         Put_Line ("unerfuellbare:" & Integer'Image (unerfuellbare) 
            & "  erfuellbare:" & Integer'Image (erfuellbare));
         linresbar := LinRes (f);
         if linresbar then
            --  Put_Line ("LinRes mgl.");
            null;
         else
            Put_Line ("Got It!");
            Put (f);
            exit;
         end if;
      else 
         erfuellbare := erfuellbare + 1;
--          Put_Line ("unerfuellbare:" & Integer'Image (unerfuellbare) 
--             & "  erfuellbare:" & Integer'Image (erfuellbare));
      end if;
   end loop;

--    k := Leer;
--    k.add ('a');
--    k.add ('B');
--    k.add ('B');
--    k.add ('c');
--    k.add (neg ('d'));
--    Put_Line (k.data);
--    Put (Integer'Image (DoRes (("Ab      ", 3), ("ac      ", 3), 'a').len));
--    Put (DoRes (("Ab      ", 3), ("ac      ", 3), 'a').data);
end Res;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;