with Ada.Text_IO, Ada.Numerics.Discrete_Random, Ada.Unchecked_Deallocation;

generic
   type Content_Type is private;
   with procedure Put (E : in Content_Type);

package Tree_Package is
   type Node is limited private;
   type Edge is limited private;
   procedure Insert (Root : in out Edge; Content : in Content_Type);
   procedure Delete (Root : in out Edge; Content : in Content_Type);
   procedure Put (Root : in Edge);
   procedure Copy (Root_Org : in Edge; Root_Cp : out Edge);
   procedure Clone (Root_Org : in Edge; Root_Cp : out Edge);
   function Equal (Root_Org, Root_Cp : in Edge) return Boolean;
   function Similar (Root_Org, Root_Cp : in Edge) return Boolean;
   function Find (Root : in Edge; Content : in Content_Type) return Natural;
   function Size (Root : in Edge) return Natural;

private
   package Random_Integer is new Ada.Numerics.Discrete_Random (Integer);

   type Node is record
      Content : Content_Type;
      Left, Right : Edge;
   end record;
   type Edge is access Node;

   Generator : Random_Integer.Generator;
   Init : Boolean := True;
   function Next_Random_Integer return Integer;
   procedure Free is new Ada.Unchecked_Deallocation
                  (Object => Node, Name => Edge);
end Tree_Package;
