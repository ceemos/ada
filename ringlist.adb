--  @File : ringlist.adb
--
--  @Project : Programmieruebungen, Uebungsblatt 9
--  @Version : 1
--  @Created : 17. 12. 2011
--  @Author : Marcel Schneider
-- Compile: gnatmake -g ringlist_test.adb
-- Run: ./ringlist_test
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
      procedure Insert_In_Order (Element : Ref_Element; Count : Integer) is
      begin
         if (Element.Content < E and E < Element.Next.Content) 
            or ((Element.Content < E) = (E < Element.Content)) --  istgleich
            or Count = 1
            then
            --  Einfuegen
            Temp.Next := Element.Next;
            Element.Next := Temp;
            
            --  Kopf Neusetzen, falls kleiner als alle anderen
            if E < L.First.Content then
               L.First := Temp;
            end if;
         else 
            Insert_In_Order(Element.Next, Count - 1);
         end if;
      end Insert_In_Order;
   begin
      Temp := new Listelement;
      Temp.Content := E;
      --  1. Element der Liste 
      if L.First = null then
         L.First := Temp;
         Temp.Next := Temp;
      else
         Insert_In_Order (L.First, L.Size);
      end if;
      
      L.Size := L.Size + 1;
      
   end Insert;
      
      
   procedure Clear (L : in List) is
   begin
      L.First := null;
      L.Size := 0;
   end Clear;
   
   
   function Contains (L : in List; E : in Element_Type) return Boolean is
      function Find (Element : Ref_Element; Count : Natural) return Boolean is
      begin
         if Element.Content = E then
            return True;
         end if;
         return Count > 0 and then Find (Element.Next, Count - 1);
      end Find;
   begin
      return L.First /= null and then Find (L.First, L.Size);
   end Contains;
   
   
   function Equals (L1, L2 : in List) return Boolean is
      function Compare (Element_Left, Element_Right : Ref_Element; 
                        Count : Integer) return Boolean is
      begin
         if Count > 0 then
            return Element_Left.Content = Element_Right.Content and then 
                  Compare (Element_Left.Next, Element_Right.Next, Count - 1);
         else 
            return True;
         end if;
      end Compare;
           
   begin
      if L1.Size /= L2.Size then
         return False;
      end if;
      return Compare (L1.First, L2.First, L1.Size);
   end Equals;
      
   function Is_Empty (L : in List) return Boolean is 
   begin
      return L.First = null;
   end Is_Empty;
   
   
   procedure Remove (L : in List; E : in Element_Type) is
      procedure Find_And_Remove (Element : Ref_Element; Count : Integer) is
      begin
         if Element.Next.Content = E then
            if Element.Next = L.First then
               --  Sonst gibts eine Schleife deren ende nie mehr zu finden ist
               L.First := Element.Next.Next;
            end if;
            Element.Next := Element.Next.Next;
            L.Size := L.Size - 1;
         else
            if Count >= 0 then
               Find_And_Remove (Element.Next, Count - 1);
            end if;
         end if;
      end Find_And_Remove;
   begin
      if L.Size /= 0 then
         Find_And_Remove (L.First, L.Size);
         if L.Size = 0 then
            L.First := null;
         end if;
      end if;
   end Remove;

   procedure Remove_All (L : in List; E : in Element_Type) is
      procedure Find_And_Remove (Element : Ref_Element; Count : Integer) is
      begin
         --  Leere Liste erkennen
         if L.Size > 0 then 
            if Element.Next.Content = E then
               if Element.Next = L.First then
                  L.First := Element.Next.Next;
               end if;
               
               L.Size := L.Size - 1;
               --  Zus. Rekursion weil ein El. uebersprungen wird
               Find_And_Remove (Element.Next, 0);
               Element.Next := Element.Next.Next;
               
            end if;
            if Count > 0 then
               Find_And_Remove (Element.Next, Count - 1);
            end if;
         end if;
      end Find_And_Remove;
   begin
      if L.Size /= 0 then
         Find_And_Remove (L.First, L.Size);
         if L.Size = 0 then
            L.First := null;
         end if;
      end if;
   end Remove_All;

   function Size (L : in List) return Natural is
   begin
      return L.Size;
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