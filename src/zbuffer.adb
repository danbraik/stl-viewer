
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

	procedure DrawPixel(X, Y : Integer ; Z : Float ; V : PixLum) is
		D : Float := Z;
	begin
		if X >= Xmin and then X <= Xmax and then Y >= Ymin and then Y <= Ymax then
			D := Float'Rounding(D);
			if buffer(X,Y) > D then
				buffer(X, Y) := D;
				Dessin.Fixe_Pixel(X, Y, V);
			end if;
		end if;
	end;

	procedure Clear is

	begin
		for x in buffer'Range(1) loop
			for y in buffer'Range(2) loop
				buffer(x,y) := 99990.0;
			end loop;
		end loop;
	end;

begin
	Clear;
end;
