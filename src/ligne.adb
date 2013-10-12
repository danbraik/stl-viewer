with Dessin;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Ligne is

	Xmin : Integer := Dessin.Pixel_X'First;
	Xmax : Integer := Dessin.Pixel_X'Last;
	Ymin : Integer := Dessin.Pixel_Y'First;
    Ymax : Integer := Dessin.Pixel_Y'Last;
    
	-- Draw a pixel on screen
	-- Can be called with an invalid position
    procedure Trace_Pixel(X, Y : Integer) is
    begin
          Fixe_Pixel(X, Y, 255);
    end;

    procedure Fixe_Pixel(X, Y : Integer; Val : PixLum) is
    begin
       if X >= Xmin and then X <= Xmax and then Y >= Ymin and then Y <= Ymax then
          Dessin.Fixe_Pixel(X, Y, Val);
       end if; 
    end;


	--code entierement repris de wikipedia
	--https://fr.wikipedia.org/wiki/Algorithme_de_trac%C3%A9_de_segment_de_Bresenham#Algorithme_g.C3.A9n.C3.A9ral_optimis.C3.A9
	procedure Tracer_Segment(xa, ya, xb, yb : Float) is
	begin
		Tracer_Segment_LumVar(xa, ya, xb, yb, 255);
    end;	



















    procedure Tracer_Segment_LumVar(Xa, Ya, Xb, Yb : Float; Val : PixLum) is
		dx, dy : Integer;
		e : Integer;
		x1 : Integer; 
		y1 : Integer;
		x2 : Integer;
		y2 : Integer;
	begin
		-- prevent to draw very big lines
		if abs(Xb - Xa) > 800.0 or else abs(Yb - Ya) > 800.0 then
			return;
		end if;

		x1 := Integer(Float'Rounding(xa));
		y1 := Integer(Float'Rounding(ya));
		x2 := Integer(Float'Rounding(xb));
		y2 := Integer(Float'Rounding(yb));


		dx := x2 - x1;
		if dx /= 0 then
			if dx > 0 then
				dy := y2 - y1;
				if dy /= 0 then
					if dy > 0 then
						-- vecteur oblique dans le 1er quadran

						if dx >= dy then
							-- vecteur diagonal ou oblique proche de l’horizontale, dans le 1er octant
							e := dx;
							dx := e * 2 ; dy := dy * 2 ;  -- e est positif
							loop  -- déplacements horizontaux
								Fixe_Pixel(x1, y1, val) ;
								x1 := x1 + 1;
								exit when x1 = x2 ;
								e := e - dy;
								if e < 0 then
									y1 := y1 + 1 ;  -- déplacement diagonal
									e := e + dx ;
								end if;
							end loop ;
						else
							-- vecteur oblique proche de la verticale, dans le 2nd octant
							e := dy;
							dy := e * 2 ; dx := dx * 2 ;  -- e est positif
							loop  -- déplacements verticaux
								Fixe_Pixel(x1, y1, val) ;
								y1 := y1 + 1;
								exit when y1 = y2 ;
								e := e - dx;
								if e < 0 then
									x1 := x1 + 1 ;  -- déplacement diagonal
									e := e + dy ;
								end if;
							end loop ;
						end if;

					else  -- dy < 0 (et dx > 0)
						-- vecteur oblique dans le 4e cadran

						if dx >= -dy then
							-- vecteur diagonal ou oblique proche de l’horizontale, dans le 8e octant
							e := dx;
							dx := e * 2 ; dy := dy * 2 ;  -- e est positif
							loop  -- déplacements horizontaux
								Fixe_Pixel(x1, y1, val) ;
								x1 := x1 + 1;
								exit when x1 = x2 ;
								e := e + dy;
								if e < 0 then
									y1 := y1 - 1 ;  -- déplacement diagonal
									e := e + dx ;
								end if;
							end loop ;
						else  -- vecteur oblique proche de la verticale, dans le 7e octant
							e := dy;
							dy := e * 2 ; dx := dx * 2 ;  -- e est négatif
							loop  -- déplacements verticaux
								Fixe_Pixel(x1, y1, val) ;
								y1 := y1 - 1;
								exit when y1 = y2 ;
								e := e + dx;
								if e > 0 then
									x1 := x1 + 1 ;  -- déplacement diagonal
									e := e + dy ;
								end if;
							end loop ;
						end if;

					end if;
				else  -- dy = 0 (et dx > 0)

					-- vecteur horizontal vers la droite
					loop
						Fixe_Pixel(x1, y1, val) ;
						x1 := x1 + 1;
						exit when x1 = x2 ;
					end loop;

				end if;
			else  -- dx < 0
				dy := y2 - y1;
				if dy /= 0 then
					if dy > 0 then
						-- vecteur oblique dans le 2nd quadran

						if -dx >= dy then
							-- vecteur diagonal ou oblique proche de l’horizontale, dans le 4e octant
							e := dx;
							dx := e * 2 ; dy := dy * 2 ;  -- e est négatif
							loop  -- déplacements horizontaux
								Fixe_Pixel(x1, y1, val) ;
								x1 := x1 - 1;
								exit when x1 = x2 ;
								e := e + dy;
								if e >= 0 then
									y1 := y1 + 1 ;  -- déplacement diagonal
									e := e + dx ;
								end if;
							end loop ;
						else
							-- vecteur oblique proche de la verticale, dans le 3e octant
							e := dy;
							dy := e * 2 ; dx := dx * 2 ;  -- e est positif
							loop  -- déplacements verticaux
								Fixe_Pixel(x1, y1, val) ;
								y1 := y1 + 1;
								exit when y1 = y2 ;
								e := e + dx;
								if e <= 0 then
									x1 := x1 - 1 ;  -- déplacement diagonal
									e := e + dy ;
								end if;
							end loop ;
						end if;

					else  -- dy < 0 (et dx < 0)
						-- vecteur oblique dans le 3e cadran

						if dx <= dy then
							-- vecteur diagonal ou oblique proche de l’horizontale, dans le 5e octant
							e := dx;
							dx := e * 2 ; dy := dy * 2 ;  -- e est négatif
							loop  -- déplacements horizontaux
								Fixe_Pixel(x1, y1, val) ;
								x1 := x1 - 1;
								exit when x1 = x2 ;
								e := e - dy;
								if e >= 0 then
									y1 := y1 - 1 ;  -- déplacement diagonal
									e := e + dx ;
								end if;
							end loop ;
						else  -- vecteur oblique proche de la verticale, dans le 6e octant
							e := dy;
							dy := e * 2 ; dx := dx * 2 ;  -- e est négatif
							loop  -- déplacements verticaux
								Fixe_Pixel(x1, y1, val) ;
								y1 := y1 - 1;
								exit when y1 = y2 ;
								e := e - dx;
								if e >= 0 then
									x1 := x1 - 1 ;  -- déplacement diagonal
									e := e + dy ;
								end if;
							end loop ;
						end if;

					end if;
				else  -- dy = 0 (et dx < 0)

					-- vecteur horizontal vers la gauche
					loop
						Fixe_Pixel(x1, y1, val) ;
						x1 := x1 - 1;
						exit when x1 = x2 ;
					end loop;

				end if;
			end if;
		else  -- dx = 0
			dy := y2 - y1;
			if dy /= 0 then
				if dy > 0 then

					-- vecteur vertical croissant
					loop
						Fixe_Pixel(x1, y1, val) ;
						y1 := y1 + 1;
						exit when y1 = y2 ;
					end loop;

				else  -- dy < 0 (et dx = 0)

					-- vecteur vertical décroissant
					loop
						Fixe_Pixel(x1, y1, val) ;
						y1 := y1 - 1;
						exit when y1 = y2 ;
					end loop;

				end if;
			end if;
		end if;
		-- le pixel final (x2, y2) n’est pas tracé.
	end;
end;
