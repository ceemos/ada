--  @File: ringlist.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 9
--  @Version: 1
--  @Created: 17. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--
with Ada.Text_IO;
use Ada.Text_IO;
package body Ringlist is

   procedure New_List (L: out List) is
   begin
      L := new Anchor;
      L.First := null;
      L.Size := 0;
   end New_List;
   
   procedure Insert (L: in List; E: in Element_Type) is
      Temp : Ref_Element;
      Current : Ref_Element;
   begin
      Temp := L.First;
      L.First := new Listelement;
      L.First.Content := E;
      L.First.Next := Temp;
      
      --  1. Element der Liste 
      if Temp = null then
         L.First.Next := L.First;
      else
         --  Listenende Suchen
         Current := L.First.Next;
         while (Current.Next /= Temp) loop
            Current := Current.Next;
         end loop;
      
         --  Ringschluss reparieren
         Current.Next := L.First;
      end if;
      
   end Insert;
      --  Zunaechst mal nicht sortieren
      
   procedure Clear (L: in List) is
   begin
      L.First := null;
   end Clear;
--    function Contains (L: in List; E: in Element_Type) return Boolean;
--    function Equals (L1, L2: in List) return Boolean;
   function Is_Empty (L: in List) return Boolean is 
   begin
      return L.First = null;
   end Is_Empty;
   procedure Remove (L: in List; E: in Element_Type) is
      Current : Ref_Element;
   begin
      if not Is_Empty (L) then
         Current := L.First;
         --  Vorhergehendes El. suchen
         while Current.Next /= L.First and Current.Next.Content /= E loop
            Current := Current.Next;
         end loop;
         -- gesuchtes ausschliessen
         if Current.Next /= Current.Next.Next then
            Current.Next := Current.Next.Next;
         else
            --  Es gibt nur ein El.
            L.First := null;
         end if;
      end if;
   end Remove;
   
--    procedure Remove_All (L: in List; E: in Element_Type);

   function Size (L: in List) return Natural is
      Count : Natural := 1;
      Current : Ref_Element;
   begin
      if Is_Empty (L) then
         return 0;
      end if;
      Current := L.First;
      while Current.Next /= L.First loop
         Current := Current.Next;
         Count := Count + 1;
      end loop;
      return Count;
   end Size;
   
   procedure Put (L: in List) is
      Current : Ref_Element;
   begin
      Current := L.First;
      while Current /= null and then Current.Next /= L.First loop
         Put (Current.Content);
         Current := Current.Next;
      end loop;
      --  wenn die Liste nicht leer war, das letzte El. ausgeben
      if Current /= null then
         Put (Current.Content);
      end if;
   end Put;
  
end Ringlist;


--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;