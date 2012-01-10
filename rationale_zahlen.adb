--  @File: rationale_zahlen.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 8
--  @Version: 1
--  @Created: 11. 12. 2011
--  @Author: Marcel Schneider, Ulrich Zendler, Philipp Klaas
--
-------------------------------------------------------------------------------
--  Enthaelt einen Datentyp fuer rationale Zahlen und die noetigen Operationen 
--  dafuer.



with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO;
package body Rationale_Zahlen is 
   
   --  @Function: ">" 
   --
   --  Vergleicht zwei rationale Zahlen
   --
   --  @Parameter: 
   --   + Links: die eine rationale Zahl
   --   + Rechts: die andere rationale Zahl.
   --  
   --  @Return: True, falls die linke Zahl groesser der rechten ist.
   --  
   function ">" (Links, Rechts : in Rationale_Zahl) return Boolean is
      Diff : Rationale_Zahl := (Links - Rechts);
   begin
      return Diff.Zaehler > 0;
   end ">";
   
   --  @Function: "<" 
   --
   --  Vergleicht zwei rationale Zahlen
   --
   --  @Parameter: 
   --   + Links: die eine rationale Zahl
   --   + Rechts: die andere rationale Zahl.
   --  
   --  @Return: True, falls die linke Zahl kleiner der rechten ist.
   --  
   function "<" (Links, Rechts : in Rationale_Zahl) return Boolean is
      Diff : Rationale_Zahl := (Links - Rechts);
   begin
      return Diff.Zaehler < 0;
   end "<";
   
   --  @Function: "=" 
   --
   --  Vergleicht zwei rationale Zahlen
   --
   --  @Parameter: 
   --   + Links: die eine rationale Zahl
   --   + Rechts: die andere rationale Zahl.
   --  
   --  @Return: True, falls die linke Zahl gleich der rechten ist.
   --  
   function "=" (Links, Rechts : in Rationale_Zahl) return Boolean is
   begin
      return Links.Zaehler = Rechts.Zaehler and Links.Nenner = Rechts.Nenner;
   end "=";
   
   --  @Function: "-" 
   --
   --  Aendert das Vorzeichen einer rationalen Zahl.
   --
   --  @Parameter: 
   --   + Links: die Zahl
   --  
   --  @Return: die Zahl mit umgekehrtem Vorzeichen.
   --  
   function "-" (Links : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (-Links.Zaehler, Links.Nenner);
   end "-";
   
   --  @Function: "+" 
   --
   --  Berechnet die Summe zweier rationaler Zahlen. 
   --
   --  @Parameter: 
   --   + Links: die eine Zahl
   --   + Rechts: die andere Zahl.
   --  
   --  @Return: die Summe
   --  
   function "+" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links.Zaehler * Rechts.Nenner 
                                   + Rechts.Zaehler * Links.Nenner,
                                Links.Nenner * Rechts.Nenner);
   end "+";
   
   --  @Function: "-" 
   --
   --  Berechnet die Differenz zweier rationaler Zahlen. 
   --
   --  @Parameter: 
   --   + Links: die eine Zahl
   --   + Rechts: die andere Zahl.
   --  
   --  @Return: die Differenz
   --  
   function "-" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return Links + (-Rechts);
   end "-";
   
   
   --  @Function: "*" 
   --
   --  Berechnet das Produkt zweier rationaler Zahlen. 
   --
   --  @Parameter: 
   --   + Links: die eine Zahl
   --   + Rechts: die andere Zahl.
   --  
   --  @Return: das Produkt.
   --  
   function "*" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links.Zaehler * Rechts.Zaehler, 
                                 Links.Nenner * Rechts.Nenner);
   end "*";
   
   --  @Function: "/" 
   --
   --  Erzeugt eine Rationale Zahl aus zwei ganzen Zahlem. 
   --
   --  @Parameter: 
   --   + Links: der Zaehler
   --   + Rechts: der Nenner
   --  
   --  @Return: die Zahl (Zaehler/Nenner) 
   --  
   function "/" (Links : in Integer; Rechts : in Positive) 
         return Rationale_Zahl is
   begin
      return To_Rationale_Zahl (Links, Rechts);
   end "/";
   
   --  @Function: "/" 
   --
   --  Berechnet den Quotienten zweier rationaler Zahlen. 
   --
   --  @Parameter: 
   --   + Links: die eine Zahl
   --   + Rechts: die andere Zahl.
   --  
   --  @Return: das Ergebnis der Divison.
   --  
   function "/" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl is
   begin
      if Rechts > 0 / 1 then
         return To_Rationale_Zahl (Links.Zaehler * Rechts.Nenner, 
                                   Links.Nenner * Rechts.Zaehler);
      elsif Rechts < 0 / 1 then
         return -To_Rationale_Zahl (Links.Zaehler * Rechts.Nenner, 
                                    abs (Links.Nenner * Rechts.Zaehler));
      end if;
      --  Division durch 0
      raise Constraint_Error;
   end "/";
   
   --  @Procedure: Put 
   --
   --  gibt eine rationale Zahl aus.
   --
   --  @Parameter: 
   --   + Z: die auszugebende Zahl.
   --  
   procedure Put (Z : in Rationale_Zahl) is
   begin
      Put ("(");
      Ada.Integer_Text_IO.Put (Z.Zaehler, 4);
      Put ("/");
      Ada.Integer_Text_IO.Put (Z.Nenner, 4);
      Put (")");
   end Put;

   --  @Procedure: Get 
   --
   --  Liest eine rationale Zahl vom Benutzer ein.
   --
   --  @Parameter: 
   --   + Z: Variable, in die die Zahl gespeichert werden soll.
   --  
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
   end Get;
   

   --  @Procedure: Set 
   --
   --  Setzt eine rationale Zahl auf einen neuen Wert.
   --
   --  @Parameter: 
   --   + A: die zu setzende Zahl
   --   + B: der neue Wert
   --  
   procedure Set (A : out Rationale_Zahl; B : in Rationale_Zahl) is
   begin
      A := B;
   end Set;
   
   --  @Procedure: Set 
   --
   --  Setzt eine rationale Zahl auf einen neuen Wert.
   --
   --  @Parameter: 
   --   + A: die zu setzende Zahl
   --   + Zaehler: der Zaehler des neuen Wertes
   --   + Nenner: der Nenner des neuen Wertes.
   --  
   procedure Set (Z : out Rationale_Zahl; 
            Zaehler : in Integer; 
             Nenner : in Positive := 1) is
      GGT_NZ : Integer;
   begin
      GGT_NZ := GGT (abs Zaehler, Nenner);
      Z.Zaehler := Zaehler / GGT_NZ;
      Z.Nenner := Nenner / GGT_NZ;
   end Set;


   --  @Function: GGT 
   --
   --  berechnet den groessten gemeinsamen Teiler zweier natuerlicher Zahlen.
   --
   --  @Parameter: 
   --   + A: die eine Zahl
   --   + B: die andere
   --  
   --  @Return: der GGT
   --  
   function GGT (A, B : in Natural) return Natural is
   begin
      if B = 0 then
         return A;
      else 
         return GGT (B, A mod B);
      end if;
   end GGT;
   
   --  @Function: KGV 
   --
   --  berechnet das kleinste gemeinsame Vielfache zweier natuerlicher Zahlen.
   --
   --  @Parameter: 
   --   + A: die eine Zahl
   --   + B: die andere
   --  
   --  @Return: das KGV
   --
   function KGV (A, B : in Natural) return Natural is
      GGT_AB : Natural;
   begin
      GGT_AB := GGT (A, B);
      return (A * B) / GGT_AB;
   end KGV;
   
   
   --  @Function: To_Rationale_Zahl 
   --
   --  Erzeugt eine neue, gekuerzte rationale Zahl aus Zaehler und Nenner
   --
   --  @Parameter: 
   --   + Zaehler: der Zaehler
   --   + Nenner: der Nenner
   --  
   --  @Return: die vollst. gekuerzte rationale Zahl.
   --  
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