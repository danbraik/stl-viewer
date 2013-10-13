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

with ZBuffer; use ZBuffer;
with Adv_Draw; use Adv_Draw;

package body Frame is

	procedure Calcul_Image is
		-- projected points (fourth is the normal)
        Pts : array (1..4) of Vecteur(1..3);
		val : PixLum;
		CamPos : Vecteur := Scene.Position_Camera;
		Tmp, Tmp2 : Vecteur(1..3);
		
	begin

		-- Reset the buffer to draw a new frame
		ZBuffer.Clear;

		-- For each Facette
        for faceIndex in 1..Scene.Nombre_De_Facettes loop
            Scene.Projection_Facette(faceIndex, Pts(1), Pts(2), Pts(3), Pts(4));

			-- Test if the face is enterly in front of camera
           	if Pts(1)(3) > 0.0 and then 
				Pts(2)(3) > 0.0 and then 
				Pts(3)(3) > 0.0 then 

				-- debug
				--for i in 1..3 loop
				--   Put(Pts(i)(1));Put(Pts(i)(2));Put(Pts(i)(3));New_Line;
				--end loop;

				-- Compute the face luminance
				if Params.EnableLighting then				
					case Params.LightingMode is
						when 0 =>
							Tmp := (Pts(1) +Pts(2) +Pts(3));
							
							val := PixLum(Integer(Cos(Tmp(3))*16.0+32.0) mod 224);
						when 1 =>
							-- inspired by OpenGL : 1 / (a+bx+cx²)
							val := PixLum(255.0 / 
								(Pts(1)(3)*Pts(1)(3)*0.02 + Pts(1)(3)*0.1 + 1.0	));
						when 2 =>
							Tmp := (Pts(1) );
							normalize(Tmp);
							Tmp2 :=  Pts(1) - Pts(4);
							normalize(Tmp2);
							val := PixLum(
								exp(-( (length (Tmp2   * Tmp )*2.0) )) * 255.0 );
						when others => null;
					end case;
				else
					val := 255;
				end if;


				-- Draw the triangle (Fill or Wire mode)
				if Params.FillTriangles then
					DrawFilledTriangle(Pts(1), Pts(2), Pts(3), val);
				else
					Ligne.Tracer_Segment_LumVar_Z(Pts(1)(1), Pts(1)(2), Pts(1)(3),
											Pts(2)(1), Pts(2)(2), Pts(2)(3), val);
	            
					Ligne.Tracer_Segment_LumVar_Z(Pts(2)(1), Pts(2)(2),  Pts(2)(3),
											Pts(3)(1), Pts(3)(2), Pts(3)(3), val);

	            	Ligne.Tracer_Segment_LumVar_Z(Pts(3)(1), Pts(3)(2), Pts(3)(3),
											Pts(1)(1), Pts(1)(2), Pts(1)(3), val);
				end if;

				-- Draw the face normal (from the first vertex)
				if Params.DisplayNormals then
            		Ligne.Tracer_Segment_LumVar_Z(Pts(1)(1), Pts(1)(2), Pts(1)(3), 
                						          Pts(4)(1), Pts(4)(2), Pts(4)(3), 228);
				end if;

           	end if;

        end loop;
	end;

end Frame;
