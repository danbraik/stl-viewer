
package body ZBuffer is
	Xmin : Integer := Dessin.Pixel_X'First;
	Xmax : Integer := Dessin.Pixel_X'Last;
	Ymin : Integer := Dessin.Pixel_Y'First;
    Ymax : Integer := Dessin.Pixel_Y'Last;
	
	buffer : array (Xmin..Xmax, Ymin..Ymax) of Float;


	-- Draw a pixel on screen
	-- Can be called with an invalid position
	procedure DrawPixel(X, Y : Integer ; V : PixLum) is
	begin
		if X >= Xmin and then X <= Xmax and then Y >= Ymin and then Y <= Ymax then
			Dessin.Fixe_Pixel(X, Y, V);
		end if;
	end;

	-- Draw a pixel on screen (does not occlude nearest pixel)
	-- Can be called with an invalid position
	procedure DrawPixel(X, Y : Integer ; Z : Float ; V : PixLum) is
		D : Float := Z;
	begin
		if X >= Xmin and then X <= Xmax and then Y >= Ymin and then Y <= Ymax then
			-- Test if the current pixel is nearer than the older pixel
			if buffer(X, Y) > Z then
				-- Update the depth of the pixel
				buffer(X, Y) := Z;
				Dessin.Fixe_Pixel(X, Y, V);
			end if;
		end if;
	end;

	-- Reset pixels' depth
	procedure Clear is
	begin
		for x in buffer'Range(1) loop
			for y in buffer'Range(2) loop
				buffer(x, y) := Float'Last;
			end loop;
		end loop;
	end;

begin
	Clear;
end;
