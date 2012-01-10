--  @File: bucket_search_elementary_tree_package.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 11
--  @Version: 1
--  @Created: 08. 01. 2012
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--  Compile: gnatmake -gnaty3acefhiklmnrpt bse_test.adb
--  Run: ./bse_test


with Ada.Strings.Unbounded, Ada.Unchecked_Deallocation;
use Ada.Strings.Unbounded;

with Hash_Package;
use Hash_Package;

with Ada.Text_IO, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded.Text_IO;

package body Bucket_Search_Elementary_Tree_Package is

   --  @Function: Find
   --
   --  sucht im Baum nach einem Element
   --
   --  @Parameter: 
   --   + T: Der Baum
   --   + E: Das Element
   --  
   --  @Return: true, wenn das Element enthalten ist, sonst false.
   --  

   function Find (T : in BSE_Tree; E : in Unbounded_String) return Boolean is
      --  Vermeidet den Key bei jeder Rek. zu berechnen
      Hash : Integer;
      
      --  @Function: Find_Recursive 
      --
      --  Sucht nach dem Hash-Wert des Elements
      --
      --  @Parameter: 
      --   + Tree: Der Baum
      --  
      --  @Return: true wenn das Element enthalten ist.
      --  
      function Find_Recursive (Tree : BSE_Tree) return Boolean is
      begin
         if Tree = null then
            return False;
         else
            if Hash < Tree.Key then
               return Find_Recursive (Tree.Left);
            elsif Hash = Tree.Key then
               return Find (Tree.Contents, E);
            else 
               return Find_Recursive (Tree.Right);
            end if;
         end if;
      end Find_Recursive;
      
   begin
      Hash := Hash_Key (E);
      return Find_Recursive (T);
   exception
      when Empty_String_Error =>
         --  Leere Strings schweigend ignorieren
         return False;
   end Find;
   
   --  @Procedure: Insert 
   --
   --  Fuegt ein Element in den Baum ein.
   --
   --  @Parameter: 
   --   + T: der Baum
   --   + E: das neue Element
   --  
   procedure Insert (T : in out BSE_Tree; E : in Unbounded_String) is
      --  Vermeidet den Key bei jeder Rek. zu berechnen
      Hash : Integer;
      
      --  @Procedure: Insert_Recursive 
      --
      --  Fuegt ein Element mit bekanntem Hash ein.
      --
      --  @Parameter: 
      --   + Tree: der Baum
      --  
      procedure Insert_Recursive (Tree : in out BSE_Tree) is
      begin
         if Tree = null then
            Tree := new BSE_Element'
                        (Hash, null, null, null);
            Insert (Tree.Contents, E);
         else
            if Hash < Tree.Key then
               Insert_Recursive (Tree.Left);
            elsif Hash = Tree.Key then
               Insert (Tree.Contents, E);
            else 
               Insert_Recursive (Tree.Right);
            end if;
         end if;
      end Insert_Recursive;
      
   begin
      Hash := Hash_Key (E);
      Insert_Recursive (T);
     
   exception
      when Empty_String_Error =>
         --  Leere Strings schweigend ignorieren
         null;
   end Insert;
   
   --  @Procedure: Delete 
   --
   --  Sucht ein Element und entfernt es, falls vorhanden, aus dem Baum. Wenn 
   --  das Element mehrfach eingefuegt wurde, wird die Menge um eins Reduziert. 
   --
   --  @Parameter: 
   --   + T: der Baum
   --   + E: das Element
   --  
   procedure Delete (T : in out BSE_Tree; E : in Unbounded_String) is
      --  Vermeidet den Key bei jeder Rek. zu berechnen
      Hash : Integer;
      
      --  @Procedure: Delete_Recursive 
      --
      --  Entfernt ein Element mit bekanntem Hash.
      --
      --  @Parameter: 
      --   + Tree: der Baum
      --  
      procedure Delete_Recursive (Tree : in out BSE_Tree) is
      begin
         if Tree = null then
            null;
         else
            if Hash < Tree.Key then
               Delete_Recursive (Tree.Left);
            elsif Hash = Tree.Key then
               Delete (Tree.Contents, E);
               if Tree.Contents = null then
                  declare
                     Left, Right : BSE_Tree;
                  begin
                     Left := Tree.Left;
                     Right := Tree.Right;
                     Free (Tree);
                     --  den Baum Reparieren: den linken Teil hochziehen und 
                     --  den Rechten ganz rechts in den Linken haengen
                     if Left = null then
                        Tree := Right;
                     else
                        Tree := Left;
                        while Left.Right /= null loop
                           Left := Left.Right;
                        end loop;
                        Left.Right := Right;
                     end if;
                  end;
               end if;
            else 
               Delete_Recursive (Tree.Right);
            end if;
         end if;
      end Delete_Recursive;
      
   begin
      Hash := Hash_Key (E);
      Delete_Recursive (T);
     
   exception
      when Empty_String_Error =>
         --  Leere Strings schweigend ignorieren
         null;
   end Delete;
   
   --  @Procedure: Clear 
   --
   --  Loescht alle Elemente des Baumes.
   --
   --  @Parameter: 
   --   + T: der Baum.
   --  
   procedure Clear (T : in out BSE_Tree) is
   begin
      if T /= null then
         Clear (T.Left);
         Clear (T.Right);
         Free (T);
         T := null;
      end if;
   end Clear;
   
   --  @Function: Size 
   --
   --  Ermittelt die Anzahl verschiedener Elemente im Baum
   --
   --  @Parameter: 
   --   + T: der Baum
   --  
   --  @Return: die Anzahl
   --  
   function Size (T : in BSE_Tree) return Natural is
   begin
      if T = null then
         return 0;
      else 
         return Size (T.Left) + Size (T.Contents) + Size (T.Right);
      end if;
   end Size;
   
   --  @Procedure: Put 
   --
   --  gibt den Inhalt des Baumes mit den Zugehörigen Hashwerten aus.
   --
   --  @Parameter: 
   --   + T: der Baum
   --  
   procedure Put (T : in BSE_Tree) is
   begin
      if T /= null then
         Put (T.Left);
         
         --  Put (T.Key'Img & ": ");
         Put (T.Contents);
         
         Put (T.Right);
      end if;
   end Put;
   
   --  @Function: Find 
   --
   --  FSucht ein El. in einer Wortliste.
   --
   --  @Parameter: 
   --   + L: die Liste
   --   + C: das Wort
   --  
   --  @Return: true, wenn das Wort enthalten ist.
   --  
   function Find (L : in Content_List; C : Unbounded_String) return Boolean is
   begin
      if L = null then
         return False;
      elsif L.Content = C then
         return True;
      else
         return Find (L.Next, C);
      end if; 
   end Find;
   
   --  @Procedure: Insert 
   --
   --  Fuegt ein Wort in eine Wortliste ein.
   --
   --  @Parameter: 
   --   + L: die Liste
   --   + C: das Wort
   --  
   procedure Insert (L : in out Content_List; C : Unbounded_String) is
   begin
      if L = null then
         L := new Content_Element'(C, 1, null);
      elsif L.Content = C then
         L.Count := L.Count + 1;
      else
         Insert (L.Next, C);
      end if; 
   end Insert;
   
   --  @Procedure: Delete 
   --
   --  Entfernt ein Wort aus einer Wortliste.
   --
   --  @Parameter: 
   --   + L: die Liste
   --   + C: das Wort.
   --  
   procedure Delete (L : in out Content_List; C : Unbounded_String) is
   begin
      if L /= null then
         if L.Content = C then
            L.Count := L.Count - 1;
            if L.Count = 0 then
               declare 
                  Next : Content_List := L.Next;
               begin
                  Free (L);
                  L := Next;
               end;
            end if;
         else
            Delete (L.Next, C);
         end if;
      end if;              
   end Delete;
   
   --  @Procedure: Clear 
   --
   --  Entfernt alle Elemnete aus einer Liste.
   --
   --  @Parameter: 
   --   + L: die Liste
   --  
   procedure Clear (L : in out Content_List) is
   begin
      if L /= null then
         Clear (L.Next);
         Free (L);
         L := null;
      end if;
   end Clear;
   
   --  @Function: Size 
   --
   --  Ermittelt die Anzahl verschiedener Elemente in einer Wortliste.
   --
   --  @Parameter: 
   --   + L: die Liste
   --  
   --  @Return: die Anzahl
   --  
   function Size (L : in Content_List) return Natural is
   begin
      if L = null then
         return 0; 
      else 
         return Size (L.Next) + 1;
      end if;
   end Size;
   
   --  @Procedure: Put 
   --
   --  Gibt die Woerter einer Liste mit den zugehoerigen Hashes aus,
   --
   --  @Parameter: 
   --   + L: die Liste
   --  
   procedure Put (L : in Content_List) is
   begin
      if L /= null then
         Put (Hash_Key (L.Content)'Img & ": ");
         Put (L.Content);
         Put_Line (" *" & L.Count'Img & ", ");
         Put (L.Next);
      end if;
   end Put;
end Bucket_Search_Elementary_Tree_Package;


--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;