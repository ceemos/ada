--  @File : ringlist.adb
--
--  @Project : Programmieruebungen, Uebungsblatt 9
--  @Version : 1
--  @Created : 17. 12. 2011
--  @Author : Marcel Schneider
--
-------------------------------------------------------------------------------
--
--
with Ada.Text_IO;
use Ada.Text_IO;
package body Ringlist is

   procedure New_List (L : out List) is
   begin
      L := new Anchor;
      L.First := null;
      L.Size := 0;
   end New_List;
   
   procedure Insert (L : in List; E : in Element_Type) is
      Temp : Ref_Element;
      Current : Ref_Element;
   begin
      Temp := L.First;
      L.First := new Listelement;
      L.First.Content := E;
      L.First.Next := Temp;
      --  Zunaechst mal nicht sortieren
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
      
      
   procedure Clear (L : in List) is
   begin
      L.First := null;
   end Clear;
   
   
   function Contains (L : in List; E : in Element_Type) return Boolean is
      Current : Ref_Element;
   begin
      if not Is_Empty (L) then
         Current := L.First;
         while Current.Next /= L.First loop
            if Current.Content = E then
               return True;
            end if;
            Current := Current.Next;
         end loop;
         if Current.Content = E then
            return True;
         end if;
      end if;
      return False;
   end Contains;
   
   
   function Equals (L1, L2 : in List) return Boolean is
      Current_Left, Current_Right : Ref_Element;
   begin
      if L1.First = null and L2.First = null then
         return True;
      end if;
      if L1.First = null or L2.First = null then
         return False;
      end if;
      Current_Left := L1.First;
      Current_Right := L2.First;
      while Current_Left.Next /= L1.First loop
         if Current_Left.Content /= Current_Right.Content then
            return False;
         end if;
         Current_Left := Current_Left.Next;
         Current_Right := Current_Right.Next;
      end loop;
      if Current_Left.Content /= Current_Right.Content then
         return False;
      end if;
      return True;
   end Equals;
      
   function Is_Empty (L : in List) return Boolean is 
   begin
      return L.First = null;
   end Is_Empty;
   
   
   procedure Remove (L : in List; E : in Element_Type) is
      Current : Ref_Element;
   begin
      if not Is_Empty (L) then
         Current := L.First;
         --  Vorhergehendes El. suchen
         while Current.Next /= L.First and Current.Next.Content /= E loop
            Current := Current.Next;
         end loop;
         --  gesuchtes ausschliessen
         if Current.Next /= Current.Next.Next then
            if Current.Next = L.First then
               --  Sonst gibts eine Schleife deren ende nie mehr zu finden ist
               L.First := Current.Next.Next;
            end if;
            Current.Next := Current.Next.Next;
         else
            --  Es gibt nur ein El.
            L.First := null;
         end if;
      end if;
   end Remove;

   procedure Remove_All (L : in List; E : in Element_Type) is
      Current : Ref_Element;
   begin
      if not Is_Empty (L) then
         Current := L.First;
         --  Vorhergehendes El. suchen
         while Current.Next /= L.First loop
            if Current.Next.Content = E then
               --  gesuchtes ausschliessen
               if Current.Next /= Current.Next.Next then
                  if Current.Next = L.First then
                     --  Sonst gibts eine Schleife deren ende nie mehr zu finden ist
                     L.First := Current.Next.Next;
                  end if;
                  Current.Next := Current.Next.Next;
               else
                  --  Es gibt nur ein El.
                  L.First := null;
               end if;
            end if;
            Current := Current.Next;
         end loop;
         
         --  Noch das 1. Pruefen
         if L.First.Content = E then
            L.First := L.First.Next;
            Current.Next := L.First;
         end if;
      end if;
   end Remove_All;

   function Size (L : in List) return Natural is
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
   
   procedure Put (L : in List) is
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