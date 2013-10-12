with Dessin; use Dessin;


package Ligne is
	-- Trace un segment de droite entre (Xa,Ya) et (Xb,Yb)
	procedure Tracer_Segment(Xa, Ya, Xb, Yb : Float);
	-- Draw a colored 2D segment between (Xa,Ya) and (Xb,Yb)
	procedure Tracer_Segment_LumVar(Xa, Ya, Xb, Yb : Float; Val : PixLum);

	procedure Tracer_Segment_LumVar_Z(Xa, Ya, Za, Xb, Yb, Zb: Float; Val : PixLum);
end;
