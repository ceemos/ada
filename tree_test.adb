--  @File: tree_test.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 12
--  @Version: 1
--  @Created: 15. 01. 2012
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Tree_Test
--


with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;

with Tree_Package;

                
procedure Tree_Test is
   package String_Tree_Package is new Tree_Package 
               (Content_Type => Unbounded_String,
                Put => Ada.Strings.Unbounded.Text_IO.Put);
                
   use String_Tree_Package;

   Baum : Edge;
   Klon : Edge;
   Kopi : Edge;
begin
   Put_Line ("Inserting Elements..."); 
   Insert (Baum, To_Unbounded_String ("Hallo"));
   Insert (Baum, To_Unbounded_String ("Welt"));
   Insert (Baum, To_Unbounded_String ("!"));
   Insert (Baum, To_Unbounded_String ("einself"));
   Insert (Baum, To_Unbounded_String ("Hallo"));
   Insert (Baum, To_Unbounded_String ("Welt"));
   Insert (Baum, To_Unbounded_String ("!!!"));
   Insert (Baum, To_Unbounded_String ("einself")); 
   Insert (Baum, To_Unbounded_String ("Hallo"));
   Insert (Baum, To_Unbounded_String ("World"));
   Insert (Baum, To_Unbounded_String ("!!"));
   Insert (Baum, To_Unbounded_String ("eins11"));    
   Put_Line ("Put Tree:");
   Put (Baum);
   New_Line;
   Put_Line ("Size (12):");
   Put_Line (Size (Baum)'Img);
   Put_Line ("Finding Stuff...");
   Put_Line ("Hallo (3):" & Find (Baum, To_Unbounded_String ("Hallo"))'Img);
   Put_Line ("Welt  (2):" & Find (Baum, To_Unbounded_String ("Welt"))'Img);
   Put_Line ("!     (1):" & Find (Baum, To_Unbounded_String ("!"))'Img);
   Put_Line ("test  (0):" & Find (Baum, To_Unbounded_String ("test"))'Img);
   Put_Line ("Cloneing...");
   Clone (Baum, Klon);
   Put_Line ("Put Klon:");
   Put (Klon);
   New_Line;
   Put_Line ("Klon equals Baum  (TRUE): " & Equal (Klon, Baum)'Img);
   Put_Line ("Klon similar Baum (TRUE): " & Similar (Klon, Baum)'Img);
   Put_Line ("Copying...");
   Copy (Baum, Kopi);
   Put_Line ("Put Kopi:");
   Put (Kopi);
   New_Line;
   Put_Line ("Kopi equals Baum  (FALSE): " & Equal (Kopi, Baum)'Img);
   Put_Line ("Kopi similar Baum  (TRUE): " & Similar (Kopi, Baum)'Img);
end Tree_Test;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;