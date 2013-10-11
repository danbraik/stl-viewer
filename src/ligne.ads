with Dessin; use Dessin;


package Ligne is
	-- Trace un segment de droite entre (Xa,Ya) et (Xb,Yb)
	procedure Tracer_Segment(Xa, Ya, Xb, Yb : Float);
	procedure Tracer_Segment_LumVar(Xa, Ya, Xb, Yb : Float; Va, Vb : PixLum);

end;
