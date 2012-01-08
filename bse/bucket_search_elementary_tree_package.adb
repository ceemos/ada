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

   function Find (T : in BSE_Tree; E : in Unbounded_String) return Boolean is
      --  Vermeidet den Key bei jeder Rek. zu berechnen
      Hash : Integer;
      
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
   
   procedure Insert (T : in out BSE_Tree; E : in Unbounded_String) is
      --  Vermeidet den Key bei jeder Rek. zu berechnen
      Hash : Integer;
      
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
   
   procedure Delete (T : in out BSE_Tree; E : in Unbounded_String) is
      --  Vermeidet den Key bei jeder Rek. zu berechnen
      Hash : Integer;
      
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
                  Put_Line ("TODO: Delete Node");
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
   
   procedure Clear (T : in out BSE_Tree) is
   begin
      null;
   end Clear;
   
   function Size (T : in BSE_Tree) return Natural is
   begin
      if T = null then
         return 0;
      else 
         return Size (T.Left) + Size (T.Contents) + Size (T.Right);
      end if;
   end Size;
   
   procedure Put (T : in BSE_Tree) is
   begin
      if T /= null then
         Put (T.Left);
         
         Put (T.Key'Img & ": ");
         Put (T.Contents);
         New_Line;
         
         Put (T.Right);
      end if;
   end Put;
   
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
   
   procedure Clear (L : in out Content_List) is
   begin
      null;
   end Clear;
   
   function Size (L : in Content_List) return Natural is
   begin
      if L = null then
         return 0; 
      else 
         return Size (L.Next) + L.Count;
      end if;
   end Size;
   
   procedure Put (L : in Content_List) is
   begin
      if L /= null then
         Put (L.Content);
         Put (":" & L.Count'Img & ", ");
         Put (L.Next);
      end if;
   end Put;
end Bucket_Search_Elementary_Tree_Package;


--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;