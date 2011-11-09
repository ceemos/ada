with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure Was_Macht_Das is
type Integer_Array is array (Natural range <>) of Integer;
procedure Put (
To_Put : Integer_Array) is
begin
for I in To_Put'range loop
Ada.Integer_Text_IO.Put (To_Put(I), 0);
if (I < To_Put'Last) then
Ada.Text_IO.Put (" # ");
end if;
end loop;
end Put;
procedure Read (
A : in out Integer_Array) is
begin
for I in A'First .. A'Last loop
Ada.Text_IO.Put ("Bitte geben Sie den " & Integer'Image (I + 1) & ". Wert ein: ");
Ada.Integer_Text_IO.Get (A (I));
end loop;
end Read;
procedure Shake_It (
A : in out Integer_Array) is
Weiter : Boolean := True;
Links, Rechts, Ende : Natural;
begin
Links := 1;
Rechts := A'Length - 1;
Ende := Rechts;
while Weiter loop
Weiter := False;
for I in reverse Links .. Rechts loop
if (A (I) < A (I - 1)) then
Weiter := True;
Ende := I;
A (I) := A (I - 1) + A (I);
A (I - 1) := A (I) - A (I - 1);
A (I) := A (I) - A (I - 1);
end if;
end loop;
Links := Ende + 1;
for I in Links .. Rechts loop
if (A (I) < A (I - 1)) then
Weiter := True;
Ende := I;
A (I) := A (I - 1) + A (I);
A (I - 1) := A (I) - A (I - 1);
A (I) := A (I) - A (I - 1);
end if;
end loop;
Rechts := Ende - 1;
end loop;
end Shake_It;
Grenze : Natural;
begin
Ada.Text_IO.Put ("Geben Sie die Grenzen ein: ");
Ada.Integer_Text_IO.Get (Grenze);
declare
My_Array : Integer_Array (0 .. Grenze - 1) := (others => Integer'Last);
begin
Read (My_Array);
Shake_It (My_Array);
Put (My_Array);
end;
end Was_Macht_Das;
