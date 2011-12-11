package Rationale_Zahlen is
   type Rationale_Zahl is limited private;

   function ">" (Links, Rechts : in Rationale_Zahl) return Boolean;
   function "<" (Links, Rechts : in Rationale_Zahl) return Boolean;
   function "=" (Links, Rechts : in Rationale_Zahl) return Boolean;
   function "-" (Links : in Rationale_Zahl) return Rationale_Zahl;
   function "+" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl;
   function "-" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl;
   function "*" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl;
   function "/" (Links : in Integer; Rechts : in Positive) return Rationale_Zahl;
   function "/" (Links, Rechts : in Rationale_Zahl) return Rationale_Zahl;
   procedure Put (Z : in Rationale_Zahl);
   procedure Get (Z : out Rationale_Zahl);
   procedure Set (A : out Rationale_Zahl; B : in Rationale_Zahl);
   procedure Set (Z : out Rationale_Zahl; Zaehler : in Integer; Nenner : in Positive := 1);

   function GGT (A, B : in Natural) return Natural;
   function KGV (A, B : in Natural) return Natural;
   private
   type Rationale_Zahl is record
      Zaehler : Integer;
      Nenner  : Positive := 1;
   end record;

   function To_Rationale_Zahl (Zaehler : in Integer; Nenner : in Positive := 1) return Rationale_Zahl;
end Rationale_Zahlen;
