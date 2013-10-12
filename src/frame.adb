with Dessin; use Dessin;
with Ligne; use Ligne;
with STL ; use STL;
with Algebre ; use Algebre;

with Scene;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body Frame is

	procedure Calcul_Image is
		-- projected points
        Pts : array (1..3) of Vecteur(1..3);
		val : PixLum;
	begin
		-- for each Facette
        for faceIndex in 1..Scene.Nombre_De_Facettes loop
            Scene.Projection_Facette(faceIndex, Pts(1), Pts(2), Pts(3));

           	if Pts(1)(3) > 0.0 and then Pts(2)(3) > 0.0 and then Pts(3)(3) > 0.0 then 

				-- debug
				--for i in 1..3 loop
				--   Put(Pts(i)(1));Put(Pts(i)(2));Put(Pts(i)(3));New_Line;
				--end loop;

	            Ligne.Tracer_Segment_LumVar(P(1)(1), P(1)(2), 
											P(2)(1), P(2)(2), val);

            	--Ligne.Tracer_Segment(Pts(1)(1), Pts(1)(2), 
                --					 Pts(2)(1), Pts(2)(2));

            	Ligne.Tracer_Segment(Pts(2)(1), Pts(2)(2), 
					                 Pts(3)(1), Pts(3)(2));

            	Ligne.Tracer_Segment(Pts(3)(1), Pts(3)(2), 
					                 Pts(1)(1), Pts(1)(2));
           	end if;

        end loop;
	end;

end Frame;
