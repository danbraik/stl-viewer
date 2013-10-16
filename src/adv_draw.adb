with ZBuffer; use ZBuffer;
with Algebre; use Algebre;
with Params; use Params;

package body Adv_Draw is

	XMIN : constant Integer := (Dessin.Pixel_X'First);
    XMAX : constant Integer := (Dessin.Pixel_X'Last);
	YMIN : constant Integer := (Dessin.Pixel_Y'First);
	YMAX : constant Integer := (Dessin.Pixel_Y'Last);


	-- Compute an intermediate result
	function Plop(A, B : Vecteur ; x, y : Float) return Float is
	begin
		return (A(2) - B(2))*x + (B(1) - A(1))*y + A(1)*B(2) - B(1)*A(2);
	end;

	-- see the algo at
	-- http://courses.cms.caltech.edu/cs171/barycentric.pdf
	procedure DrawFilledTriangle(A, B, C : Vecteur ; Val : PixLum) is
		xmi, xma, ymi, yma : Integer;
		l1, l2, l3, xx, yy : Float;
		t1, t2, t3 : Float;
		-- compute and store viewport screen limits
	begin
		-- compute bounding box
		if A(1) > B(1) then         -- B < A
			if A(1) > C(1) then     	-- B,C < A
				xma := Integer(Float'Rounding(A(1)));
				if B(1) > C(1) then 		-- C < B < A
					xmi := Integer(Float'Rounding(C(1)));
				else                		-- B < C < A
					xmi := Integer(Float'Rounding(B(1)));
				end if;
			else						-- B < A < C
				xma := Integer(Float'Rounding(C(1)));
				xmi := Integer(Float'Rounding(B(1)));
			end if;
		else						-- A < B
			if B(1) > C(1) then			-- A,C < B
				xma := Integer(Float'Rounding(B(1)));
				if A(1) > C(1) then			-- C < A < B
					xmi := Integer(Float'Rounding(C(1)));
				else						-- A < C < B
					xmi := Integer(Float'Rounding(A(1)));
				end if;
			else						-- A < B < C
				xmi := Integer(Float'Rounding(A(1)));
				xma := Integer(Float'Rounding(C(1)));
			end if;
		end if;

		if A(2) > B(2) then         -- B < A
			if A(2) > C(2) then     	-- B,C < A
				yma := Integer(Float'Rounding(A(2)));
				if B(2) > C(2) then 		-- C < B < A
					ymi := Integer(Float'Rounding(C(2)));
				else                		-- B < C < A
					ymi := Integer(Float'Rounding(B(2)));
				end if;
			else						-- B < A < C
				yma := Integer(Float'Rounding(C(2)));
				ymi := Integer(Float'Rounding(B(2)));
			end if;
		else						-- A < B
			if B(2) > C(2) then			-- A,C < B
				yma := Integer(Float'Rounding(B(2)));
				if A(2) > C(2) then			-- C < A < B
					ymi := Integer(Float'Rounding(C(2)));
				else						-- A < C < B
					ymi := Integer(Float'Rounding(A(2)));
				end if;
			else						-- A < B < C
				ymi := Integer(Float'Rounding(A(2)));
				yma := Integer(Float'Rounding(C(2)));
			end if;
		end if;


			-- clip bounding box with canvas size
			if xmi < XMAX then
				xmi := XMIN;
			end if;
			if xma > XMAX then
				xma := XMAX;
			end if;
			if ymi < YMIN then
				ymi := YMIN;
			end if;
			if yma > YMAX then
				yma := YMAX;
			end if;

		-- if the bounding box is actually out of screen
		-- stop the algo
		if xma < xmi or else yma < ymi then
			return;
		end if;
		
		-- pre-compute denominators
		-- if they are nul, so the triangle is degenarate
		t1 := Plop(B,C,A(1), A(2));
		if t1 = 0.0 then
			return;
		end if;
		t2 := Plop(C,A,B(1), B(2));
		if t2 = 0.0 then
			return;
		end if;
		t3 := Plop(A,B,C(1), C(2));
		if t2 = 0.0 then
			return;
		end if;

		-- loop on each pixel into the bounding box
		for x in xmi..xma loop
			for y in ymi..yma loop
				xx := Float(x);
				yy := Float(y);

				-- compute barycentric coefficients
				l1 := Plop(B,C, xx, yy) / t1; 
				l2 := Plop(C,A, xx, yy) / t2;
				l3 := Plop(A,B, xx, yy) / t3;

				-- Test if the pixel is inside the triangle
				if 0.0 <= l1 and then l1 <= 1.0 and then
					0.0 <= l2 and then l2 <= 1.0 and then
					0.0 <= l3 and then l3 <= 1.0 then
					-- interpolate the Z-depth and draw the pixel
					DrawPixel(X, Y, l1*A(3)+l2*B(3)+l3*C(3), Val);
				end if;
			end loop;
		end loop;

	end;

end;
