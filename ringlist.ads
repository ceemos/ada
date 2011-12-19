generic
   type Element_Type is private;
   with function "<" (Left, Right: in Element_Type) return Boolean;
   with function "=" (Left, Right: in Element_Type) return Boolean;
   with procedure Put (E: in Element_Type);

package Ringlist is
   type Anchor is limited private;
   type List is access Anchor;
   procedure New_List (L: out List);
   procedure Insert (L: in List; E: in Element_Type);
   procedure Clear (L: in List);
   function Contains (L: in List; E: in Element_Type) return Boolean;
   function Equals (L1, L2: in List) return Boolean;
   function Is_Empty (L: in List) return Boolean;
   procedure Remove (L: in List; E: in Element_Type);
   procedure Remove_All (L: in List; E: in Element_Type);
   function Size (L: in List) return Natural;
   procedure Put (L: in List);
   Empty_List_Error: exception;

   private
   type Listelement;
   type Ref_Element is access Listelement;
   type Listelement is record
      Next: Ref_Element;
      Content: Element_Type;
   end record;
   type Anchor is record
      First: Ref_Element;
      Size: Natural;
   end record;
end Ringlist;
