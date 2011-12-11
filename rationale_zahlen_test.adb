--  @File: rationale_zahlen_test.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 1
--  @Version: 1
--  @Created: 11. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Rationale_Zahlen_Test
--

with Ada.Text_IO;
use Ada.Text_IO;
with Rationale_Zahlen;
use Rationale_Zahlen;
procedure Rationale_Zahlen_Test is
   rz : Rationale_Zahl;
   a, b, c, d : Rationale_Zahl;
begin
   Put_Line ("GGT" & GGT (30, 20)'Img);
--    Rationale_Zahlen.Get (rz);
--    Rationale_Zahlen.Put (rz);
   Set (a, -15, 30);
   Set (b, 8, 42);
   Put (a);
   Put (b);
   New_Line;
   Set (c, a * b);
   Set (d, a / b);
   Put (c);
   Put (d);
   New_Line;
   Put (b * (7 / 15));
   New_Line;
   Put (a - b);
   Put (a + b);
   Put (a * (-b));
   New_Line;
   if a > b then
      Put_Line ("a groesser b");
   elsif a < b then
      Put_Line ("b groesser a");
   end if;
   if a = -1 / 2 then
      Put_Line ("a ist minuseinhalb");
   end if;
   
end Rationale_Zahlen_Test;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;