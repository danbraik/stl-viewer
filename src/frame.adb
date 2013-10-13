with Dessin; use Dessin;
with Ligne; use Ligne;
with STL ; use STL;
with Algebre ; use Algebre;

with Scene;
with Params;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

with ZBuffer;

package body Frame is

	procedure Calcul_Image is
		-- projected points (fourth is the normal)
        Pts : array (1..4) of Vecteur(1..3);
		val : PixLum;
		CamPos : Vecteur := Scene.Position_Camera;
		Tmp, Tmp2 : Vecteur(1..3);
		
	begin

		ZBuffer.Clear;

		-- for each Facette
        for faceIndex in 1..Scene.Nombre_De_Facettes loop
            Scene.Projection_Facette(faceIndex, Pts(1), Pts(2), Pts(3), Pts(4));

           	if Pts(1)(3) > 0.0 and then Pts(2)(3) > 0.0 and then Pts(3)(3) > 0.0 then 

				-- debug
				--for i in 1..3 loop
				--   Put(Pts(i)(1));Put(Pts(i)(2));Put(Pts(i)(3));New_Line;
				--end loop;

				if Params.EnableLighting then				
					--Tmp := (Pts(1));
					--normalize(Tmp);
					--Tmp2 :=  Pts(1) - Pts(4);
					--normalize(Tmp2);
					--val := PixLum( 255.0-  (length (Tmp2   * Tmp )) * 255.0 );
					val :=PixLum(255.0-exp(-Pts(1)(3)*0.102)*255.0);
				else
					val := 255;
				end if;

				Ligne.Tracer_Segment_LumVar_Z(Pts(1)(1), Pts(1)(2), Pts(1)(3),
											Pts(2)(1), Pts(2)(2), Pts(2)(3), val);
	            
				Ligne.Tracer_Segment_LumVar_Z(Pts(2)(1), Pts(2)(2),  Pts(2)(3),
											Pts(3)(1), Pts(3)(2), Pts(3)(3), val);

	            Ligne.Tracer_Segment_LumVar_Z(Pts(3)(1), Pts(3)(2), Pts(3)(3),
											Pts(1)(1), Pts(1)(2), Pts(1)(3), val);

				if Params.DisplayNormals then
            		Ligne.Tracer_Segment(Pts(1)(1), Pts(1)(2), 
                						 Pts(4)(1), Pts(4)(2));
				end if;

           	end if;

        end loop;
	end;

end Frame;
