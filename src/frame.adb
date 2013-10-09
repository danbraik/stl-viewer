with Dessin; use Dessin;
with Ligne; use Ligne;
with STL ; use STL;
with Algebre ; use Algebre;
with SDL.Types; use SDL.Types;

with Scene;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Frame is


	procedure Calcul_Image(i : Integer) is
	begin
		-- a faire : calcul des projections, affichage des triangles
		null;
		Put(i); New_Line;	
		for J in 1..(i mod 600) loop
			Fixe_Pixel(J,J, Uint8(i mod 256));
		end loop;
	end;

end Frame;
