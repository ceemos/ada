--  @File : ringlist.adb
--
--  @Project : Programmieruebungen, Uebungsblatt 9
--  @Version : 1
--  @Created : 17. 12. 2011
--  @Author : Marcel Schneider, Ulrich Zendler, Philipp Klaas
-------------------------------------------------------------------------------
--
--
with Ada.Text_IO;
use Ada.Text_IO;
package body Ringlist is

   --  @Procedure: New_List
   --
   --  Initialisiert eine Liste.
   --
   --  @Parameter: 
   --   + L: Die Liste
   --  
   procedure New_List (L : out List) is
   begin
      L := new Anchor;
      L.First := null;
      L.Size := 0;
   end New_List;
   
   --  @Procedure: Insert 
   --
   --  Fuegt ein Element in eine Liste ein. Das Element wird so eingefuegt, 
   --  dass die El. der groesse nach geordnet sind.
   --
   --  @Parameter: 
   --   + L: Die Liste
   --   + E: Das neue Element
   --  
   procedure Insert (L : in List; E : in Element_Type) is
      Temp : Ref_Element;
      --  @Procedure: Insert_In_Order 
      --
      --  Geht rekursiv durch die Liste bis die Stlle zum Einsetzen gefunden 
      --  ist.
      --
      --  @Parameter: 
      --   + Element: Das Aktuelle Element
      --   + Count: Anzahl der noch folgenden Elemente
      --  
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
            Insert_In_Order (Element.Next, Count - 1);
         end if;
      end Insert_In_Order;
   begin
      if L = null then
         raise Empty_List_Error;
      end if;
      
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
      
      
   --  @Procedure: Clear 
   --
   --  Leert eine Liste
   --
   --  @Parameter: 
   --   + L: die zu leerende Liste
   --  
   procedure Clear (L : in List) is
   begin
      if L = null then
         raise Empty_List_Error;
      end if;
      L.First := null;
      L.Size := 0;
   end Clear;
   
   
   --  @Function: Contains 
   --
   --  Prueft, ob ein El. in einer Liste enthalten ist.
   --
   --  @Parameter: 
   --   + L: die Liste
   --   + E: das Gesuchte Elemnet
   --  
   --  @Return: True, wenn das El. gefunden wurde.
   --  
   function Contains (L : in List; E : in Element_Type) return Boolean is
      --  @Function: Find 
      --
      --  Prueft rekursiv die folgenden Elemente
      --
      --  @Parameter: 
      --   + Element: das Aktuelle Element
      --   + Count: die Anzahl noch folgender Elemente
      --  
      --  @Return: True, wenn das El. gefunden wurde.
      --  
      function Find (Element : Ref_Element; Count : Natural) return Boolean is
      begin
         if Element.Content = E then
            return True;
         end if;
         return Count > 0 and then Find (Element.Next, Count - 1);
      end Find;
   begin
      if L = null then
         raise Empty_List_Error;
      end if;
      return L.First /= null and then Find (L.First, L.Size);
   end Contains;
   
   
   --  @Function: Equals 
   --
   --  Vergleicht zwei Listen.
   --
   --  @Parameter: 
   --   + L1: die eine Liste
   --   + L2: die Andere Liste.
   --  
   --  @Return: True, wenn die Listen den selben Inhalt haben.
   --  
   function Equals (L1, L2 : in List) return Boolean is
      --  @Function: Compare 
      --
      --  vergleicht rekursiv die noch folgenden Elemente
      --
      --  @Parameter: 
      --   + Element_Left: das aktuelle El. der einen Liste
      --   + Element_Right: das aktuelle El. der anderen Liste
      --   + Count: die Anzahl noch folgender Elemente
      --  
      --  @Return: True, wenn die Listen ab dem aktuellen El. gleich sind.
      --  
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
      if L1 = null or L2 = null then
         raise Empty_List_Error;
      end if;
      if L1.Size /= L2.Size then
         return False;
      end if;
      return Compare (L1.First, L2.First, L1.Size);
   end Equals;
      
   --  @Function: Is_Empty 
   --
   --  Prueft, ob eine Liste Leer ist.
   --
   --  @Parameter: 
   --   + L: die Liste
   --  
   --  @Return: True, wenn die Liste 0 Elemente enthaelt.
   --  
   function Is_Empty (L : in List) return Boolean is 
   begin
      return L.First = null;
   end Is_Empty;
   
   
   --  @Procedure: Remove 
   --
   --  Entfernt das 1. El. das gleich dem gesuchten ist.
   --
   --  @Parameter: 
   --   + L: die Liste
   --   + E: das gesuchte Element
   --  
   procedure Remove (L : in List; E : in Element_Type) is
      --  @Procedure: Find_And_Remove 
      --
      --  Sucht rekursiv nach dem Element und entfert es.
      --
      --  @Parameter: 
      --   + Element: das Aktuelle Element der Liste
      --   + Count: die Anzahl noch folgender Elemente
      --  
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
      if L = null then
         raise Empty_List_Error;
      end if;
      if L.Size /= 0 then
         Find_And_Remove (L.First, L.Size);
         if L.Size = 0 then
            L.First := null;
         end if;
      end if;
   end Remove;

   --  @Procedure: Remove_All 
   --
   --  Entfernt alle Elmente aus der Liste, die gleich dem ges. Element sind.
   --
   --  @Parameter: 
   --   + L: die Liste
   --   + E: das gesuchte Element
   --  
   procedure Remove_All (L : in List; E : in Element_Type) is
      --  @Procedure: Find_And_Remove 
      --
      --  Sucht rekursiv nach dem Element und entfert es.
      --
      --  @Parameter: 
      --   + Element: das Aktuelle Element der Liste
      --   + Count: die Anzahl noch folgender Elemente
      --  
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
      if L = null then
         raise Empty_List_Error;
      end if;
      if L.Size /= 0 then
         Find_And_Remove (L.First, L.Size);
         if L.Size = 0 then
            L.First := null;
         end if;
      end if;
   end Remove_All;

   --  @Function: Size 
   --
   --  Gibt die Anzahl Elemente in der Lsite zurueck.
   --
   --  @Parameter: 
   --   + L: die Liste
   --  
   --  @Return: die Anzahl Elemente
   --  
   function Size (L : in List) return Natural is
   begin
      if L = null then
         raise Empty_List_Error;
      end if;
      return L.Size;
   end Size;
   
   --  @Procedure: Put 
   --
   --  Gibt den Inhalt der Liste aus.
   --
   --  @Parameter: 
   --   + L: die Liste
   --  
   procedure Put (L : in List) is
      Current : Ref_Element;
   begin
      if L = null then
         raise Empty_List_Error;
      end if;
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