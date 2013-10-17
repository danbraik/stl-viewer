with Dessin; use Dessin;

package Zbuffer is

	-- Reset the buffer
	-- To be call before drawing a new frame
	procedure Clear;

	-- Draw a pixel on screen
	-- Can be called with an invalid position
	procedure DrawPixel(X, Y : Integer ; V : PixLum);
	
	-- Draw a pixel on screen (does not occlude nearest pixel)
	-- MUST NOT be called with an invalid position
	-- Z : depth of the pixel to draw
	procedure DrawPixel(X, Y : Integer ; Z : Float ; V : PixLum);

end;
