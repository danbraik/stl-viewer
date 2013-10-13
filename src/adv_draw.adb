with ZBuffer; use ZBuffer;
with Algebre; use Algebre;

package body Adv_Draw is


	function plop(A, B : Vecteur ; x, y : Float) return Float is
	begin
		return (A(2) - B(2))*x + (B(1) - A(1))*y + A(1)*B(2) - B(1)*A(2);
	end;

	-- http://courses.cms.caltech.edu/cs171/barycentric.pdf
	procedure DrawFilledTriangle(A, B, C : Vecteur ; Val : PixLum) is
		xmi, xma, ymi, yma : Integer;
		l1, l2, l3, xx, yy, tmp : Float;
		t1, t2, t3 : Float;
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
--.
		if xmi < Pixel_X'First then
			xmi := Pixel_X'First;
		end if;
		if xma > Pixel_X'Last then
			xma := Pixel_X'Last;
		end if;
		if ymi < Pixel_Y'First then
			ymi := Pixel_Y'First;
		end if;
		if yma > Pixel_Y'Last then
			yma := Pixel_Y'Last;
		end if;

		if xma = xmi or else yma = ymi then
			return;
		end if;

		t1 := plop(B,C,A(1), A(2));
		if t1 = 0.0 then
			return;
		end if;
		t2 := plop(C,A,B(1), B(2));
		if t2 = 0.0 then
			return;
		end if;
		t3 := plop(A,B,C(1), C(2));
		if t2 = 0.0 then
			return;
		end if;

		for x in xmi..xma loop
			for y in ymi..yma loop
				xx := Float(x);
				yy := Float(y);

				
				l1 := plop(B,C, xx, yy) / t1; 
				l2 := plop(C,A, xx, yy) / t2;
				l3 := plop(A,B, xx, yy) / t3;


				if 0.0 <= l1 and l1 <= 1.0 and 0.0 <= l2 and l2 <= 1.0 and 0.0 <= l3 and l3 <= 1.0 then
				--if True then
					--DrawPixel(X, Y, (A(3)+B(3)+C(3))/3.0, Val);
					DrawPixel(X, Y, Val);
				end if;

			end loop;
		end loop;


	end;

end;
