with Dessin; use Dessin;

package Zbuffer is

	procedure Clear;

	procedure DrawPixel(X, Y : Integer ; V : PixLum);
	
	procedure DrawPixel(X, Y : Integer ; Z : Float ; V : PixLum);

end;
