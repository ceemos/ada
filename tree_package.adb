with Ada.Text_IO;
use Ada.Text_IO;

package body Tree_Package is

   ------------
   -- Insert --
   ------------

   procedure Insert (Root : in out Edge; Content : in Content_Type) is
   begin
      if Init then
         Random_Integer.Reset (Generator);
         Init := False;
      end if;
      if Root = null then
         Root := new Node'(Content, null, null);
      else
         if Next_Random_Integer < 0 then
            Insert (Root.Left, Content);
         else
            Insert (Root.Right, Content);
         end if;
      end if;
   end Insert;

   ------------
   -- Delete --
   ------------

   procedure Delete (Root : in out Edge; Content : in Content_Type) is
      Tmp, Del : Edge;
   begin
      if Root /= null then
         Delete (Root.Left, Content);
         Delete (Root.Right, Content);
         if Root.Content = Content then
            Del := Root;
            if Root.Right = null then
               Root := Root.Left;
            else
               Tmp := Root.Right;
               if Tmp.Left = null then
                  Tmp.Left := Root.Left;
                  Root := Tmp;
               else
                  while Tmp.Left.Left /= null loop
                     Tmp := Tmp.Left;
                  end loop;
                  Root.Content := Tmp.Left.Content;
                  Del := Tmp.Left;
                  Tmp.Left := Tmp.Left.Right;
               end if;
            end if;
            Free (Del);
         end if;
      end if;
   end Delete;

   ---------
   -- Put --
   ---------

   procedure Put (Root : in Edge) is
   begin
      if Root /= null then
         Put (Root.Content);
         if Root.Left /= null or Root.Right /= null then
            Put ("(");
            Put (Root.Left);
            Put (", ");
            Put (Root.Right);
            Put (")");
         end if;
      else 
         Put ("null");
      end if;
   end Put;

   ----------
   -- Copy --
   ----------

   procedure Copy (Root_Org : in Edge; Root_Cp : out Edge) is
      --  TODO: Die Aufgabe verlangt, dass die Baeume _nicht_ identisch sind. 
      --  dies wird hier noch nicht erzwungen, da das Verhalten von Insert 
      --  nicht vorhersehbar ist, ist es auch nicht so leicht moeglich.
      --  Zudem ist es in Falle von Size = 1 auch unmoeglich.
      procedure Insert_All (Root : in Edge) is
      begin
         if Root /= null then
            Insert_All (Root.Left);
            Insert_All (Root.Right);
            Insert (Root_Cp, Root.Content);
         end if;
     end Insert_All;
   begin
      Root_Cp := null;
      Insert_All (Root_Org);
   end Copy;

   -----------
   -- Clone --
   -----------

   procedure Clone (Root_Org : in Edge; Root_Cp : out Edge) is
      Left_Clone, Right_Clone : Edge;
   begin
      if Root_Org /= null then
         Clone (Root_Org.Left, Left_Clone);
         Clone (Root_Org.Right, Right_Clone);
         Root_Cp := new Node'(Root_Org.Content, Left_Clone, Right_Clone);
      else
         Root_Cp := null;
      end if;
   end Clone;

   -----------
   -- Equal --
   -----------

   function Equal (Root_Org, Root_Cp : in Edge) return Boolean is
   begin
      return (Root_Org = Root_Cp) 
         or else ((Root_Org /= null and Root_Cp /= null)
         and then Root_Org.Content = Root_Cp.Content
         and then Equal (Root_Org.Right, Root_Cp.Right)
         and then Equal (Root_Org.Left, Root_Cp.Left));
   end Equal;

   -------------
   -- Similar --
   -------------

   function Similar (Root_Org, Root_Cp : in Edge) return Boolean is
      -- mglw. gibts auch wege mit weniger aufrufen von Find, aber so ists 
      -- einfach...      
      function All_Contained (Root : Edge) return Boolean is
      begin
         return Root = null or else (
            Find (Root_Org, Root.Content) = Find (Root_Cp, Root.Content) and
            All_Contained (Root.Left) and All_Contained (Root.Right)
            );
      end All_Contained;
   begin
      return Size (Root_Org) = Size (Root_Cp) and All_Contained (Root_Org);
   end Similar;

   ----------
   -- Find --
   ----------

   function Find (Root : in Edge; Content : in Content_Type) return Natural is
   begin
      if Root /= null then
         if Root.Content = Content then
            return 1 + Find (Root.Left, Content) + Find (Root.Right, Content);
         else
            return 0 + Find (Root.Left, Content) + Find (Root.Right, Content);
         end if;
      else
         return 0;
      end if;
   end Find;

   ----------
   -- Size --
   ----------

   function Size (Root : in Edge) return Natural is
   begin
      if Root /= null then
         return 1 + Size (Root.Left) + Size (Root.Right);
      else
         return 0;
      end if;
   end Size;

   -------------------------
   -- Next_Random_Integer --
   -------------------------

   function Next_Random_Integer return Integer is
   begin
      return Random_Integer.Random (Generator);
   end Next_Random_Integer;

end Tree_Package;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;
