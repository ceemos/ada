--  @File: rationale_zahlen.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 8
--  @Version: 1
--  @Created: 11. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------



with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO;
package body Rationale_Zahlen is

   function ">" (Links, Rechts : in Rationale_Zahl) return Boolean is
      Diff : Rationale_Zahl := (Links - Rechts);
   begin
      return Diff.Zaehler > 0;
   end ">";
   
   function "<" (Links, Rechts : in Rationale_Zahl) return Boolean is
      Diff : Rationale_Zahl := (Links - Rechts);
   begin
      return Diff.Zaehler < 0;
   end "<";
   
   function "=" (Links, Rechts : in Rationale_Zahl) return Boolean is
   begin
      return Links.Zaehler = Rechts.Zaehler and Links.Nenner = Rechts.Nenner;
   end "=";
   
   function "-" (Links : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (-Links.Zaehler, Links.Nenner);
   end "-";
   
   function "+" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links.Zaehler * Rechts.Nenner 
                                   + Rechts.Zaehler * Links.Nenner,
                                Links.Nenner * Rechts.Nenner);
   end "+";
   
   function "-" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links.Zaehler * Rechts.Nenner 
                                   - Rechts.Zaehler * Links.Nenner,
                                Links.Nenner * Rechts.Nenner);
   end "-";
   
   
   function "*" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links.Zaehler * Rechts.Zaehler, 
                                 Links.Nenner * Rechts.Nenner);
   end "*";
   
   function "/" (Links : in Integer; Rechts : in Positive) 
         return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links, Rechts);
   end "/";
   
   function "/" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links.Zaehler * Rechts.Nenner, 
                                 Links.Nenner * Rechts.Zaehler);
   end "/";
   
   procedure Put (Z : in Rationale_Zahl) is
   begin
      Put ("(" & Z.Zaehler'Img & "/" & Z.Nenner'Img & ")");
   end Put;

   procedure Get (Z : out Rationale_Zahl) is
      Zaehler, Nenner : Integer;
   begin
      Put_Line ("Geben Sie den Zaehler ein!");
      Ada.Integer_Text_IO.Get (Zaehler);
      Put_Line ("Geben Sie den Nenner ein!");
      Ada.Integer_Text_IO.Get (Nenner);
      Set (Z, Zaehler, Nenner);
   exception
      when Constraint_Error =>
         Put_Line ("Bitte geben Sie einen Pos. Nenner ein!");
         Get (Z);
      when Data_Error =>
         Put_Line ("Bitte geben Sie Zahlen ein!");
         Put_Line ("Gebe Auf.");
   end Get;
   

   procedure Set (A : out Rationale_Zahl; B : in Rationale_Zahl) is
   begin
      A := B;
   end Set;
   
   procedure Set (Z : out Rationale_Zahl; 
            Zaehler : in Integer; 
             Nenner : in Positive := 1) is
      GGT_NZ : Integer;
   begin
      GGT_NZ := GGT (abs Zaehler, Nenner);
      Z.Zaehler := Zaehler / GGT_NZ;
      Z.Nenner := Nenner / GGT_NZ;
   end Set;


   function GGT (A, B : in Natural) return Natural is
   begin
      if B = 0 then
         return A;
      else 
         return GGT(B, A mod B);
      end if;
   end GGT;
   
   function KGV (A, B : in Natural) return Natural is
      GGT_AB : Natural;
   begin
      GGT_AB := GGT (A, B);
      return (A * B) / GGT_AB;
   end KGV;
   
   
   function To_Rationale_Zahl (Zaehler : in Integer; Nenner : in Positive := 1)
      return Rationale_Zahl is
      Erg : Rationale_Zahl;
   begin
      Set (Erg, Zaehler, Nenner);
      return Erg;
   end To_Rationale_Zahl;
   
end Rationale_Zahlen;


--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;