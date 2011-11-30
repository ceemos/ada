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
      
   end Logik;
   
   package body Logik is
      procedure add (this : in out Klausel; what : Character) is
      begin
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
   end Logik;
   
   use Logik;
   
   k : Klausel;
begin
   k := Leer;
   k.add ('a');
   k.add ('B');
   
   Put (k.data);
end Res;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;