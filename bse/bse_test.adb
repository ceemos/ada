--  @File: bse_test.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 11
--  @Version: 1
--  @Created: 08. 01. 2012
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: BSE_Test
--  Testet die Funktion der BSE-Trees


with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
with Bucket_Search_Elementary_Tree_Package;
use Bucket_Search_Elementary_Tree_Package;

procedure BSE_Test is

   type Tree_Op is access procedure (Tree : in out BSE_Tree;
                                     Element : in Unbounded_String);

   --  @Procedure: Read 
   --
   --  Liest eine Texdatei, zerlegt sie in Worte und ruft fuer jedes Wort 
   --  etwas auf.
   --
   --  @Parameter: 
   --   + File: der Name der zu lesenden Datei
   --   + Tree: Baum, der weitergegeben wird
   --   + Operation: Zeiger auf die aufzurufende Prozedur. Ihr wird das Wort 
   --       und der Baum uebergeben
   --  
   procedure Read (File : String; 
                   Tree : in out BSE_Tree; 
                   Operation : Tree_Op) is
      F : File_Type;
      Line : Unbounded_String;

      Current_Char : Character;
      Word : Unbounded_String;
   begin
      Open (F, In_File, File);
      while not End_Of_File (F) loop
         Line := Get_Line (F);
         for I in 1 .. Length (Line) loop
            Current_Char := Element (Line, I);
            --  Leer, CR und LF
            if Current_Char = ' ' or Character'Pos (Current_Char) = 10 or
               Character'Pos (Current_Char) = 13 then
               Operation (Tree, Word);
               Word := To_Unbounded_String ("");
            else
               Append (Word, Current_Char);
            end if;
         end loop;
         Operation (Tree, Word);
         Word := To_Unbounded_String ("");
      end loop;
   end Read;
   
   --  @Procedure: Put_If_In_Tree 
   --
   --  Gibt ein Wort aus, wenn es im Baum gefunden wurde.
   --
   --  @Parameter: 
   --   + Tree: Der Baum
   --   + Element: das Wort
   --  
   procedure Put_If_In_Tree (Tree : in out BSE_Tree;
                              Element : in Unbounded_String) is
   begin
      if Find (Tree, Element) then
         Put_Line (Element);
      end if;
   end Put_If_In_Tree;
   
begin
   declare
      Tree : BSE_Tree;
      
      Groesse : Natural;

   begin
      Read ("BSE_Insert.txt", Tree, Insert'Access);
      Groesse := Size (Tree);
      Put_Line ("Groesse nach Einfuegen: " & Groesse'Img);
      Put (Tree);
      
      Read ("BSE_Delete.txt", Tree, Delete'Access);
      Groesse := Size (Tree);
      Put_Line ("Groesse nach Entfernen: " & Groesse'Img);
      Put (Tree);
      
      Read ("BSE_Find.txt", Tree, Put_If_In_Tree'Access);

      
      Clear (Tree);
      Groesse := Size (Tree);
      Put_Line ("Groesse nach Leeren: " & Groesse'Img);   
      Put (Tree);
   end;
end BSE_Test;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;