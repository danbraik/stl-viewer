with Dessin; use Dessin;
with ZBuffer; use ZBuffer;
with Algebre; use Algebre;

-- Advanced draw tools
package Adv_Draw is

	-- Draw a 2D filled triangle
	-- A, B, C : Screen coordinates of the vertices
	-- The Z coo is used for compute Z-depth
	-- Val : color of the triangle	
	procedure DrawFilledTriangle(A, B, C : Vecteur ; Val : PixLum);

end;
