with Stl;
use Stl;
with Ada.Text_IO;
use Ada.Text_IO;
with Algebre;
use Algebre;
with Ada.Command_line; use Ada.Command_Line;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;


procedure Test_stl is
	m : Maillage;
	f : Facette;
begin
	
	m := Chargement(Argument(1));
    
	Put("Nb face : ");Put(m'Length);
	New_Line;

	for I in m'Range loop
		f := m(I);
		New_Line;
		Put("Face n°");Put(I);
		New_Line;
		for J in 1..3 loop
			Put(f.P1(J));
		end loop;
		New_Line;
		for J in 1..3 loop
			Put(f.P2(J));
		end loop;
		New_Line;
		for J in 1..3 loop
			Put(f.P3(J));
		end loop;
	end loop;
end;

