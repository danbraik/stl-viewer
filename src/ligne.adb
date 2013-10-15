with ZBuffer; use ZBuffer;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body Ligne is

    Xmin : constant Integer := Dessin.Pixel_X'First;
    Xmax : constant Integer := Dessin.Pixel_X'Last;
    Ymin : constant Integer := Dessin.Pixel_Y'First;
    Ymax : constant Integer := Dessin.Pixel_Y'Last;


	--code entierement repris de wikipedia
	--https://fr.wikipedia.org/wiki/Algorithme_de_trac%C3%A9_de_segment_de_Bresenham#Algorithme_g.C3.A9n.C3.A9ral_optimis.C3.A9
	procedure Tracer_Segment(xa, ya, xb, yb : Float) is
	begin
        Tracer_Segment_LumVar_Z(xa, ya, 0.0, xb, yb, 0.0, 255);
    end;	


    procedure Tracer_Segment_LumVar(Xa, Ya, Xb, Yb : Float; Val : PixLum) is
    begin
        Tracer_Segment_LumVar_Z(xa, ya, 0.0, xb, yb, 0.0, Val);
    end;



    procedure Tracer_Segment_LumVar_Z(Xa, Ya, Za, Xb, Yb, Zb : Float; Val : PixLum) is
		dx, dy : Integer;
		dz : Float;
		e : Integer;
		x1 : Integer; 
		y1 : Integer;
		x2 : Integer;
		y2 : Integer;
		z1 : Float := Za;
		z2 : Float := Zb;
		len : Float; 
    begin



        
-- maybe constraint erro?	
        begin
		x1 := Integer(Float'Rounding(xa));
		y1 := Integer(Float'Rounding(ya));
		x2 := Integer(Float'Rounding(xb));
		y2 := Integer(Float'Rounding(yb));
    exception
        when others =>
            return;
    end;


        if x1 = x2 then
            if y1 > y2 then
                e := y1;
                y1 := y2;
                y2 := e;
            end if;

            if y1 < YMIN then
                if y2 < YMIN then
                    return;
                else
                    y1 := YMIN;
                end if;
            elsif y1 > YMAX then
                return;
            end if;
            if y2 > YMAX then
                if y1 > YMAX then
                    return;
                else
                    y2 := YMAX;
                end if;
                -- the case where x2 < XMIN
                -- can't be reach
            end if;

        elsif y1 = y2 then
            if x1 > x2 then
                e := x1;
                x1 := x2;
                x2 := e;
            end if;

            if x1 < XMIN then
                if x2 < XMIN then
                    return;
                else
                    x1 := XMIN;
                end if;
            elsif x1 > XMAX then
                return;
            end if;
            if x2 > XMAX then
                if x1 > XMAX then
                    return;
                else
                    x2 := XMAX;
                end if;
                -- the case where x2 < XMIN
                -- can't be reach
            end if;

        else




            if x1 > x2 then
                e := x1;
                x1 := x2;
                x2 := e;
                e := y1;
                y1 := y2;
                y2 := e;
            end if;


            if x1 < XMIN then
                if x2 < XMIN then
                    return;
                else
                    x1 := XMIN;
                    y1 := 300; --**
                end if;
            end if;
            if x2 > XMAX then
                if x1 > XMAX then
                    return;
                else
                    x2 := XMAX;
                    y2 := 300; --**
                end if;
            end if;

            if y1 < y2 then
                if y1 < YMIN then
                    if y2 < YMIN then
                        return;
                    else
                        y1 := YMIN;
                        x1 := 400; --**
                    end if;
                end if;
                if y2 > YMAX then
                    if y1 > YMAX then
                        return;
                    else
                        y2 := YMAX;
                        x2 := 400; --**
                    end if;
                end if;
            else
                if y2 < YMIN then
                    if y1 < YMIN then
                        return;
                    else
                        y2 := YMIN;
                        x2 := 400; --**
                    end if;
                end if;
                if y1 > YMAX then
                    if y2 > YMAX then
                        return;
                    else
                        y1 := YMAX;
                        x1 := 400; --**
                    end if;
                end if;
            end if;

        end if;

            Put(x1);Put(y1);Put(x2);Put(y2);New_Line;


        -- compute line length on screen
        -- in order to have the delta depth
        -- between each pixel
		len := sqrt((xa-xb)**2+(ya-yb)**2);

		dx := x2 - x1;
		if dx /= 0 then
			if dx > 0 then
				dy := y2 - y1;
				dz := (z2 - z1) / len;

				if dy /= 0 then
					if dy > 0 then
						-- vecteur oblique dans le 1er quadran

						if dx >= dy then
							-- vecteur diagonal ou oblique proche de l’horizontale, dans le 1er octant
							e := dx;
							dx := e * 2 ; dy := dy * 2 ;  -- e est positif
							loop  -- déplacements horizontaux
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
						DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
						x1 := x1 + 1;
						exit when x1 = x2 ;
					end loop;

				end if;
			else  -- dx < 0
				dy := y2 - y1;
				dz := z2 - z1;
				if dy /= 0 then
					if dy > 0 then
						-- vecteur oblique dans le 2nd quadran

						if -dx >= dy then
							-- vecteur diagonal ou oblique proche de l’horizontale, dans le 4e octant
							e := dx;
							dx := e * 2 ; dy := dy * 2 ;  -- e est négatif
							loop  -- déplacements horizontaux
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
								DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
						DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
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
						DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
						y1 := y1 + 1;
						exit when y1 = y2 ;
					end loop;

				else  -- dy < 0 (et dx = 0)

					-- vecteur vertical décroissant
					loop
						DrawPixel(x1, y1, z1, val) ;
								z1 := z1 + dz;
						y1 := y1 - 1;
						exit when y1 = y2 ;
					end loop;

				end if;
			end if;
		end if;
		-- le pixel final (x2, y2) n’est pas tracé.
	end;


end;
